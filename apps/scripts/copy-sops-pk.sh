#!/usr/bin/env bash

set -euo pipefail

copy_to_host() {
  local host="$1"

  echo "Copying to ${host}"

  if ssh "ops@$host" '[ -f /etc/sopspk-secret/sopspk ]'; then
    echo "sopspk already exists on ${host}, skipping."
    return
  fi

  scp -q "$HOME/.config/sops/age/keys.txt" "ops@$host:/home/ops/sopspk"

  ssh "ops@$host" bash <<'EOSH'
set -euo pipefail
sudo mkdir -p "/etc/sopspk-secret"
sudo mv "$HOME/sopspk" "/etc/sopspk-secret/"
sudo chown root:root "/etc/sopspk-secret/sopspk"
sudo chmod 600 "/etc/sopspk-secret/sopspk"
EOSH
}

for ct in "${SOPS_PK_NEEDED_HOSTS[@]}"; do
  copy_to_host "$ct"
done
