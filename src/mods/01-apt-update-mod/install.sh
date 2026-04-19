#!/bin/bash
# MOD 01 — Mise à jour APT
source "$(dirname "$0")/../../lib/common.sh"
mod_name="01-apt-update"
log_step "[${mod_name}] Mise à jour du système"
apt-get update -qq
apt-get full-upgrade -y
log_info "[${mod_name}] ✓ Système à jour"
