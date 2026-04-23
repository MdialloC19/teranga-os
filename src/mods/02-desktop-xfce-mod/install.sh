#!/bin/bash
# MOD 02 — Xfce desktop + LightDM installation
source "$(dirname "$0")/../../lib/common.sh"
mod_name="02-desktop-xfce"
log_step "[${mod_name}] Xfce desktop installation"

apt-get install -y \
    xfce4 xfce4-goodies xfce4-terminal \
    xfce4-power-manager xfce4-notifyd \
    xfce4-screenshooter xfce4-taskmanager \
    xfce4-whiskermenu-plugin xfce4-clipman-plugin \
    xfce4-pulseaudio-plugin \
    lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings \
    thunar thunar-archive-plugin thunar-volman \
    xorg xserver-xorg x11-xserver-utils

# Remove RPi Desktop elements if present
apt-get remove -y rpd-plym-splash lxpanel lxsession pcmanfm 2>/dev/null || true

log_info "[${mod_name}] ✓ Xfce desktop installed"
