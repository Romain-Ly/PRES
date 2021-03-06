#!/usr/bin/python  
        
from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

class Khalili2(Topo):
    "Private Switch"
    def __init__(self,**opts):
        #Initialize Topology
        super(Khalili,self).__init__(**opts)
        
        #Create private switches (MPTCP)
        SWITCHES_MPTCP = self.addSwitch('sw_p1')
        
        #Create type1 hosts (MPTCP)
        HOSTS_MPTCP = self.addHost('h1')

        #Create streaming Servers (TCP)
        SERVERS_TCP = self.addHost('sv_tcp1')

        #Create TCP hosts (TCP)
        HOSTS_TCP = self.addHost('h_tcp1')

        #Create ONE MPTCP Server (MPTCP)
        SERVER_MPTCP = self.addHost('sv_mptcp1')

        #Create ONE AP switch (SHARED) 
        SWITCH_SHARED = self.addSwitch('sw_sh1')

       #-------------Links-------------
        #--left
        #wire up MPTCP hosts and private switches
        self.addLink(HOSTS_MPTCP,SWITCHES_MPTCP)

        #wire up MPTCP hosts and shared switch
        self.addLink(HOSTS_MPTCP,SWITCH_SHARED)

        #wire up NON MPTCP HOSTS and shared switch
        self.addLink(HOSTS_TCP,SWITCH_SHARED)

        #--right        
        #wire up private SWITCH and MPTCP server
        self.addLink(SWITCHES_MPTCP,SERVER_MPTCP)

        #wire up SHARED SWITCH and PRIVATE SWITCH
        self.addLink(SWITCH_SHARED,SWITCHES_MPTCP)

        #wire up SHARED SWITCH and TCP SERVER
        self.addLink(SWITCH_SHARED,SERVERS_TCP)




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
    PingTest()


topos = {'test': lambda n: Khalili()}
