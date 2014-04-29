from mininet.log import lg
from pyMPTCP_parser import progress
from time import sleep
import os

def set_TC(args,net):
    
    
    ct_name=args.names.client[0]
    sv_name=args.names.server[0]
    client = net.getNodeByName(args.names.client[0])
    server = net.getNodeByName(args.names.server[0])

    eth_dev = "-eth1" 
    ct_dev = ct_name + eth_dev
    sv_dev = sv_name + eth_dev 

    lg.info("****************************  set tc ****************************\n")
    print "arg:"
    print args.arg1
    lg.info('%s\n' %ct_dev)
    #client.cmdPrint('tc qdisc del dev %s root' %ct_dev)
   # client.cmdPrint('tc qdisc add dev %s root netem delay %s' %(ct_dev,args.arg1))
    eth_dev = "-eth1" 
    sv_dev = sv_name + eth_dev
    ct_dev = ct_name + eth_dev

    client.cmdPrint('tc qdisc del dev %s root' %ct_dev)
    client.cmdPrint('tc qdisc add dev %s root handle 1: htb default 30'%ct_dev)
    client.cmdPrint('tc class add dev %s parent 1: classid 1:1 htb rate 2mbit'%ct_dev)
    client.cmdPrint('tc class add dev %s parent 1: classid 1:2 htb rate 2mbit'%ct_dev)
    client.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.0.0/16 flowid 1:1'%ct_dev)
    client.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip src 172.16.0.0/16 flowid 1:2'%ct_dev)
    client.cmdPrint('tc -s qdisc ls dev %s' %ct_dev)


   
    server.cmdPrint('tc qdisc del dev %s root' %sv_dev)
    server.cmdPrint('tc qdisc add dev %s root handle 1: htb default 30'%sv_dev)
    server.cmdPrint('tc class add dev %s parent 1: classid 1:1 htb rate 2mbit'%sv_dev)
    server.cmdPrint('tc class add dev %s parent 1: classid 1:2 htb rate 2mbit'%sv_dev)
    server.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.0.0/16 flowid 1:1'%sv_dev)
    server.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip src 172.16.0.0/16 flowid 1:2'%sv_dev)

    eth_dev = "-eth0" 
    sv_dev = sv_name + eth_dev    
    ct_dev = ct_name + eth_dev
    server.cmdPrint('tc qdisc del dev %s root' %sv_dev)
    server.cmdPrint('tc qdisc add dev %s root handle 1: htb default 30'%sv_dev)
    server.cmdPrint('tc class add dev %s parent 1: classid 1:1 htb rate 2mbit'%sv_dev)
    server.cmdPrint('tc class add dev %s parent 1: classid 1:2 htb rate 2mbit'%sv_dev)
    server.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.0.0/16 flowid 1:1'%sv_dev)
    server.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip src 172.16.0.0/16 flowid 1:2'%sv_dev)
    server.cmdPrint('tc -s qdisc ls dev %s' %sv_dev)

    client.cmdPrint('tc qdisc del dev %s root' %ct_dev)
    client.cmdPrint('tc qdisc add dev %s root handle 1: htb default 30'%ct_dev)
    client.cmdPrint('tc class add dev %s parent 1: classid 1:1 htb rate 2mbit'%ct_dev)
    client.cmdPrint('tc class add dev %s parent 1: classid 1:2 htb rate 2mbit'%ct_dev)
    client.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip dst 172.16.0.0/16 flowid 1:1'%ct_dev)
    client.cmdPrint('tc filter add dev %s protocol ip parent 1:0 prio 1 u32 match ip src 172.16.0.0/16 flowid 1:2'%ct_dev)
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
    opts =' -i 1 -m -M 1460'
    cmd = 'iperf -s' + opts + report
    server.sendCmd(cmd)
    
    #********* client **********
    opts =  ' -t %d -i 1 -m -M 1460' % seconds
    ip = ' 172.16.0.2'
    cmd = 'iperf -c ' + ip + opts + report
    client.sendCmd(cmd)


    progress(seconds + 1)
    client_out = client.waitOutput()
    lg.info("client output:\n%s\n" % client_out)
    sleep(0.1)  # hack to wait for iperf server output.
    server_out = server.read(500000)#
    lg.info("server output: %s\n" % server_out)

    print('-------------------Test End---------------------')

    return server_out,client_out


