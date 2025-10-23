#!/usr/bin/env bash
set -euo pipefail

read -r -p "Enter ZFS pool name (default: tank): " ZPOOL
ZPOOL=${ZPOOL:-tank}

ssh root@"${PVE_IP}" bash -s "${ZPOOL}" <<'EOSH'
set -euo pipefail

ZPOOL="$1"
DISK_BY_ID="/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_4TB_S7KGNU0Y707289N"

zpool export -a -f || true

while read -r p; do umount -R "$p" 2>/dev/null || true; done \
  < <(lsblk -ln -o PATH /dev/nvme1n1 | tail -n +2)

wipefs -a "$DISK_BY_ID" || true
sgdisk --zap-all "$DISK_BY_ID" || true
blkdiscard "$DISK_BY_ID" || true

zpool create -f -o ashift=12 "$ZPOOL" "$DISK_BY_ID"
zfs set compression=on "$ZPOOL"

zpool status "$ZPOOL"
echo "[✓] Fresh pool $ZPOOL created."
EOSH
