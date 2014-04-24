from mininet.log import lg

from pyMPTCP_parser import progress

from time import sleep
from subprocess import call

#Five SUBFLOWS needed
def set_TC(args,net):
    ct_name=args.names.client[0]
    sv_name=args.names.server[0]
    client = net.getNodeByName(args.names.client[0])
    server = net.getNodeByName(args.names.server[0])

    eth_dev= "-eth1" 
    ct_dev=[]
    for i in range(args.n):
        eth_dev= '-eth%i' %(i)
        ct_dev.append(ct_name + eth_dev)
        print(ct_dev[i])

    lg.info("****************************  set tc ****************************\n")
    print "arg:"
    print args.arg1
    lg.info('%s\n' %ct_dev)
    for i in range(args.n):
        client.cmdPrint('tc qdisc del dev %s root' %ct_dev[i])

    client.cmdPrint('tc qdisc add dev %s root netem delay %s' %(ct_dev[0],args.arg1))
    client.cmdPrint('tc qdisc add dev %s root netem delay %s' %(ct_dev[1],args.arg2))
    client.cmdPrint('tc qdisc add dev %s root netem delay %s' %(ct_dev[2],args.arg3))
    client.cmdPrint('tc qdisc add dev %s root netem delay %s' %(ct_dev[3],args.arg4))
    client.cmdPrint('tc qdisc add dev %s root netem delay %s' %(ct_dev[4],args.arg5))

    for i in range(args.n):
        client.cmdPrint('tc -s qdisc ls dev %s' %ct_dev[i])
        
    print



def test(args, net):
    print('-------------------Test Begin---------------------')
    seconds = int(args.t)
    ct_name=args.names.client[0]
    sv_name=args.names.server[0]
    client = net.getNodeByName(ct_name)
    server = net.getNodeByName(sv_name)

    lg.info("pinging each destination interface\n")
    
    for i in range(args.n):
        opts = "-DAq "
        n = "20" # ping
        out_ping=client.cmdPrint('ping %s -c %s 172.16.%i.2' % (opts,n,i))
        
       # lg.info("ping test output: %s\n" % out_ping)
        
        ip='172.16.%i.2'%i
        g=open(args.output + args.prepend + '_'+ "ping_"+ip,'w')
        g.write(out_ping)
        g.close()
    

    lg.info("iperfing")
    #iperf options
    #-i report time interval
    #-s server mode
    #-c client mode
    #-m report MTU
    #-M set MSS

    #***** common_args **** 
    report = ' --reportstyle C' if args.csv else ''

    #********* server **********
    opts =' -i 1 -m -M 1460 -w %s' %args.arg1
    cmd = 'iperf -s' + opts + report
    server.sendCmd(cmd)
    
    #********* client **********
    opts =  ' -t %d -i 1 -m -M 1460 -w %s' % (seconds,args.arg1)
    ip = ' 172.16.0.2'
    cmd = 'iperf -c ' + ip + opts + report
    client.sendCmd(cmd)


    progress(seconds + 1)
    client_out = client.waitOutput()
    lg.info("client output:\n%s\n" % client_out)
    sleep(0.1)  # hack to wait for iperf server output.
    server_out = server.read(500000)#
    lg.info("server output: %s\n" % server_out)

    
    ssh_cmd ='/usr/sbin/sshd'
	#dirty way to kill sshd

    cmd='pkill -f "ping -DAq"'
    call(cmd,shell=True)
    sleep(1)
    print('-------------------Test End---------------------')

    return server_out,client_out


