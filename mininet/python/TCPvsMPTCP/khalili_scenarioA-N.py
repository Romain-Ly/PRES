#!/usr/bin/python                                                                     


from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

class Khalili(Topo):
    "TCP vs MPTCP khalili et al., 2012"

    def __init__(self,n1,n2,**opts):
        #Initialize Topology
        super(Khalili,self).__init__(**opts)

        #--------------n1---------------
        #Create private switches (MPTCP)
        SWITCHES_MPTCP = [self.addSwitch('sw_mptcp%s' %s) for s in range(1,n1+1)]

        #Create type1 hosts (MPTCP)
        HOSTS_MPTCP = [self.addHost('h%s' % h) for h in range(1,n1+1)]


        #--------------n2---------------_
        #Create streaming Servers (TCP)
        SERVERS_TCP = [self.addHost('serv_tcp%s' %s) for s in range(1,n2+1)]

        #Create streaming switches (TCP)
        HOSTS_TCP = [self.addHost('h_tcp%s' % h) for h in range(1,n2+1)]


        #------------only one----------
        #Create ONE MPTCP Server (MPTCP)
        SERVER_MPTCP = [self.addHost('serv_mptcp1')]

        #Create ONE AP switch (SHARED) 
        SWITCH_SHARED = [self.addHost('h_shared1')]

       #-------------Links-------------
       #--left
        #wire up MPTCP hosts and private switches
        for A, B in zip(HOSTS_MPTCP,SWITCHES_MPTCP):
            self.addLink(A,B)

        #wire up MPTCP hosts and shared switch
        for A in HOSTS_MPTCP:
            self.addLink(A,SWITCH_SHARED[0])

        #wire up NON MPTCP HOSTS and shared switch
        for A in HOSTS_TCP:
            self.addLink(A,SWITCH_SHARED[0])

        #--right
        #wire up NON MPTCP HOSTS and NON TCP servers
        for A in CP:
            self.addLink(A,SWITCH_SHARED[0])



def PingTest():
    topo = Khalili(n1=2,n2=2)
    net = Mininet(topo)
    net.start()
    print "Dump"
    #dumpNodeConnections(net.node)
    print "Testing network connectivity"
  #  net.pingAll()
    net.stop()

if __name__ == '__main__':
    # Tell mininet to print useful information
    setLogLevel('info')
    PingTest()
