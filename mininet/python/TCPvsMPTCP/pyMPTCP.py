#!/usr/bin/python


from pyMPTCP_parser import *
from pyMPTCP_topo import *
from pyMPTCP_options import *

import importlib


from mininet.node import OVSKernelSwitch as Switch
from mininet.util import makeNumeric, custom
from mininet.link import Link, TCLink
from mininet.net import Mininet
from mininet.cli import CLI
from mininet.log import lg


def kill_daemons(args,net):
    print
    if args.bwm_ng:
        bwm_stop()
    if args.sshd: #kill sshd
        sshd_stop(net)
    iperf_stop()
    print

def set_IP(args,net):

    print
    lg.info("**************************** set IP ****************************\n")
    ct_name=args.names.client[0]
    sv_name=args.names.server[0]
    client = net.getNodeByName(ct_name)
    server = net.getNodeByName(sv_name)
	
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
                ct_dev = ct_name + eth_dev
                sv_dev = sv_name + eth_dev
                
                client.cmdPrint('ifconfig ' + ct_dev + ' 172.16.%i.%i netmask 255.255.255.0' %  (j,i))
                server.cmdPrint('ifconfig ' + sv_dev + ' 172.16.%i.%i netmask 255.255.255.0' %  (j,i+1))
		
        
                if args.verbose:
                    print("-------debug-------")
                    print(ct_dev)
                    print(sv_dev)
                    
                    server.cmdPrint('ifconfig ' + sv_dev)
                    client.cmdPrint('ifconfig ' + ct_dev)
                    print("-------/debug-------")
        
                if args.mptcp:
                    lg.info("configuring source-specific routing tables for MPTCP\n")
            
                    table = '%s' % (j+1)
                    client.cmdPrint('ip rule add from 172.16.%i.%i table %s' % (j,i, table))
                    client.cmdPrint('ip route add 172.16.%i.0/24 dev %s scope link table %s' % (j, ct_dev, table))
                    client.cmdPrint('ip route add default dev %s table %s' % ( ct_dev, table))

#                    client.cmdPrint('ip route add default via 172.16.0.%i dev %s table %s' % (j, ct_dev, table))
            i+=2#client + server
            
    for host in net.hosts:
        print host,host.IP()        
    
    print




def run_MPTCP(args,topo,exp,end):
    #set basic link properties
    #TCLink = symetric interfaces
    link = custom(TCLink,bw=args.bw,delay=args.delay)

    net = Mininet(topo=topo, switch=Switch, link=link)
    


    #get arguments from class top and put them in args
    set_names(args,topo)

    #modification of topology (add new links, ...)
    net = khalili2hosts_options(args,net)

    #set ip @
    set_IP(args,net)
    if args.tc:
        exp.set_TC(args,net)

    #-- ssh (pyMPTCP_options.py) create root and make a link to a swtich
    if args.sshd:
        sshd_RootIntf=sshd_connectToRootNS(args,net)


#********************************************************************
#creation of class mininet object
    net.start()
#********************************************************************

    #-- ssh (pyMPTCP_options.py) launch ssd in each host
    if args.sshd:
        sshd_start(args,net,sshd_RootIntf)

    #tcpdump
    if args.dump:
        tcpdump_start(args,net)

    #bwm-ng
    if args.bwm_ng:
        bwm_start(args,net)

    #-- cli
    if args.cli:
        print("********************** CLI **********************\n")
        CLI(net)


    data = exp.test(args, net)#Run functions in experiment.py

    if args.pause:
        print "press enter to end experiment"
        raw_input()

    #write iperf output
    output_name=["_server","_client"]
    if args.file_write:
        for i in range(2):
            f=open(args.output + args.prepend + '_'+ args.file+output_name[i],'w')
            f.write(data[i])
            f.close()

    kill_daemons(args,net)

    net.stop()
    end(args)

    return data

def main():
    args = parse_args()

    #setup args from parser
    setup(args) 

    exp = importlib.import_module("."+args.open,package="experiment")

    lg.setLogLevel('info')
    topo = khalili2hosts()

    data = run_MPTCP(args,topo,exp,end) #launch Test
        
if __name__ == '__main__':
    main()
