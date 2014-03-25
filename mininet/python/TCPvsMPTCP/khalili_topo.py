#!/usr/bin/python                                                                     

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

class min_topo(Topo):
    class names(object):
        def __init__(self):
            self.names.sender=[]
            self.names.receiver=[]

def khalili2(C1,C2):
    topologie = min_topo()
        #Create private switches (MPTCP)
    SWITCHES_MPTCP = topologie.addSwitch('sw_mptcp1')
            #Create type1 hosts (MPTCP)
    HOSTS_MPTCP = topologie.addHost('h1')
        #Create streaming Servers (TCP)
    SERVERS_TCP = topologie.addHost('sv_tcp1')
        #Create TCP hosts (TCP)
    HOSTS_TCP = topologie.addHost('h_tcp1')
        #Create ONE MPTCP Server (MPTCP)
    SERVER_MPTCP = topologie.addHost('sv_mptcp1')
        #Create ONE AP switch (SHARED) 
    SWITCH_SHARED = topologie.addSwitch('sw_sh1')

  #--left
        #wire up MPTCP hosts and private switches
    topologie.addLink(HOSTS_MPTCP,SWITCHES_MPTCP)
            #wire up MPTCP hosts and shared switch
    topologie.addLink(HOSTS_MPTCP,SWITCH_SHARED)
        #wire up NON MPTCP HOSTS and shared switch
    topologie.addLink(HOSTS_TCP,SWITCH_SHARED)
        #--right   
#wire up SHARED SWITCH and PRIVATE SWITCH
    topologie.addLink(SWITCH_SHARED,SWITCHES_MPTCP)     
        #wire up SHARED SWITCH and TCP SERVER
    topologie.addLink(SWITCH_SHARED,SERVERS_TCP)

    #add 2 links (mptcp)
        #wire up private SWITCH and MPTCP server
    topologie.addLink(SWITCHES_MPTCP,SERVER_MPTCP)

    #Definition
    topologie.names.sender=['h1']
    topologie.names.receiver=['sv_mptcp1']
    topologie.names.multipleLinks_left=['sw_sh1']
    topologie.names.multipleLinks_right=['sv_mptcp1']
    topologie.names.tcp_sender=['h_tcp1']
    topologie.names.tcp_receiver=['sv_tcp1']

    return topologie

def khalili2_options(args,net):

    #Multiple Links :Topo.addLink() impossible 
    #Mininet.addLink() works

    lt_name = args.names.multipleLinks_left[0]
    rt_name = args.names.multipleLinks_right[0]
    left = net.getNodeByName(lt_name)
    right = net.getNodeByName(rt_name)
    net.addLink(left,right)

    return net


def khalili2_test():
    topologie = min_topo()
        #Create private switches (MPTCP)
    SWITCHES_MPTCP = topologie.addSwitch('sw_mptcp1')
            #Create type1 hosts (MPTCP)
    HOSTS_MPTCP = topologie.addHost('h1')
        #Create streaming Servers (TCP)
    SERVERS_TCP = topologie.addHost('sv_tcp1')
        #Create TCP hosts (TCP)
    HOSTS_TCP = topologie.addHost('h_tcp1')
        #Create ONE MPTCP Server (MPTCP)
    SERVER_MPTCP = topologie.addHost('sv_mptcp1')
        #Create ONE AP switch (SHARED) 
    SWITCH_SHARED = topologie.addSwitch('sw_sh1')

  #--left
        #wire up MPTCP hosts and private switches
    topologie.addLink(HOSTS_MPTCP,SWITCHES_MPTCP)
            #wire up MPTCP hosts and shared switch
    topologie.addLink(HOSTS_MPTCP,SWITCH_SHARED)
        #wire up NON MPTCP HOSTS and shared switch
    topologie.addLink(HOSTS_TCP,SWITCH_SHARED)
        #--right   
#wire up SHARED SWITCH and PRIVATE SWITCH
    topologie.addLink(SWITCH_SHARED,SWITCHES_MPTCP)     
        #wire up SHARED SWITCH and TCP SERVER
    topologie.addLink(SWITCH_SHARED,SERVERS_TCP)

    #add 2 links (mptcp)
        #wire up private SWITCH and MPTCP server
    topologie.addLink(SWITCHES_MPTCP,SERVER_MPTCP)

    #Definition
    topologie.names.sender=['h1']
    topologie.names.receiver=['sv_mptcp1']
    topologie.names.multipleLinks_left=['sw_sh1']
    topologie.names.multipleLinks_right=['sv_mptcp1']

    return topologie

def khalili2_test_options(args,net):

    #Multiple Links :Topo.addLink() impossible 
    #Mininet.addLink() works

    lt_name = args.names.multipleLinks_left[0]
    rt_name = args.names.multipleLinks_right[0]
    left = net.getNodeByName(lt_name)
    right = net.getNodeByName(rt_name)
    net.addLink(left,right)

    return net







def PingTest():
    topo = Khalili()
    net = Mininet(topo)
    net.start()
    print "Dump"
    #dumpNodeConnections(net.node)
    print "Testing network connectivity"
    net.pingAll()
    h2.sendCmd('iperf -s -i 1')
    net.stop()

if __name__ == '__main__':
    # Tell mininet to print useful information
    setLogLevel('info')
   # PingTest()


topos = {'test': lambda n: Khalili()}
