{pveIP}:
# sh
''
  #!/usr/bin/env bash

  set -euo pipefail

  PVE_IP=${pveIP}

  read -r -p "Enter LXC ID: " LXC_ID

  CONF_FILE="/etc/pve/lxc/''${LXC_ID}.conf"

  echo "[+] Ensuring tun device permissions for LXC ''${LXC_ID} on ''${PVE_IP}"

  ssh root@"''${PVE_IP}" bash -s <<EOF
    set -euo pipefail
    CONF_FILE=''${CONF_FILE}

    add_line_if_missing() {
      local line="\$1"
      local file="\$2"
      grep -qxF "\$line" "\$file" || echo "\$line" >> "\$file"
    }

    add_line_if_missing "lxc.cgroup2.devices.allow: c 10:200 rwm" "\$CONF_FILE"
    add_line_if_missing "lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file" "\$CONF_FILE"

    echo "[✓] Updated \$CONF_FILE"
  EOF
''
