from mininet.log import lg

from pyMPTCP_parser import progress

from time import sleep
from subprocess import call


def set_TC(args,net):
    
    
    ct_name=args.names.client[0]
    sv_name=args.names.server[0]
    client = net.getNodeByName(args.names.client[0])
    server = net.getNodeByName(args.names.server[0])

    eth_dev= "-eth1" 
    ct_dev = ct_name + eth_dev


    lg.info("****************************  set tc ****************************\n")
    print "arg:"
    print args.arg1
    lg.info('%s\n' %ct_dev)
    client.cmdPrint('tc qdisc del dev %s root' %ct_dev)
    client.cmdPrint('tc qdisc add dev %s root netem delay %s' %(ct_dev,args.arg1))
    client.cmdPrint('tc -s qdisc ls dev %s' %ct_dev)

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
        ip='172.16.%i.2'%i
        output = args.output + args.prepend + '_'+ "ping_"+ip 
        opts = "-DAq "
        interval = "0.250"
        n = (float(args.t)-1)/float(interval)
        client.cmd('ping %s -c %d -i %s 172.16.%i.2 > %s &' % (opts,n,interval,i,output)) # ping pendant iperf
        

#    server.cmdPrint("sudo sysctl -w net.ipv4.tcp_rmem='4096 870380 8388608'")


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


