#!/usr/bin/env bash
set -euo pipefail

read -r -p "Enter Proxmox IP: " PVE_IP
read -r -p "Enter NAS IP: " NAS_IP
read -r -p "Enter NAS dataset name (e.g. media, projects): " DATASET
read -r -p "Enter NAS username for $DATASET: " CIFS_USER
read -r -s -p "Enter NAS password for $DATASET: " CIFS_PASS
echo

CRED_FILE="/root/.smbcredentials-${DATASET}"
MOUNT_POINT="/mnt/${DATASET}"
NAS_PATH="//${NAS_IP}/${DATASET}"
UNIT_NAME="mnt-${DATASET}.mount"

echo "[+] Setting up CIFS automount for '${DATASET}' on root@${PVE_IP} using ${NAS_PATH}"

ssh root@"${PVE_IP}" bash -s <<EOF
  set -euo pipefail

  echo "[+] Creating ${MOUNT_POINT}"
  mkdir -p ${MOUNT_POINT}

  echo "[+] Writing ${CRED_FILE}"
  cat > ${CRED_FILE} <<CRED
username=${CIFS_USER}
password=${CIFS_PASS}
CRED
  chmod 600 ${CRED_FILE}

  echo "[+] Writing systemd mount unit: /etc/systemd/system/${UNIT_NAME}"
  cat > /etc/systemd/system/${UNIT_NAME} <<UNIT
[Unit]
Description=Mount ${MOUNT_POINT} (NAS)
After=network-online.target
Wants=network-online.target

[Mount]
What=${NAS_PATH}
Where=${MOUNT_POINT}
Type=cifs
Options=credentials=${CRED_FILE},iocharset=utf8,nounix,noserverino,vers=3.0

[Install]
WantedBy=multi-user.target
UNIT

  echo "[+] Reloading systemd and enabling mount unit ${UNIT_NAME}"
  systemctl daemon-reexec
  systemctl daemon-reload
  systemctl enable --now ${UNIT_NAME}

  echo "[✓] CIFS automount configured for '${DATASET}' at ${MOUNT_POINT}"
EOF
