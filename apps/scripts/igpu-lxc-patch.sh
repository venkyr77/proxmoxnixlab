#!/usr/bin/env bash

set -euo pipefail

ssh root@"${PVE_IP}" bash -s "${IGPU_PATCH_NEEDED_HOSTS[@]}" <<'EOSH'
set -euo pipefail

IGPU_PATCH_NEEDED_HOSTS=("$@")

add_line_if_missing() {
  local line="$1"
  local file="$2"
  grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

patch_ct() {
  local lxc_id="$1"
  local conf_file="/etc/pve/lxc/${lxc_id}.conf"

  echo "[+] Ensuring iGPU (/dev/dri) access for LXC ${lxc_id}"

  add_line_if_missing "lxc.cgroup2.devices.allow: c 226:* rwm" "$conf_file"
  add_line_if_missing "lxc.mount.entry: /dev/dri dev/dri none bind,optional,create=dir" "$conf_file"

  echo "[✓] Updated $conf_file"
}

for ct in "${IGPU_PATCH_NEEDED_HOSTS[@]}"; do
  patch_ct "$ct"
done
EOSH
