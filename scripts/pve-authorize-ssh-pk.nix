{pveIP}:
# sh
''
  cat ~/.ssh/id_ed25519.pub | ssh root@${pveIP} "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
''
