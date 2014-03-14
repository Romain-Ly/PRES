#!/usr/bin/python


from parser import *
from khalili2 import Khalili2

def main():
    args = parse_args()
    lg.setLogLevel('info')
    topo = khalili()
   

if __name__ == '__main__':
    main()
