#!/bin/bash
# MOD 09 — teranga-cli installation
source "$(dirname "$0")/../../lib/common.sh"
mod_name="09-teranga-cli"
log_step "[${mod_name}] teranga-cli installation"

apt-get install -y gcc make

CLI_DIR="${REPO_ROOT}/tools/teranga-cli"

if [ ! -d "$CLI_DIR" ]; then
    log_warn "teranga-cli source code not found in ${CLI_DIR}"
    log_warn "Cloning from GitHub..."
    apt-get install -y git
    git clone --depth=1 https://github.com/MdialloC19/teranga-os.git /tmp/teranga-os
    CLI_DIR="/tmp/teranga-os/tools/teranga-cli"
fi

cd "$CLI_DIR"
make clean && make

install -Dm755 teranga /usr/local/bin/teranga
log_info "teranga-cli installed in /usr/local/bin/teranga ✓"

# Verification
teranga version && log_info "[${mod_name}] ✓ teranga-cli operational"
