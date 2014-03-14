#!/usr/bin/python                                                                     


from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

class Khalili(Topo):
    "TCP vs MPTCP khalili et al., 2012"

    def __init__(self,P=3,**opts):
        #Initialize Topology
        super(Khalili,self).__init__(**opts)

        #Create private switches and type1 hosts
        switchesA = [self.addSwitch('sA%s' %s) for s in range(1,P+1)]

        hostsA = [self.addHost('hA%s' % h) for h in range(1,P+1)]

        #Create streaming Server and streaming switches
        switchesS = [self.addSwitch('sS%s' %s) for s in range(1,P+1)]
        hostsS = [self.addHost('hS%s' % h) for h in range(1,P+1)]

        #wire up type 1 hosts to private switches
        for hostA, switchA in zip(hostsA,switchesA):
            self.addLink(hostA,switchA)

        #wire up private switches and streaming switches
        for switchS,switchA in zip(switchesS,switchesA):
            self.addLink(switchS,switchA)

        #wire up streaming server and streaming switches
        for hostS, switchS in zip(hostsS,switchesS):
            self.addLink(hostS,switchS)

def PingTest():
    topo = Khalili(P=2)
    net = Mininet(topo)
    net.start()
    print "Dump"
    #dumpNodeConnections(net.node)
    print "Testing network connectivity"
    net.pingAll()
    net.stop()

if __name__ == '__main__':
    # Tell mininet to print useful information
    setLogLevel('info')
    PingTest()
