#!/usr/bin/env bash

set -euo pipefail

ssh root@"${PVE_IP}" bash -s "${TS_PATCH_NEEDED_HOSTS[@]}" <<'EOSH'
set -euo pipefail

TS_PATCH_NEEDED_HOSTS=("$@")

add_line_if_missing() {
  local line="$1"
  local file="$2"
  grep -qxF "$line" "$file" || echo "$line" >> "$file"
}

patch_ct() {
  local lxc_id="$1"
  local conf_file="/etc/pve/lxc/${lxc_id}.conf"

  echo "[+] Ensuring tun device permissions for LXC ${lxc_id}"

  add_line_if_missing "lxc.cgroup2.devices.allow: c 10:200 rwm" "$conf_file"
  add_line_if_missing "lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file" "$conf_file"

  echo "[✓] Updated $conf_file"
}

for ct in "${TS_PATCH_NEEDED_HOSTS[@]}"; do
  patch_ct "$ct"
done
EOSH
