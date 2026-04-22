#!/bin/bash
# MOD 03 — Configuration LightDM + branding écran de connexion
source "$(dirname "$0")/../../lib/common.sh"
source "$(dirname "$0")/../../lib/args.sh"
mod_name="03-lightdm"
log_step "[${mod_name}] Configuration LightDM"

# Copier les assets branding
BRANDING_DIR="/usr/share/terangaos/branding"
mkdir -p "$BRANDING_DIR"

[ -f "${REPO_ROOT}/branding/logo/logo.png" ] && \
    cp "${REPO_ROOT}/branding/logo/logo.png" "${BRANDING_DIR}/logo.png" && \
    log_info "Logo copié ✓"

if [ -f "${REPO_ROOT}/branding/wallpapers/dakar-sunset.png" ]; then
    cp "${REPO_ROOT}/branding/wallpapers/dakar-sunset.png" \
       "${BRANDING_DIR}/wallpaper-default.png"
    mkdir -p /usr/share/backgrounds/terangaos
    cp "${REPO_ROOT}/branding/wallpapers/"*.png \
       /usr/share/backgrounds/terangaos/ 2>/dev/null || true
    log_info "Wallpapers copiés ✓"
fi

# Config LightDM
mkdir -p /etc/lightdm
cat > /etc/lightdm/lightdm.conf << 'EOF'
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=xfce
autologin-guest=false
EOF

cat > /etc/lightdm/lightdm-gtk-greeter.conf << 'EOF'
[greeter]
theme-name=${TERANGA_THEME}
icon-theme-name=${TERANGA_ICONS}
font-name=${TERANGA_FONT}
xft-dpi=96
logo=/usr/share/terangaos/branding/logo.png
background=/usr/share/terangaos/branding/wallpaper-default.png
indicators=~host;~spacer;~clock;~spacer;~power
clock-format=%H:%M  —  %A %d %B
position=50%,center 50%,center
EOF

systemctl set-default graphical.target
log_info "[${mod_name}] ✓ LightDM configuré (logo + Dakar Sunset)"
