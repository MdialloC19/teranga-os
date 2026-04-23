#!/bin/bash
# MOD 04 — Office suite (LibreOffice, Firefox, Thunderbird...)
source "$(dirname "$0")/../../lib/common.sh"
mod_name="04-apps"
log_step "[${mod_name}] Office suite installation"

# Productivity
apt-get install -y \
    libreoffice-writer libreoffice-calc libreoffice-impress \
    libreoffice-l10n-fr libreoffice-help-fr libreoffice-gtk3

# Navigateur
apt-get install -y firefox-esr firefox-esr-l10n-fr

# Email
apt-get install -y thunderbird thunderbird-l10n-fr

# Multimedia and utilities
apt-get install -y \
    vlc mousepad atril galculator file-roller \
    ristretto gnome-disk-utility baobab gparted \
    keepassxc flameshot

# Fonts
apt-get install -y \
    fonts-noto fonts-noto-color-emoji \
    fonts-liberation fonts-dejavu

# Firefox : DuckDuckGo + anti-tracking
mkdir -p /usr/lib/firefox-esr/distribution
cat > /usr/lib/firefox-esr/distribution/policies.json << 'EOF'
{
  "policies": {
    "Homepage": { "URL": "https://teranga-os.org/start" },
    "SearchEngines": { "Default": "DuckDuckGo" },
    "EnableTrackingProtection": {
      "Value": true, "Locked": true,
      "Cryptomining": true, "Fingerprinting": true
    },
    "DisableTelemetry": true,
    "DisableFirefoxStudies": true,
    "DisablePocket": true
  }
}
EOF

# LibreOffice: Ribbon mode
SKEL_LO="/etc/skel/.config/libreoffice/4/user"
mkdir -p "$SKEL_LO"
cat > "${SKEL_LO}/registrymodifications.xcu" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<oor:items xmlns:oor="http://openoffice.org/2001/registry">
  <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Writer">
    <prop oor:name="Active" oor:op="fuse"><value>Tabbed</value></prop>
  </item>
  <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Calc">
    <prop oor:name="Active" oor:op="fuse"><value>Tabbed</value></prop>
  </item>
</oor:items>
EOF

log_info "[${mod_name}] ✓ Office suite installed"
