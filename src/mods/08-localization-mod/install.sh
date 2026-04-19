#!/bin/bash
# MOD 08 — Localisation (Français / Sénégal)
source "$(dirname "$0")/../../lib/common.sh"
source "$(dirname "$0")/../../lib/args.sh"
mod_name="08-localization"
log_step "[${mod_name}] Localisation Français / Sénégal"

# Locales
LANG_SHORT=$(echo "${TERANGA_LANG}" | cut -d. -f1)
sed -i "s/# ${LANG_SHORT}.UTF-8/${LANG_SHORT}.UTF-8/" /etc/locale.gen 2>/dev/null || true
locale-gen
update-locale LANG="${TERANGA_LANG}" LC_ALL="${TERANGA_LANG}"

# Fuseau horaire
timedatectl set-timezone "${TERANGA_TIMEZONE}" 2>/dev/null || \
    ln -sf "/usr/share/zoneinfo/${TERANGA_TIMEZONE}" /etc/localtime

# Clavier
cat > /etc/default/keyboard << EOF
XKBMODEL="pc105"
XKBLAYOUT="${TERANGA_KEYBOARD}"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
EOF

log_info "[${mod_name}] ✓ Langue: ${TERANGA_LANG} | Fuseau: ${TERANGA_TIMEZONE} | Clavier: ${TERANGA_KEYBOARD}"
