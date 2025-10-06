#!/usr/bin/env bash

set -euo pipefail

cat ~/.ssh/id_ed25519.pub | ssh root@${pveIP} 'mkdir -p $HOME/.ssh && cat >> $HOME/.ssh/authorized_keys'
