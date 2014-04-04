from mininet.log import lg
from parser import progress
from time import sleep

#sudo python ./mptcp_khal.py --bw 10 --mptcp -n 2



def test(args, net):
    print('-------------------Test Begin---------------------')
    seconds = int(args.t)
    sd_name=args.names.client[0]
    rv_name=args.names.server[0]
    client = net.getNodeByName(sd_name)
    server = net.getNodeByName(rv_name)

    lg.info("pinging each destination interface\n")
    for i in range(args.n):
        server_out = server.cmd('ping -c 1 172.16.%i.2' % i)
        lg.info("ping test output: %s\n" % server_out)

    lg.info("iperfing")
    server.sendCmd('iperf -s -i 1')
    

    cmd = 'iperf -c 172.16.0.2 -t %d -i 1' % seconds
    client.sendCmd(cmd)
    progress(seconds + 1)
    client_out = client.waitOutput()
    lg.info("client output:\n%s\n" % client_out)
    sleep(0.1)  # hack to wait for iperf server output.
    out = server.read(10000)
    lg.info("server output: %s\n" % out)

    print('-------------------Test End---------------------')

    return None

