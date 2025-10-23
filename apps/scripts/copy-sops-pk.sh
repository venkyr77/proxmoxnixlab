#!/usr/bin/env bash

set -euo pipefail

copy_to_host() {
  local host="$1"

  echo "Copying to ${host}…"

  ssh -t "ops@$host" 'sudo mkdir -p "/etc/$HOSTNAME"'
  scp "$HOME/.config/sops/age/keys.txt" "ops@$host:/home/ops/sopspk"
  ssh -t "ops@$host" 'sudo mv "$HOME/sopspk" "/etc/$HOSTNAME"'
}

echo "${SOPS_PK_NEEDED_HOSTS}"

for ip in "${SOPS_PK_NEEDED_HOSTS[@]}"; do
  copy_to_host "$ip"
done
