#bin/sh

# Accept all traffic first to avoid ssh lockdown  via iptables firewall rules #
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Flush All Iptables Chains/Firewall rules #
iptables -F

# Delete all Iptables Chains #
iptables -X

# Flush all counters too #
iptables -Z

# Uncomment to flush and delete all nat and mangle #
#iptables -t nat -F
#iptables -t nat -X
#iptables -t mangle -F
#iptables -t mangle -X
#iptables iptables -t raw -F
#iptables -t raw -X

# Save iptables
netfilter-persistent save
