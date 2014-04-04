#!/usr/bin/python


from parser import *
from khalili_topo import *
from khalili_options import *
from experiment import *

from mininet.node import OVSKernelSwitch as Switch
from mininet.util import makeNumeric, custom
from mininet.link import Link, TCLink
from mininet.net import Mininet
from mininet.cli import CLI
from mininet.log import lg


def set_IP(args,net):

    print
    lg.info("**********************set IP**********************\n")
    sd_name=args.names.client[0]
    rv_name=args.names.server[0]
    client = net.getNodeByName(sd_name)
    server = net.getNodeByName(rv_name)
	
    i=1
    for host in net.hosts:
        if (host == server):
            continue
        if (host != client):
            host.setIP('172.16.0.%i' %i,prefixLen=24)#/24
            i+=1
        else:
            client.setIP('172.16.0.%i' %i,prefixLen=24)
            server.setIP('172.16.0.%i' %(i+1),prefixLen=24)
            for j in range(args.n):
                eth_dev= "-eth%i" %j
                sd_dev = sd_name + eth_dev
                rv_dev = rv_name + eth_dev
                
                client.cmdPrint('ifconfig ' + sd_dev + ' 172.16.%i.%i netmask 255.255.255.0' %  (j,i))
                server.cmdPrint('ifconfig ' + rv_dev + ' 172.16.%i.%i netmask 255.255.255.0' %  (j,i+1))
		
        
                if args.verbose:
                    print("-------debug-------")
                    print(sd_dev)
                    print(rv_dev)
                    
                    server.cmdPrint('ifconfig ' + rv_dev)
                    client.cmdPrint('ifconfig ' + sd_dev)
                    print("-------/debug-------")
        
                if args.mptcp:
                    lg.info("configuring source-specific routing tables for MPTCP\n")
            
                    table = '%s' % (j+1)
                    client.cmdPrint('ip rule add from 172.16.%i.%i table %s' % (j,i, table))
                    client.cmdPrint('ip route add 172.16.%i.0/24 dev %s scope link table %s' % (j, sd_dev, table))
                    client.cmdPrint('ip route add default dev %s table %s' % ( sd_dev, table))

#                    client.cmdPrint('ip route add default via 172.16.0.%i dev %s table %s' % (j, sd_dev, table))
            i+=2#client + server
            
    for host in net.hosts:
        print host,host.IP()        
    lg.info("**********************/set IP**********************\n")
    print

def set_TC(args,net):
    
    ct_name=args.names.client[0]
    sv_name=args.names.server[0]
    client = net.getNodeByName(args.names.client[0])
    server = net.getNodeByName(args.names.server[0])

    eth_dev= "-eth1" 
    ct_dev = ct_name + eth_dev

    print

    lg.info("**********************set tc**********************\n")

    lg.info('%s\n' %ct_dev)

    client.cmdPrint('tc qdisc del dev %s root' %ct_dev)
    client.cmdPrint('tc qdisc add dev %s root netem delay 200ms' %ct_dev)
    client.cmdPrint('tc -s qdisc ls dev %s' %ct_dev)
            

    lg.info("**********************/set tc**********************\n")    

    print



def test_MPTCP(args,topo,setup,run,end):
    #set basic link properties
    #TCLink = symetric interfaces
    link = custom(TCLink,bw=args.bw,delay=args.delay)

    net = Mininet(topo=topo, switch=Switch, link=link)
    
    #change of topology required here for multiple links between two node (khalili_topo.py)

    #setup args from parser
    setup(args) 

    #get arguments from class top and put them in args
    set_names(args,topo)

    net = khalili2_test_options(args,net)

    #set ip @
    set_IP(args,net)
    set_TC(args,net)

    #-- ssh (khalili_options.py) create root and make a link to a swtich
    if args.sshd:
        sshd_RootIntf=sshd_connectToRootNS(args,net)

    #creation of class mininet object
    net.start()

    #-- ssh (khalili_options.py) launch ssd in each host
    if args.sshd:
        sshd_start(args,net,sshd_RootIntf)

    #-- cli
    if args.cli:
        print("********************** CLI **********************\n")
        CLI(net)
        print("********************** /CLI **********************\n")

    if args.pause:
        print "press enter to run test"
        raw_input()

    data = run(args, net)#Run functions in experiment.py
    if args.pause:
        print "press enter to finish test"
        raw_input()
 

    net.stop()
    end(args)
    return data

def main():
    args = parse_args()
    lg.setLogLevel('info')
    topo = khalili2_test()
    test_MPTCP(args,topo,setup,test,end) #launch Test
 

if __name__ == '__main__':
    main()
