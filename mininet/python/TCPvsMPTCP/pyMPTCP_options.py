#!/usr/bin/python

from mininet.net import Mininet
from mininet.node import Node
from mininet.link import Link
from subprocess import call

#***************** ssh ******************

def sshd_connectToRootNS(args,network):
	
	#we create node root and attach it to a swtich
	switch = network.getNodeByName(args.names.sw_sshd[0])

	#ip of root
	ip = '172.16.255.1/32' 
	
	root = Node( 'root', inNamespace=False )
	intf = Link( root, switch ).intf1
	root.setIP( ip, intf=intf )

	return root,intf

def sshd_start(args,network,RootIntf):
	

	print("**********************set sshd**********************\n")

	cmd = '/usr/sbin/sshd'
	opts = ''.join('-D -o UseDNS=no -u0')#options : '-D -o UseDNS=no -u0' )
	
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


def sshd_stop(net):
	ssh_cmd ='/usr/sbin/sshd'
	
	#dirty way to kill sshd
	cmd='pkill -f "usr/sbin/sshd -D -o UseDNS=no -u0"'
	call(cmd,shell=True)
       


#***************** TCPDUMP ******************
def tcpdump_start(args,net):
	ct_name=args.names.client[0]
	sv_name=args.names.server[0]
	client = net.getNodeByName(ct_name)
	server = net.getNodeByName(sv_name)

	cmd = 'tcpdump'


	print("**********************set tcpdump**********************\n")
	for j in range(args.n):
		eth_dev= "-eth%i" %j
		client_if  = args.names.client[0] + eth_dev
		client_filename = args.output + args.prepend + '_tcpdump_' + client_if + args.shark

		client_cmd = cmd + ' -i ' + client_if + ' -w ' + client_filename  + ' &' 

		server_if  = args.names.server[0] + eth_dev
		server_filename = args.output + args.prepend + '_tcpdump_' + server_if + args.shark

		server_cmd = cmd + ' -i ' + server_if + ' -w ' + server_filename + ' &'

		client.cmdPrint(client_cmd)
		server.cmdPrint(server_cmd)


#def tcpdump_stop(args,net):
	#not needed


#***************** bwm-ng ******************

def bwm_start(args,net):
	ct_name=args.names.client[0]
	sv_name=args.names.server[0]
	client = net.getNodeByName(ct_name)
	server = net.getNodeByName(sv_name)

	cmd = 'bwm-ng'

	print("**********************set bwm-ng**********************\n")
	for j in range(args.n):
		#-D daemon
		#-O output mode
		#-t time (ms)
		#-u unit
		
		eth_dev= "-eth%i" %j
		opts = ' -D 1 -o csv -t 100 -T rate' #start with a space

		client_if  = args.names.client[0] + eth_dev
		client_opts = ' -I ' + client_if + opts #start with a space
		client_filename = args.output + args.prepend + '_bwm_' + client_if + '.csv'

		client_cmd = cmd + client_opts + ' -F ' + client_filename  + ' &' 

		server_if  = args.names.server[0] + eth_dev
		server_opts = ' -I ' + server_if + opts
		server_filename = args.output + args.prepend + '_bwm_' + server_if + '.csv'

		server_cmd = cmd + server_opts + ' -F ' + server_filename + ' &'

		client.cmdPrint(client_cmd)
		server.cmdPrint(server_cmd)

	return client_cmd,server_cmd
		
def bwm_stop():
	print("-----kill bwm-ng-----")
	#dirty way to kill 
	cmd='pkill -f "bwm-ng"'
	print cmd
	call(cmd,shell=True)

def iperf_output(args,data):
    output_name=["_server","_client"]
    for i in range(2):
        f=open(args.output + args.prepend + '_'+ args.file+output_name[i],'w')
        f.write(data[i])
        f.close()

def iperf_stop():
	print("-----kill iperf-----")
	#dirty way to kill 
	cmd='pkill -f "iperf"'
	print cmd
	call(cmd,shell=True)
       
