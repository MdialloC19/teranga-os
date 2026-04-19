#!/bin/bash
# MOD 09 — Installation de teranga-cli
source "$(dirname "$0")/../../lib/common.sh"
mod_name="09-teranga-cli"
log_step "[${mod_name}] Installation de teranga-cli"

apt-get install -y gcc make

CLI_DIR="${REPO_ROOT}/tools/teranga-cli"

if [ ! -d "$CLI_DIR" ]; then
    log_warn "Code source teranga-cli non trouvé dans ${CLI_DIR}"
    log_warn "Clonage depuis GitHub..."
    apt-get install -y git
    git clone --depth=1 https://github.com/MdialloC19/teranga-os.git /tmp/teranga-os
    CLI_DIR="/tmp/teranga-os/tools/teranga-cli"
fi

cd "$CLI_DIR"
make clean && make

install -Dm755 teranga /usr/local/bin/teranga
log_info "teranga-cli installé dans /usr/local/bin/teranga ✓"

# Vérification
teranga version && log_info "[${mod_name}] ✓ teranga-cli opérationnel"
