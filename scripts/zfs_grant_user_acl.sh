#!/usr/bin/env bash

set -euo pipefail

read -r -p "Enter Proxmox IP: " PVE_IP
read -r -p "Enter ZFS pool name (default: test): " ZPOOL; ZPOOL=${ZPOOL:-test}
read -r -p "Enter dataset name under pool (e.g., sabnzbd): " ZDATASET
read -r -p "Enter numeric UID to grant rwx (GID will be assumed equal): " NUM_UID

ssh root@"${PVE_IP}" bash -s <<'EOSH' "${ZPOOL}" "${ZDATASET}" "${NUM_UID}"
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
ZPOOL="$1"; ZDATASET="$2"; NUM_UID="$3"
NUM_GID="$NUM_UID"

need() { command -v "$1" >/dev/null 2>&1 || { apt-get update -y && apt-get install -y "$2"; }; }
need zfs             zfsutils-linux
need setfacl         acl
need getfacl         acl

DATASET="${ZPOOL}/${ZDATASET}"
zfs list -H -o name | grep -qx "$DATASET" || { echo "ERROR: dataset '$DATASET' not found"; exit 1; }
MOUNTPOINT=$(zfs get -H -o value mountpoint "$DATASET")
[ -d "$MOUNTPOINT" ] || { echo "ERROR: mountpoint '$MOUNTPOINT' missing"; exit 1; }

# Ensure POSIX ACL semantics on the dataset (no-op if already set)
zfs set acltype=posixacl       "$DATASET"
zfs set aclinherit=passthrough "$DATASET"
zfs set aclmode=passthrough    "$DATASET"

echo "[+] Applying POSIX ACLs to $DATASET at $MOUNTPOINT for UID=$NUM_UID and GID=$NUM_GID"

# Base inheritable defaults
setfacl -dRm u::rwx,g::rwx,o::rx "$MOUNTPOINT"

# Grant numeric user + group rwx (effective + default)
setfacl -Rm  u:"$NUM_UID":rwx "$MOUNTPOINT"
setfacl -dRm u:"$NUM_UID":rwx "$MOUNTPOINT"
setfacl -Rm  g:"$NUM_GID":rwx "$MOUNTPOINT"
setfacl -dRm g:"$NUM_GID":rwx "$MOUNTPOINT"

echo "[✓] ACLs updated."
echo
echo "[i] getfacl summary:"
getfacl -p "$MOUNTPOINT" | grep -E '^(# )?(user:|group:|other:|mask:|default:)' || true
EOSH

echo "[✓] Done."
