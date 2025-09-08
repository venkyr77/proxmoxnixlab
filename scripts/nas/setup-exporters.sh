#!/usr/bin/env bash

set -euo pipefail

read -r -p "Enter NAS IP: " NAS_IP

echo "[+] Setting up exporters on NAS at ${NAS_IP}"

ssh root@"${NAS_IP}" bash -s <<EOF
  set -euo pipefail

  mkdir -p /root/exporters
  cd /root/exporters

  curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.8.1/node_exporter-1.8.1.linux-amd64.tar.gz
  tar -xzf node_exporter-1.8.1.linux-amd64.tar.gz --strip-components=1
  curl -LO https://github.com/pdf/zfs_exporter/releases/download/v2.3.2/zfs_exporter-2.3.2.linux-amd64.tar.gz
  tar -xzf zfs_exporter-2.3.2.linux-amd64.tar.gz --strip-components=1

  cat > /etc/systemd/system/node_exporter.service <<NODE
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
ExecStart=/root/exporters/node_exporter --web.listen-address=:9100
Restart=always
User=root

[Install]
WantedBy=multi-user.target
NODE

  cat > /etc/systemd/system/zfs_exporter.service <<ZFS
[Unit]
Description=Prometheus ZFS Exporter
After=network.target

[Service]
ExecStart=/root/exporters/zfs_exporter --web.listen-address=:9134
Restart=always
User=root

[Install]
WantedBy=multi-user.target
ZFS

  systemctl daemon-reexec
  systemctl enable --now node_exporter
  systemctl enable --now zfs_exporter

  echo "[✓] Exporters installed and running!"
EOF
