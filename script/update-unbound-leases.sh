#!/bin/bash

# Loop through each interface (wlan0 and usb0)
for iface in wlan0 usb0; do
    # Define lease file and corresponding Unbound zone file paths for the interface
    LEASE_FILE="/var/lib/NetworkManager/dnsmasq-${iface}.leases"
    UNBOUND_ZONE_FILE="/var/lib/unbound/unbound-${iface}.zone"

    # If the lease file doesn't exist or is empty, create a placeholder zone file
    if [[ ! -s "$LEASE_FILE" ]]; then
        echo "; Unbound generated zone file - No active leases found" > "$UNBOUND_ZONE_FILE"
        continue
    fi

    # Initialize a new Unbound zone file with a header comment
    echo "; Unbound generated zone file from dnsmasq leases" > "$UNBOUND_ZONE_FILE"

    # Process each lease entry in the lease file
    while read -r LEASE_TIME MAC_ADDR IP HOSTNAME CLIENTID; do
        # Skip the entry if the IP address is missing
        if [[ -z "$IP" ]]; then
            continue
        fi

        # Set hostname to 'UNKNOWN' if it's missing or a placeholder '*'
        if [[ -z "$HOSTNAME" || "$HOSTNAME" == "*" ]]; then
            HOSTNAME="UNKNOWN"
        fi

        # Convert the IP address into PTR record format (reverse order)
        PTR_IP=$(echo "$IP" | awk -F. '{print $4"."$3"."$2"."$1}')
        # Append the PTR record to the Unbound zone file
        echo "$PTR_IP.in-addr.arpa. 86400 IN PTR $HOSTNAME." >> "$UNBOUND_ZONE_FILE"
    done < "$LEASE_FILE"
done

# Reload Unbound to apply the updated zone files
systemctl reload unbound