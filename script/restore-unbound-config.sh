#!/bin/bash

# Config Files
UNBOUND_MAIN_CONFIG="/etc/unbound/unbound.conf.d/unbound-dnssec.conf"
UNBOUND_CONFIG="/etc/unbound/unbound.conf.d/local-zones.conf"

# Restore Unbound main configuration
sed -i 's/do-not-query-localhost: no/do-not-query-localhost: yes/' "$UNBOUND_MAIN_CONFIG"
sed -i 's/val-permissive-mode: yes/val-permissive-mode: no/' "$UNBOUND_MAIN_CONFIG"

# Remove TorProxy or WireGuard DNS Config and add fallback setting
sed -i '/fallback-enabled: yes/,$d' "$UNBOUND_CONFIG"
echo "        fallback-enabled: yes" >> "$UNBOUND_CONFIG"
