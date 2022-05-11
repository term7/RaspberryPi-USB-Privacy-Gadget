#bin/sh

# Accept all traffic first to avoid ssh lockdown  via iptables firewall rules #
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT

# Flush All Iptables Chains/Firewall rules #
ip6tables -F

# Delete all Iptables Chains #
ip6tables -X

# Flush all counters too #
ip6tables -Z

# Uncomment to flush and delete all nat and mangle #
#ip6tables -t nat -F
#ip6tables -t nat -X
#ip6tables -t mangle -F
#ip6tables -t mangle -X
#ip6tables iptables -t raw -F
#ip6tables -t raw -X

# Save ip6tables
netfilter-persistent save
