#!/bin/bash

set -e

CA_DIR="/home/admin/tools/CA"
SSL_DIR="$CA_DIR/SSL"
CA_CERT="$CA_DIR/term7-CA.pem"
CA_KEY="$CA_DIR/term7-CA.key"
CNF_FILE="$SSL_DIR/openssl-san.cnf"
DOMAIN="adguard.home"
DAYS=825

cd "$SSL_DIR"

# Only renew if cert expires within 30 days
openssl x509 -checkend $((30 * 86400)) -noout -in "$DOMAIN.crt" && exit 0

# Generate new CSR
openssl req -new -key "$DOMAIN.key" -out "$DOMAIN.csr" -config "$CNF_FILE"

# Sign the new certificate
openssl x509 -req \
  -in "$DOMAIN.csr" \
  -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial \
  -out "$DOMAIN.crt" \
  -days "$DAYS" \
  -extensions v3_req -extfile "$CNF_FILE"

# Create full-chain
cat "$DOMAIN.crt" "$CA_CERT" > "$DOMAIN-fullchain.crt"

# Restart AdGuard Home and nginx
sudo systemctl restart AdGuardHome
sudo systemctl restart nginx