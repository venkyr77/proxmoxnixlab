#!/usr/bin/env bash

set -euo pipefail

read -r -p "Enter Proxmox IP: " PVE_IP
read -r -p "Enter LXC ID: " LXC_ID

CONF_FILE="/etc/pve/lxc/${LXC_ID}.conf"

echo "[+] Ensuring iGPU (/dev/dri) access for LXC ${LXC_ID} on ${PVE_IP}"

ssh root@"${PVE_IP}" bash -s <<EOF
  set -euo pipefail
  CONF_FILE=${CONF_FILE}

  add_line_if_missing() {
    local line="\$1"
    local file="\$2"
    grep -qxF "\$line" "\$file" || echo "\$line" >> "\$file"
  }

  # Allow DRM devices and bind /dev/dri into the container
  add_line_if_missing "lxc.cgroup2.devices.allow: c 226:* rwm" "\$CONF_FILE"
  add_line_if_missing "lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir" "\$CONF_FILE"

  echo "[✓] Updated \$CONF_FILE"
EOF
