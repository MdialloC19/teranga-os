#!/bin/bash
# MOD 05 — Fluent GTK theme (Windows 11 look)
source "$(dirname "$0")/../../lib/common.sh"
mod_name="05-theme-fluent"
log_step "[${mod_name}] Fluent theme installation"

apt-get install -y git curl unzip

# Fluent GTK theme (dark mode, TérangaOS green accent)
log_info "Downloading Fluent-gtk-theme..."
rm -rf /tmp/Fluent-gtk-theme
git clone --depth=1 https://github.com/vinceliuice/Fluent-gtk-theme.git \
    /tmp/Fluent-gtk-theme
bash /tmp/Fluent-gtk-theme/install.sh \
    --theme green --color dark --size standard --dest /usr/share/themes
rm -rf /tmp/Fluent-gtk-theme
log_info "Fluent GTK theme ✓"


# Inter font
apt-get install -y fonts-inter 2>/dev/null || {
    mkdir -p /usr/share/fonts/truetype/inter
    curl -sL "https://github.com/rsms/inter/releases/download/v4.0/Inter-4.0.zip" \
        -o /tmp/inter.zip && \
    unzip -q /tmp/inter.zip -d /tmp/inter && \
    find /tmp/inter -name "*.ttf" -exec cp {} /usr/share/fonts/truetype/inter/ \; && \
    fc-cache -f && rm -rf /tmp/inter /tmp/inter.zip
    log_info "Inter font ✓"
}

# Bibata cursor
apt-get install -y bibata-cursor-theme 2>/dev/null || \
    log_warn "Bibata cursor theme unavailable, using default cursor"

# Apply theme settings for all new users (/etc/skel)
SKEL_XFCE="/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "$SKEL_XFCE"

cat > "${SKEL_XFCE}/xsettings.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Fluent-Dark"/>
    <property name="IconThemeName" type="string" value="Fluent"/>
    <property name="CursorThemeName" type="string" value="Bibata-Modern-Classic"/>
    <property name="CursorThemeSize" type="int" value="24"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="FontName" type="string" value="Inter 11"/>
    <property name="MonospaceFontName" type="string" value="Monospace 10"/>
    <property name="DecorationLayout" type="string" value="menu:minimize,maximize,close"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="int" value="96"/>
    <property name="Antialias" type="int" value="1"/>
    <property name="Hinting" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
</channel>
EOF

cat > "${SKEL_XFCE}/xfwm4.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Fluent-Dark"/>
    <property name="title_font" type="string" value="Inter Bold 10"/>
    <property name="button_layout" type="string" value="|HMC"/>
    <property name="title_alignment" type="string" value="left"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="tile_on_move" type="bool" value="true"/>
  </property>
</channel>
EOF

log_info "[${mod_name}] ✓ Fluent-Dark theme + Icons + Inter + Bibata"
