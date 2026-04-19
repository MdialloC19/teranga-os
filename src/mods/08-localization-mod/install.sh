#!/bin/bash
# MOD 08 — Localisation (Français / Sénégal)
source "$(dirname "$0")/../../lib/common.sh"
mod_name="08-localization"
log_step "[${mod_name}] Localisation Français / Sénégal"

# Locales
sed -i 's/# fr_FR.UTF-8/fr_FR.UTF-8/' /etc/locale.gen
sed -i 's/# fr_SN.UTF-8/fr_SN.UTF-8/' /etc/locale.gen 2>/dev/null || true
locale-gen
update-locale LANG=fr_FR.UTF-8 LC_ALL=fr_FR.UTF-8

# Fuseau horaire Dakar (UTC+0, pas de changement d'heure)
timedatectl set-timezone Africa/Dakar 2>/dev/null || \
    ln -sf /usr/share/zoneinfo/Africa/Dakar /etc/localtime

# Clavier AZERTY français
cat > /etc/default/keyboard << 'EOF'
XKBMODEL="pc105"
XKBLAYOUT="fr"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
EOF

log_info "[${mod_name}] ✓ Langue: fr_FR.UTF-8 | Fuseau: Africa/Dakar | Clavier: AZERTY"
