#/bin/sh

# Since there only can be a wired connection between the Pi and your computer, >
iptables -I INPUT -i usb0 -j ACCEPT

# Allow DNS and HTTP needed for name resolution (Pi-hole) and accessing the Web interface on Wifi-Hotspot:
iptables -A INPUT -p tcp --destination-port 53 -j ACCEPT
iptables -A INPUT -p udp --destination-port 53 -j ACCEPT
iptables -A INPUT -i wlan0 -p tcp --destination-port 80 -j ACCEPT

# Allow SSH also via Wifi-AP:
iptables -A INPUT -i wlan0 -p tcp --destination-port 22 -j ACCEPT

# Allow TCP/IP to do three-way handshakes:
iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# Allow loopback traffic:
iptables -I INPUT -i lo -j ACCEPT

# Allow Wifi-AP:
iptables -I INPUT -i wlan0 -j ACCEPT

# Reject all access from anywhere else:
iptables -P INPUT DROP

# Block HTTPS advertisements to improve blocking ads that are loaded via HTTPS and also deal with QUIC:

iptables -A INPUT -p udp --dport 80 -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp --dport 443 -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp --dport 443 -j REJECT --reject-with icmp-port-unreachable

# Block Ping Requests:
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# Save iptables
netfilter-persistent save
