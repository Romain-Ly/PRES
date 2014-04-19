from mininet.log import lg

from pyMPTCP_parser import progress

from time import sleep

#sudo python ./mptcp_khal.py --bw 10 --mptcp -n 2

def set_TC(args,net):
    
    
    ct_name=args.names.client[0]
    sv_name=args.names.server[0]
    client = net.getNodeByName(args.names.client[0])
    server = net.getNodeByName(args.names.server[0])

    eth_dev= "-eth1" 
    ct_dev = ct_name + eth_dev


    lg.info("****************************  set tc ****************************\n")

    lg.info('%s\n' %ct_dev)
    client.cmdPrint('tc qdisc del dev %s root' %ct_dev)
    client.cmdPrint('tc qdisc add dev %s root netem delay 300ms' %ct_dev)
    client.cmdPrint('tc -s qdisc ls dev %s' %ct_dev)

    print



def test(args, net):
    print('-------------------Test Begin---------------------')
    seconds = int(args.t)
    sd_name=args.names.client[0]
    rv_name=args.names.server[0]
    client = net.getNodeByName(sd_name)
    server = net.getNodeByName(rv_name)

    lg.info("pinging each destination interface\n")
    for i in range(args.n):
        client.cmd('ping -c 1 172.16.%i.2' % i)
        
    lg.info("iperfing")
    #iperf options
    #-i report time interval
    #-s server mode
    #-c client mode
    #-m report MTU
    #-M set MSS

    #***** common_args **** 
    report = ' --reportstyle C -o /dev/null' if args.csv else ''

    #********* server **********
    opts =' -i 1 -m -M 1460'
    cmd = 'iperf -s' + opts + report
    server.sendCmd(cmd)
    
    #********* client **********
    opts =  ' -t %d -i 1 -m -M 1460' % seconds
    ip = ' 172.16.0.2'
    cmd = 'iperf -c ' + ip + opts + report
    client.sendCmd(cmd)


    progress(seconds + 1)
    client_out = client.waitOutput()
    lg.info("client output:\n%s\n" % client_out)
    sleep(0.1)  # hack to wait for iperf server output.
    server_out = server.read(500000)#
    lg.info("server output: %s\n" % server_out)

    print('-------------------Test End---------------------')

    return server_out,client_out


