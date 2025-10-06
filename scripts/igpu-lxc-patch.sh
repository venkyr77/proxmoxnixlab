#!/usr/bin/env bash

set -euo pipefail

read -r -p "Enter LXC ID: " LXC_ID

ssh root@"${PVE_IP}" bash -s <<'EOSH' "${LXC_ID}"
set -euo pipefail

LXC_ID="$1"
CONF_FILE="/etc/pve/lxc/${LXC_ID}.conf"

add_line_if_missing() {
  local line="$1"
  local file="$2"
  grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

echo "[+] Ensuring iGPU (/dev/dri) access for LXC ${LXC_ID}"

add_line_if_missing "lxc.cgroup2.devices.allow: c 226:* rwm" "$CONF_FILE"
add_line_if_missing "lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir" "$CONF_FILE"

echo "[✓] Updated $CONF_FILE"
EOSH
