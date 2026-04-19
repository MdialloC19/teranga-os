#!/bin/bash
# MOD 06 — Sécurité (UFW, AppArmor, ClamAV, Fail2ban)
source "$(dirname "$0")/../../lib/common.sh"
mod_name="06-security"
log_step "[${mod_name}] Durcissement de sécurité"

apt-get install -y \
    ufw apparmor apparmor-utils \
    clamav clamav-daemon fail2ban \
    unattended-upgrades

# Firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw --force enable
log_info "Firewall UFW activé ✓"

# Paramètres kernel
cat > /etc/sysctl.d/99-terangaos.conf << 'EOF'
# TérangaOS — Sécurité kernel
net.ipv4.ip_forward = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.tcp_syncookies = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.randomize_va_space = 2
fs.suid_dumpable = 0
EOF
sysctl -p /etc/sysctl.d/99-terangaos.conf

# Mises à jour auto de sécurité
cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'EOF'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

log_info "[${mod_name}] ✓ UFW + AppArmor + ClamAV + Fail2ban + sysctl"
