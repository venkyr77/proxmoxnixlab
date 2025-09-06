#!/usr/bin/env bash
set -euo pipefail

read -r -p "Enter Proxmox IP: " PVE_IP
read -r -p "Enter export name (e.g. sabnzbd, projects): " EXPORT_NAME

REMOTE_DIR="/export/${EXPORT_NAME}"

echo "[+] Checking ${REMOTE_DIR} on root@${PVE_IP}"
if ssh root@"${PVE_IP}" test -d "${REMOTE_DIR}"; then
    echo "[!] ${REMOTE_DIR} exists on ${PVE_IP}."
    read -r -p "Delete and recreate it? [y/N]: " CONFIRM
    case "${CONFIRM}" in
    y | Y | yes | YES)
        echo "[+] Deleting and recreating ${REMOTE_DIR}"
        ssh root@"${PVE_IP}" bash -s <<EOF
set -euo pipefail
rm -rf ${REMOTE_DIR}
mkdir -p ${REMOTE_DIR}
EOF
        ;;
    *)
        echo "[-] Skipping deletion. Leaving existing directory as-is."
        ;;
    esac
else
    echo "[+] ${REMOTE_DIR} not found. Creating it."
    ssh root@"${PVE_IP}" mkdir -p "${REMOTE_DIR}"
fi

echo "[✓] Done."
