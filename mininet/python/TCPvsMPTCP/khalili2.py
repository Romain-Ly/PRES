#!/usr/bin/python                                                                     


from mininet.topo import Topo
from mininet.net import Mininet
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

class Khalili(Topo):
    "Private Switch"
    def __init__(self,P=3,**opts):
        #Initialize Topology
        Topo.__init__(self,**opts)


        #Host type 1
        hostA = self.addHost('hA1')
        #Host type 2
        hostB = self.addHost('hB1')

        #Private Switch
        switchSp = self.addSwitch('sSP1')
        #Shared Switch
        switchSh = self.addSwitch('sSh1')

        #server classique
        hostS = self.addHost('hS1')
        #server MPTCP
        hostSM = self.addHost('hSM1')


        #wire up type 1 host to private switch
        self.addLink(hostA,switchSp)
        #wire up private switch and streaming MPTCP server
        self.addLink(switchSp,hostSM)

        #wire up type 1 host to shared switch
        self.addLink(hostA,switchSh)
         #wire up to shared switch to private switvh
        self.addLink(switchSh,switchSp)

        #wire up host type 2 to shared switch
        self.addLink(hostB,switchSh)
         #wire up to shared switch to nonMPTCP server
        self.addLink(switchSh,hostS)


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
