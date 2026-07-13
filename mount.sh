#!/usr/bin/env bash

set -e

MOUNTPOINT="/proj/cad"
REMOTE="ebw220000@giant.utdallas.edu:/proj/cad"

sudo mkdir -p "$MOUNTPOINT"

# Clear a stale mount if one remains after losing the network.
fusermount3 -uz "$MOUNTPOINT" 2>/dev/null || true

# Mounts the /proj/cad/ from UTD engnx server to local MOUNTPOINT of same name
sudo sshfs \
  $REMOTE \
  $MOUNTPOINT \
  -o ro \
  -o allow_other \
  -o default_permissions \
  -o reconnect \
  -o ServerAliveInterval=15 \
  -o ServerAliveCountMax=3 \
  -o cache=yes \
  -o kernel_cache \
  -o attr_timeout=3600 \
  -o entry_timeout=3600 \
  -o negative_timeout=60 \
  -o compression=no
