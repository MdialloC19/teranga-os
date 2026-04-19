#!/bin/bash
# MOD 07 — Branding TérangaOS (hostname, os-release, MOTD)
source "$(dirname "$0")/../../lib/common.sh"
mod_name="07-branding"
log_step "[${mod_name}] Application du branding TérangaOS"

# OS release
cat > /etc/os-release << 'EOF'
PRETTY_NAME="TérangaOS 0.1 (Diamniadio) — Raspberry Pi Edition"
NAME="TérangaOS"
VERSION_ID="0.1"
VERSION="0.1 (Diamniadio)"
VERSION_CODENAME=diamniadio
ID=terangaos
ID_LIKE=debian
HOME_URL="https://teranga-os.org"
SUPPORT_URL="https://teranga-os.org/support"
BUG_REPORT_URL="https://github.com/mdialloc19/teranga-os/issues"
EOF

# Hostname
echo "terangaos" > /etc/hostname
# Remplacement compatible Linux et macOS (évite le \t dans sed)
if grep -q "127\.0\.1\.1" /etc/hosts; then
    sed -i "s/127\.0\.1\.1.*/127.0.1.1	terangaos/" /etc/hosts
else
    printf "127.0.1.1\tterangaos\n" >> /etc/hosts
fi

# MOTD
cat > /etc/motd << 'EOF'

  ╔═══════════════════════════════════════════════╗
  ║          🇸🇳  TérangaOS  🇸🇳                   ║
  ║     Raspberry Pi Edition — v0.1 Alpha         ║
  ║                                               ║
  ║  Distribution souveraine pour l'Afrique       ║
  ║  Basée sur Debian 12 (Bookworm) ARM64         ║
  ║                                               ║
  ║  teranga security  →  audit de sécurité       ║
  ║  teranga info      →  infos système           ║
  ╚═══════════════════════════════════════════════╝

EOF

# Bannière login
cat > /etc/issue << 'EOF'

    🇸🇳 TérangaOS — Accès autorisé uniquement

EOF

# Wallpaper bureau par défaut pour /etc/skel
SKEL_XFCE="/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "$SKEL_XFCE"
cat > "${SKEL_XFCE}/xfce4-desktop.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitorHDMI-1" type="empty">
        <property name="workspace0" type="empty">
          <property name="last-image" type="string"
            value="/usr/share/backgrounds/terangaos/dakar-sunset.png"/>
          <property name="image-style" type="int" value="5"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

log_info "[${mod_name}] ✓ Branding : hostname + os-release + MOTD + wallpaper"
