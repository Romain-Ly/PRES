#!/usr/bin/python


from parser import *
from khalili_topo import *
from experiment import *

from mininet.node import OVSKernelSwitch as Switch
from mininet.util import makeNumeric, custom
from mininet.link import Link, TCLink
from mininet.net import Mininet

def test_MPTCP(args,topo,setup,run,end):
    link = custom(TCLink,bw=args.bw)
    net = Mininet(topo=topo, switch=Switch, link=link)
 
    setup(args) 
    set_names(args,topo)
    print(args)

    #change of topology required for multiple links between two node
    net = khalili2_test_options(args,net)

    net.start()
    if args.pause:
        print "press enter to run test"
        raw_input()
    data = run(args, net)
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
    test_MPTCP(args,topo,setup,test,end) #OVSKernel
 

if __name__ == '__main__':
    main()
