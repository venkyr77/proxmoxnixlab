{pveIP}:
# sh
''
  #!/usr/bin/env bash

  set -euo pipefail

  PVE_IP=${pveIP}

  read -r -p "Enter ZFS pool name (default: tank): " ZPOOL; ZPOOL=''${ZPOOL:-tank}
  read -r -p "Enter dataset name(s) under pool (comma-separated, default: sabnzbd): " ZDATASETS_RAW
  ZDATASETS_RAW=''${ZDATASETS_RAW:-sabnzbd}

  ssh root@"''${PVE_IP}" bash -s <<'EOSH' "''${ZPOOL}" "''${ZDATASETS_RAW}"
  set -euo pipefail
  ZPOOL="$1"; ZDATASETS_RAW="$2"

  req() { command -v "$1" >/dev/null 2>&1 || { apt-get update -y && apt-get install -y "$1"; }; }
  req zfs

  # Validate pool
  zpool list -H -o name | grep -qx "$ZPOOL" || { echo "ERROR: zpool '$ZPOOL' not found"; exit 1; }

  IFS=',' read -r -a ZDATASETS <<<"$(echo "$ZDATASETS_RAW" | tr -d '[:space:]')"

  for d in "''${ZDATASETS[@]}"; do
    DATASET="''${ZPOOL}/''${d}"
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
  done
  EOSH

  echo "[✓] Done."
''
