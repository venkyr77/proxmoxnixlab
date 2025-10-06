_:
# sh
''
  set -euo pipefail

  read -r -p "Enter host ip: " host

  ssh -t "ops@$host" 'sudo mkdir -p "/etc/$HOSTNAME"'
  scp "$HOME/.config/sops/age/keys.txt" "ops@$host:~/sopspk"
  ssh -t "ops@$host" 'sudo mv "$HOME/sopspk" "/etc/$HOSTNAME"'
''
