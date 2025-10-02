#!/usr/bin/env bash

set -euo pipefail
read -r -p "Enter Proxmox IP: " PVE_IP

UDEV_RULE="/etc/udev/rules.d/99-igpu-drm.rules"
UDEV_GROUP="mediagpu"
UDEV_GID="2999"

echo "[+] Bootstrapping Intel iGPU on ${PVE_IP} (group: ${UDEV_GROUP}:${UDEV_GID})"

ssh root@"${PVE_IP}" bash -s <<'EOSH' "${UDEV_RULE}" "${UDEV_GROUP}" "${UDEV_GID}"
set -euo pipefail
UDEV_RULE="$1"; UDEV_GROUP="$2"; UDEV_GID="$3"

# Fixed group for DRM nodes
if getent group "${UDEV_GROUP}" >/dev/null; then
  gid="$(getent group "${UDEV_GROUP}" | cut -d: -f3)"
  if [ "$gid" != "${UDEV_GID}" ]; then
    echo "[!] Group '${UDEV_GROUP}' exists with gid ${gid}, expected ${UDEV_GID}. Adjust manually."; exit 1
  fi
  echo "[=] Group '${UDEV_GROUP}' already exists with gid ${gid}."
else
  groupadd -g "${UDEV_GID}" "${UDEV_GROUP}"
  echo "[✓] Created group '${UDEV_GROUP}' with gid ${UDEV_GID}."
fi

# Udev rule for /dev/dri/*
cat > "${UDEV_RULE}" <<EOF
# Intel iGPU DRM nodes -> fixed group for container sharing
KERNEL=="renderD*", SUBSYSTEM=="drm", GROUP="${UDEV_GROUP}", MODE="0660"
KERNEL=="card*",    SUBSYSTEM=="drm", GROUP="${UDEV_GROUP}", MODE="0660"
EOF
udevadm control --reload
udevadm trigger --subsystem-match=drm || true
echo "[✓] Installed udev rule and triggered DRM subsystem."

# Ensure i915 autoloads; (re)load now
grep -qxF i915 /etc/modules || { echo i915 >> /etc/modules; echo "[✓] Added 'i915' to /etc/modules."; }
modprobe -r i915 2>/dev/null || true
if modprobe i915 2>/dev/null; then
  echo "[✓] i915 loaded."
else
  echo "[i] Could not load i915 now (maybe needs reboot or BIOS/blacklist check)."
fi

echo "---- Status ----"
lspci | egrep -i 'vga|3d|display' || true
ls -l /dev/dri 2>/dev/null || echo "[i] /dev/dri not present yet (may appear after reboot if kernel just updated)."
echo "---------------"
echo "[done] Host bootstrap complete."
EOSH

echo "[✓] Finished."
