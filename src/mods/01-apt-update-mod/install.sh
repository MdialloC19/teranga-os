#!/bin/bash
# MOD 01 — APT system update
source "$(dirname "$0")/../../lib/common.sh"
mod_name="01-apt-update"
log_step "[${mod_name}] System update"
apt-get update -qq
apt-get full-upgrade -y
log_info "[${mod_name}] ✓ System up to date"
