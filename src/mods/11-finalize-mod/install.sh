#!/bin/bash
# MOD 11 — Finalisation (nettoyage + résumé)
source "$(dirname "$0")/../../lib/common.sh"
mod_name="11-finalize"
log_step "[${mod_name}] Finalisation et nettoyage"

apt-get autoremove -y
apt-get clean

systemctl set-default graphical.target
dpkg-reconfigure -f noninteractive lightdm 2>/dev/null || true

log_info "[${mod_name}] ✓ Système prêt — redémarre avec : sudo reboot"
