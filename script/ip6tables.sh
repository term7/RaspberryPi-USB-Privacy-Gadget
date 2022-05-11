#/bin/sh

# Since there only can be one wired connection between the Pi and your computer, allow all traffic on usb0:
ip6tables -I INPUT -i usb0 -j ACCEPT

# Allow DNS and HTTP needed for name resolution (Pi-hole) and accessing the Web interface:
ip6tables -A INPUT -p tcp --destination-port 53 -j ACCEPT
ip6tables -A INPUT -p udp --destination-port 53 -j ACCEPT
ip6tables -A INPUT -i wlan0 -p tcp --destination-port 80 -j ACCEPT

# Allow SSH also for Wifi-AP:
ip6tables -A INPUT -i wlan0 -p tcp --destination-port 22 -j ACCEPT

# Allow TCP/IP to do three-way handshakes:
ip6tables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow loopback traffic:
ip6tables -I INPUT -i lo -j ACCEPT

# Reject all access from anywhere else:
ip6tables -P INPUT DROP

# Block HTTPS advertisements to improve blocking ads that are loaded via HTTPS and also deal with QUIC:

ip6tables -A INPUT -p udp --dport 80 -j REJECT --reject-with icmp6-port-unreachable
ip6tables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset
ip6tables -A INPUT -p udp --dport 443 -j REJECT --reject-with icmp6-port-unreachable

# Block Ping Requests:
ip6tables -A INPUT -p icmp -j DROP

# Save ip6tables
netfilter-persistent save
