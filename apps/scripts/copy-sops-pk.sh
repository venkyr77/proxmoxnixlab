#!/usr/bin/env bash

set -euo pipefail

copy_to_host() {
  local host="$1"

  echo "Copying to ${host}"

  if ssh "ops@$host" '[ -f /etc/$HOSTNAME/sopspk ]'; then
    echo "sopspk already exists on ${host}, skipping."
    return
  fi

  scp -q "$HOME/.config/sops/age/keys.txt" "ops@$host:/home/ops/sopspk"

  ssh "ops@$host" bash <<'EOSH'
set -euo pipefail
sudo mkdir -p "/etc/$HOSTNAME"
sudo mv "$HOME/sopspk" "/etc/$HOSTNAME/"
sudo chown root:root "/etc/$HOSTNAME/sopspk"
sudo chmod 600 "/etc/$HOSTNAME/sopspk"
EOSH
}

for ct in "${SOPS_PK_NEEDED_HOSTS[@]}"; do
  copy_to_host "$ct"
done
