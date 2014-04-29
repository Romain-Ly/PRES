#check


sysctl net.ipv4.tcp_congestion_control
sysctl net.core.wmem_max
sysctl net.core.wmem_default
sysctl net.core.rmem_max
sysctl net.core.rmem_default
sysctl net.ipv4.tcp_wmem
sysctl net.ipv4.tcp_rmem
sysctl net.ipv4.tcp_mem
sysctl net.ipv4.route.flush

#mptcp
sysctl net.mptcp.mptcp_path_manager


#should be 1
sysctl net.ipv4.tcp_window_scaling
sysctl net.ipv4.tcp_timestamps
sysctl net.ipv4.tcp_sack