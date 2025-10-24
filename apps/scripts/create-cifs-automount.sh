#!/usr/bin/env bash

set -euo pipefail

DATASET="${DATASET:-${1:-}}"
if [[ -z ${DATASET} ]]; then
  read -r -p "Enter NAS dataset name: " DATASET
fi

CIFS_USER="${CIFS_USER:-${2:-}}"
if [[ -z ${CIFS_USER} ]]; then
  read -r -p "Enter NAS username for $DATASET: " CIFS_USER
fi

DO_CHOWN="${DO_CHOWN:-${3:-}}"
if [[ -z ${DO_CHOWN} ]]; then
  read -r -p "Bootstrap chown to mapped root (base:base)? (y/N): " DO_CHOWN
fi

MOUNT_AS_UID="${MOUNT_AS_UID:-${4:-}}"
if [[ -z ${MOUNT_AS_UID} ]]; then
  read -r -p "Enter UID(GID will be assumed equal) to mount as: " MOUNT_AS_UID
fi

read -r -s -p "Enter NAS password for $DATASET: " CIFS_PASS
echo

echo "DATASET=$DATASET, CIFS_USER=$CIFS_USER, DO_CHOWN=$DO_CHOWN, MOUNT_AS_UID=$MOUNT_AS_UID"

CRED_FILE_LOCAL=$(mktemp)
chmod 600 "$CRED_FILE_LOCAL"
{
  echo "username=$CIFS_USER"
  echo "password=$CIFS_PASS"
} >"$CRED_FILE_LOCAL"

scp "$CRED_FILE_LOCAL" root@"${PVE_IP}":/root/.smbcredentials-"${DATASET}"
rm -f "$CRED_FILE_LOCAL"

ssh root@"${PVE_IP}" bash -s "$DATASET" "$NAS_IP" "$DO_CHOWN" "$MOUNT_AS_UID" <<'EOSH'
set -euo pipefail

DATASET="$1"; NAS_IP="$2"; DO_CHOWN="$3"; MOUNT_AS_UID="$4"; MOUNT_AS_GID="$MOUNT_AS_UID";

if echo "$DO_CHOWN" | grep -qi '^y'; then
  BASE="$(awk -F: '/^root:/{print $2; exit}' /etc/subuid || echo 100000)"
  HOST_UID=$(("$BASE" + "$MOUNT_AS_UID"))
  HOST_GID=$(("$BASE" + "$MOUNT_AS_GID"))
else
  HOST_UID="$MOUNT_AS_UID"
  HOST_GID="$MOUNT_AS_GID"
fi

CRED_FILE="/root/.smbcredentials-${DATASET}"
MOUNT_POINT="/mnt/${DATASET}"
NAS_PATH="//${NAS_IP}/${DATASET}"
UNIT_NAME="mnt-${DATASET}.mount"

echo "[+] Creating ${MOUNT_POINT}"
mkdir -p "${MOUNT_POINT}"

echo "[+] Writing systemd mount unit: /etc/systemd/system/${UNIT_NAME}"
cat > "/etc/systemd/system/${UNIT_NAME}" <<UNIT
[Unit]
Description=Mount ${MOUNT_POINT} (NAS)
After=network-online.target
Wants=network-online.target

[Mount]
What=${NAS_PATH}
Where=${MOUNT_POINT}
Type=cifs
Options=credentials=${CRED_FILE},iocharset=utf8,nounix,noserverino,vers=3.0,uid=${HOST_UID},gid=${HOST_GID}

[Install]
WantedBy=multi-user.target
UNIT

echo "[+] Reloading systemd and enabling mount unit ${UNIT_NAME}"
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now "${UNIT_NAME}"

echo "[✓] CIFS automount configured for ${DATASET} at ${MOUNT_POINT}"
EOSH
