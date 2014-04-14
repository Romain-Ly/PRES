
#!/usr/bin/python

import sys
import argparse
import termcolor as T

from time import sleep
from mininet.log import lg
from subprocess import Popen, PIPE


def progress(t):
    while t > 0:
        print T.colored('  %3d seconds left  \r' % (t), 'cyan'),
        t -= 1
        sys.stdout.flush()
        sleep(1)
    print '\r\n'

def sysctl_set(key, value):
    """Issue systcl for given param to given value and check for error."""
    p = Popen("sysctl -w %s=%s" % (key, value), shell=True, stdout=PIPE,
              stderr=PIPE)
    # Output should be empty; otherwise, we have an issue.  
    stdout, stderr = p.communicate()
    stdout_expected = "%s = %s\n" % (key, value)
    if stdout != stdout_expected:
        raise Exception("Popen returned unexpected stdout: %s != %s" %
                        (stdout, stdout_expected))
    if stderr:
        raise Exception("Popen returned unexpected stderr: %s" % stderr)


def set_mptcp_enabled(enabled):
    """Enable MPTCP if true, disable if false"""
    e = 1 if enabled else 0
    lg.info("***** setting MPTCP enabled to %s\n *****" % e)
    sysctl_set('net.mptcp.mptcp_enabled', e)

def set_args(args):
    #--cli
    args.cli =1 if args.cli else 0

    #pause
    args.pause = 1 if args.pause else 0
    
    #tc
    args.tc =1 if args.tc else 0

    #--sshd
    if args.sshd:
         args.cli = 1
         args.pause =1
    args.sshd =1 if args.sshd else 0

    #verbose
    args.verbose = 1 if args.verbose else 0

    #csv
    args.csv = 1 if args.csv else 0
    
    #output folder
    temp = args.output
    args.output = './'+ temp +'/'

    #prepend
    if len(args.prepend)==0:
        args.prepend = args.open
    else:
        args.prepend = args.open +'_' + args.prepend
        
    #file
    if len(args.file)>0:
        args.file_write=True
    else:
        args.file_write=False
        


    #tcpdump
    if args.shark:
        args.dump=1
        args.shark=".pcap"
    else:
        args.dump = 1 if args.dump else 0
        args.shark=""

    #bwm-ng
    args.bwm_ng = 1 if args.bwm_ng else 0
        

def set_mptcp_ndiffports(ports):
    """Set ndiffports, the number of subflows to instantiate"""
    lg.info("***** setting MPTCP ndiffports to %s\n *****" % ports)
    sysctl_set("net.mptcp.mptcp_ndiffports", ports)

def parse_args():
    parser = argparse.ArgumentParser(description="MPTCP 2-host n-switch test"
)
    parser.add_argument('--verbose','-v',
                        action="store_true",
                        help="verbose",
                        required=False,
                        default =False)
    
    parser.add_argument('--tc',
                        action="store_true",
                        help="use set TC functions",
                        required=False,
                        default =False)
    

    parser.add_argument('--sshd',
                        action="store_true",
                        help="Launch sshd on all hosts",
                        required=False,
                        default =False)

    parser.add_argument('--cli',
                        action="store_true",
                        help="Launch CLI",
                        required=False,
                        default =False)

    parser.add_argument('--csv',
                        action="store_true",
                        help="report iperf in csv",
                        required=False,
                        default =False)

    parser.add_argument('--dump',
                        action="store_true",
                        help="launch tcpdump on MPTCP interfaces",
                        required=False,
                        default=False)

    parser.add_argument('--shark',
                        action="store_true",
                        help="like dump but pcap output",
                        required=False,
                        default=False)


    parser.add_argument('--bwm_ng',
                        action="store_true",
                        help="launch bwm-ng on host interfaces",
                        required=False,
                        default=False)
    

    parser.add_argument('--output',
                        action="store",
                        help="output folder",
                        required=False,
                        default="output")

    parser.add_argument('--prepend',
                        action="store",
                        help="prepend sting for output files names",
                        required=False,
                        default="")

    parser.add_argument('--postpend',
                        action="store",
                        help="postpend string for output files names",
                        required=False,
                        default="")

    parser.add_argument('--open','-O',
                        action="store",
                        help="experiment files ex: experiment.py",
                        required=True)

    parser.add_argument('--file', '-F',
                        action="store",
                        help="Output File",
                        required=False,
                        default="iperf")

    parser.add_argument('--bw', '-B',
                        action="store",
                        help="Bandwidth of links",
                        required=True)

    parser.add_argument('--delay', '-D',
                        action="store",
                        help="Delay of links : --delay 10ms",
                        default='10ms')
    
    parser.add_argument('-n',
                        action="store",
                        help="Number of switches.  Must be >= 2",
                        default=2)
    
    parser.add_argument('-t',
                        action="store",
                        help="Seconds to run the experiment",
                        default=2)
    
    parser.add_argument('--mptcp',
                        action="store_true",
                        help="Enable MPTCP (net.mptcp.mptcp_enabled)",
                        default=False)

    parser.add_argument('--pause',
                        action="store_true",
                        help="Pause before test start & end (to use wireshark)",
                        default=False)

    parser.add_argument('--ndiffports',
                        action="store",
                        help="Set # subflows (net.mptcp.mptcp_ndiffports)",
                        default=1)

    parser.add_argument('--arg1',
                        action="store",
                        help="optional argument 1",
                        required=False,
                        default="")

    parser.add_argument('--arg2',
                        action="store",
                        help="optional argument 2",
                        required=False,
                        default="")

    parser.add_argument('--arg3',
                        action="store",
                        help="optional argument 3",
                        required=False,
                        default="")

    parser.add_argument('--arg4',
                        action="store",
                        help="optional argument 4",
                        required=False,
                        default="")

    parser.add_argument('--arg5',
                        action="store",
                        help="optional argument 5",
                        required=False,
                        default="")




    args = parser.parse_args()
    args.bw = float(args.bw)
    args.delay=str(args.delay)
    args.n = int(args.n)
    args.ndiffports = int(args.ndiffports)
    return args


def setup(args):
    set_mptcp_enabled(args.mptcp)
    set_mptcp_ndiffports(args.ndiffports)
    set_args(args)#ssd,cli,verbose, csv,pause,tc


def end(args):
    set_mptcp_enabled(False)
    set_mptcp_ndiffports(1)


def set_names(args,topo):
    args.names=topo.names
