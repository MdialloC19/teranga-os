#!/bin/bash
# MOD 03 — LightDM configuration + login screen branding
source "$(dirname "$0")/../../lib/common.sh"
source "$(dirname "$0")/../../lib/args.sh"
mod_name="03-lightdm"
log_step "[${mod_name}] LightDM configuration"

# Copy branding assets
BRANDING_DIR="/usr/share/terangaos/branding"
BRANDING_SOURCE="${REPO_ROOT}/assets/branding"
mkdir -p "$BRANDING_DIR"

[ -f "${BRANDING_SOURCE}/logo/logo.png" ] && \
    cp "${BRANDING_SOURCE}/logo/logo.png" "${BRANDING_DIR}/logo.png" && \
    log_info "Logo copied ✓"

if [ -f "${BRANDING_SOURCE}/wallpapers/dakar-sunset.png" ]; then
    cp "${BRANDING_SOURCE}/wallpapers/dakar-sunset.png" \
       "${BRANDING_DIR}/wallpaper-default.png"
    mkdir -p /usr/share/backgrounds/terangaos
    cp "${BRANDING_SOURCE}/wallpapers/"*.png \
       /usr/share/backgrounds/terangaos/ 2>/dev/null || true
    log_info "Wallpapers copied ✓"
fi

# LightDM configuration
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
log_info "[${mod_name}] ✓ LightDM configured (logo + Dakar Sunset)"
