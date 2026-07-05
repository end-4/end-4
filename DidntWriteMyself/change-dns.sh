#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo)"
  exit 1
fi

echo "Configuring systemd-resolved for secure DNS..."

RESOLV_CONF="/etc/systemd/resolved.conf"
DNS_SERVERS="1.1.1.1 1.0.0.1"
FALLBACK_SERVERS="9.9.9.9"

# 1. Strip out any existing active or commented DNS lines to prevent duplicates
sed -i '/^#\?DNS=/d' "$RESOLV_CONF"
sed -i '/^#\?FallbackDNS=/d' "$RESOLV_CONF"

# 2. Append the new configuration under the [Resolve] section
# (Using sed to inject them cleanly right below the [Resolve] header)
sed -i "/^\[Resolve\]/a DNS=${DNS_SERVERS}\nFallbackDNS=${FALLBACK_SERVERS}" "$RESOLV_CONF"

# 3. Restart the resolver service to apply changes
systemctl restart systemd-resolved

echo "✓ System-wide DNS successfully updated to Cloudflare ($DNS_SERVERS)."
echo "Verification:"
resolvectl status | grep "DNS Servers" -A 2
