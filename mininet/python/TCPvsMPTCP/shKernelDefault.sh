#default config "coupled"

sysctl -w net.ipv4.tcp_congestion_control="coupled"
sysctl -w net.core.rmem_default='163840'
sysctl -w net.core.wmem_default='163840'
sysctl -w net.core.wmem_max='163840'
sysctl -w net.core.rmem_max='163840'
sysctl -w net.ipv4.tcp_wmem='4096 16384 4194304'
sysctl -w net.ipv4.tcp_rmem='4096 87380 6291456'
sysctl -w net.ipv4.tcp_mem='19326 25768 38652'
sysctl -w net.ipv4.route.flush=1

#should be 1
sysctl net.ipv4.tcp_window_scaling
sysctl net.ipv4.tcp_timestamps
sysctl net.ipv4.tcp_sack