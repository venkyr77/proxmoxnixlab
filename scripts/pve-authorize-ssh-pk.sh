#!/usr/bin/env bash

set -euo pipefail

cat ~/.ssh/id_ed25519.pub | ssh root@"${PVE_IP}" 'mkdir -p $HOME/.ssh && cat >> $HOME/.ssh/authorized_keys'
