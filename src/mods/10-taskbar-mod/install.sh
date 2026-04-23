#!/bin/bash
# MOD 10 — Xfce4 taskbar configuration (Windows-style)
source "$(dirname "$0")/../../lib/common.sh"
mod_name="10-taskbar-mod"
log_step "[${mod_name}] Taskbar configuration (Windows-style)"

SKEL_PANEL="/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml"
mkdir -p "$SKEL_PANEL"

cat > "${SKEL_PANEL}/xfce4-panel.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
  </property>
  <property name="panels" type="empty">
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=8;x=683;y=752"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="icon-size" type="uint" value="32"/>
      <property name="size" type="uint" value="48"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
        <value type="int" value="7"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="whiskermenu"/>
    <property name="plugin-2" type="string" value="separator">
      <property name="expand" type="bool" value="false"/>
    </property>
    <property name="plugin-3" type="string" value="tasklist">
      <property name="show-labels" type="bool" value="false"/>
      <property name="flat-buttons" type="bool" value="true"/>
    </property>
    <property name="plugin-4" type="string" value="separator">
      <property name="expand" type="bool" value="true"/>
      <property name="style" type="uint" value="0"/>
    </property>
    <property name="plugin-5" type="string" value="systray"/>
    <property name="plugin-6" type="string" value="pulseaudio"/>
    <property name="plugin-7" type="string" value="clock">
      <property name="digital-format" type="string" value="%H:%M  |  %d/%m/%Y"/>
    </property>
  </property>
</channel>
EOF

# Thunar: double-click
cat > "${SKEL_PANEL}/../thunar.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="thunar" version="1.0">
  <property name="misc-single-click" type="bool" value="false"/>
  <property name="misc-show-delete-action" type="bool" value="true"/>
  <property name="last-view" type="string" value="ThunarDetailsView"/>
  <property name="last-side-pane" type="string" value="ThunarShortcutsPane"/>
</channel>
EOF

log_info "[${mod_name}] ✓ Taskbar at bottom + Whisker menu + Clock FR"
