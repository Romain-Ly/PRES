#!/usr/bin/python

from mininet.net import Mininet
from mininet.node import Node
from mininet.link import Link

def sshd_connectToRootNS(args,network):
	
	#we create node root and attach it to a swtich
	switch = network.getNodeByName(args.names.sw_sshd[0])
	#print args.names.sw_sshd[0]

	#ip of root
	ip = '172.16.255.1/32' 
	
	root = Node( 'root', inNamespace=False )
	intf = Link( root, switch ).intf1
	root.setIP( ip, intf=intf )

	return root,intf

def sshd_start(args,network,RootIntf):
	

	lg.info("**********************set sshd**********************\n")

	cmd = '/usr/sbin/sshd'
	opts = ''.join('-o UseDNS=no -u0')#options : '-D -o UseDNS=no -u0' )
	
	print "sshd arguments"
	print(opts)

	#routing table
	routes = ['172.16.0.0/16']
	root = RootIntf[0]
	intf = RootIntf[1]

	# Add routes from root to hosts networks
	for route in routes:
		print route
		root.cmd( 'route add -net ' + route + ' dev ' + str( intf ) )

	#start ssd in each host
	for host in network.hosts:
		sshcmd =  cmd + ' ' + opts + '&' 
		out=host.cmd(sshcmd)


	print
        print "*** Hosts are running sshd at the following addresses:"
        print
        for host in network.hosts:
            print host.name, host.IP()
#	    cmd = 'ping -c 1 ' + host.IP()
#	    print cmd
#	    out=root.cmd(cmd)
#	    print out
        print


	lg.info("**********************/set sshd**********************\n")
