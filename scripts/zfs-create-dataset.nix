{pveIP}:
# sh
''
  #!/usr/bin/env bash

  set -euo pipefail

  PVE_IP=${pveIP}

  read -r -p "Enter ZFS pool name (default: tank): " ZPOOL; ZPOOL=''${ZPOOL:-tank}
  read -r -p "Enter dataset name under pool (default: sabnzbd): " ZDATASET; ZDATASET=''${ZDATASET:-sabnzbd}
  read -r -p "Bootstrap chown to mapped root (base:base)? (y/N): " DO_CHOWN; DO_CHOWN=''${DO_CHOWN:-N}

  ssh root@"''${PVE_IP}" bash -s <<'EOSH' "''${ZPOOL}" "''${ZDATASET}" "''${DO_CHOWN}"
  set -euo pipefail
  ZPOOL="$1"; ZDATASET="$2"; DO_CHOWN="$3"

  # Validate pool
  zpool list -H -o name | grep -qx "$ZPOOL" || { echo "ERROR: zpool '$ZPOOL' not found"; exit 1; }

  DATASET="''${ZPOOL}/''${ZDATASET}"
  if ! zfs list -H -o name | grep -qx "$DATASET"; then
    echo "[+] Creating dataset $DATASET"
    zfs create "$DATASET"
  else
    echo "[=] Dataset $DATASET already exists"
  fi

  echo "[+] Setting properties on $DATASET"
  zfs set compression=lz4        "$DATASET"
  zfs set atime=off              "$DATASET"
  zfs set acltype=posixacl       "$DATASET"
  zfs set aclinherit=passthrough "$DATASET"
  zfs set aclmode=passthrough    "$DATASET"
  zfs set xattr=sa               "$DATASET"

  MOUNTPOINT=$(zfs get -H -o value mountpoint "$DATASET")
  echo "[✓] $DATASET mounted at $MOUNTPOINT"

  if echo "$DO_CHOWN" | grep -qi '^y'; then
    BASE="$(awk -F: '/^root:/{print $2; exit}' /etc/subuid || echo 100000)"
    HOST_UID="$BASE"
    HOST_GID="$BASE"

    echo "[+] Bootstrap chown to mapped root ''${HOST_UID}:''${HOST_GID} at $MOUNTPOINT"
    chown -R "''${HOST_UID}:''${HOST_GID}" "$MOUNTPOINT"
  else
    echo "[i] Skipping bootstrap chown (requested)"
  fi

  echo "[✓] Done."
  EOSH
''
