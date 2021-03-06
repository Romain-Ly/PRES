#!/usr/bin/python                                                                     

from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

class min_topo(Topo):
    class names(object):
        def __init__(self):
            self.names.client=[]
            self.names.server=[]


def khalili2hosts():
    topologie = min_topo()
        #Create private switches (MPTCP)
    SWITCHES_MPTCP = topologie.addSwitch('sw_mp1')
            #Create type1 hosts (MPTCP)
    HOSTS_MPTCP = topologie.addHost('h1')
        #Create streaming Servers (TCP)
    SERVERS_TCP = topologie.addHost('sv_tcp1')
        #Create TCP hosts (TCP)
    HOSTS_TCP = topologie.addHost('h_tcp1')
        #Create ONE MPTCP Server (MPTCP)
    SERVER_MPTCP = topologie.addHost('sv_mp1')
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
        #wire up private SWITCH and MPTCP server does not work !!
    topologie.addLink(SWITCHES_MPTCP,SERVER_MPTCP)


    #noms des noeuds utiles pour la configuration du reseau
    topologie.names.client=['h1'] #Client MPTCP
    topologie.names.server=['sv_mp1'] #Serveur MPTCP

    topologie.names.multipleLinks_left=['sw_sh1'] 
    topologie.names.multipleLinks_right=['sv_mp1']
    topologie.names.sw_sshd=['sw_mp1']

    return topologie

def khalili2hosts_options(args,net):

    #Multiple Links :Topo.addLink() impossible 
    #Mininet.addLink() works

    lt_name = args.names.multipleLinks_left[0]
    rt_name = args.names.multipleLinks_right[0]
    left = net.getNodeByName(lt_name)
    right = net.getNodeByName(rt_name)
    net.addLink(left,right)

    if (args.n > 2):
        nb = args.n - 2
        SWITCHES = ['s%i' % i for i in range(1, nb + 1)]
        for sw in SWITCHES:
            net.addSwitch(sw)
        for sw in SWITCHES:
            switch = net.getNodeByName(sw)
            client = net.getNodeByName(args.names.client[0])
            server = net.getNodeByName(args.names.server[0])
            net.addLink(client,switch)
            net.addLink(server,switch)

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
