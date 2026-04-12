#!/bin/bash
# ============================================================
# TérangaOS — Script de setup pour Raspberry Pi 5
# 
# Ce script transforme un Raspberry Pi OS (Debian 12)
# en prototype TérangaOS
#
# Usage :
#   curl -sL https://raw.githubusercontent.com/mdialloc19/teranga-os/main/scripts/setup-rpi.sh | sudo bash
#   ou
#   sudo bash scripts/setup-rpi.sh
#
# Prérequis :
#   - Raspberry Pi 5 (4 Go ou 8 Go)
#   - Raspberry Pi OS (64-bit, Debian Bookworm)
#   - Connexion Internet
#   - Carte SD 32 Go minimum (64 Go recommandé)
# ============================================================

set -euo pipefail

# --- Variables ---
VERSION="0.1.0-alpha"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/var/log/terangaos-setup.log"

# --- Couleurs ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# --- Fonctions ---
log_info()  { echo -e "${GREEN}[TérangaOS]${NC} $*" | tee -a "$LOG_FILE"; }
log_warn()  { echo -e "${YELLOW}[ATTENTION]${NC} $*" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERREUR]${NC} $*" | tee -a "$LOG_FILE"; }
log_step()  { echo -e "\n${BLUE}${BOLD}══════════════════════════════════════${NC}"; \
              echo -e "${BLUE}${BOLD}  $*${NC}"; \
              echo -e "${BLUE}${BOLD}══════════════════════════════════════${NC}\n"; }

# --- Vérifications ---
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Ce script doit être exécuté en tant que root"
        echo "Usage : sudo bash $0"
        exit 1
    fi
}

check_raspberry() {
    if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null && \
       ! grep -q "BCM" /proc/cpuinfo 2>/dev/null; then
        log_warn "Ce système ne semble pas être un Raspberry Pi."
        read -p "Continuer quand même ? (o/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Oo]$ ]]; then
            exit 1
        fi
    fi
}

check_arch() {
    local arch
    arch=$(uname -m)
    if [[ "$arch" != "aarch64" ]]; then
        log_error "Architecture non supportée: $arch"
        log_error "TérangaOS RPi nécessite un OS 64-bit (aarch64)"
        exit 1
    fi
}

check_disk_space() {
    local available
    available=$(df / --output=avail -BG | tail -1 | tr -d ' G')
    if [[ "$available" -lt 10 ]]; then
        log_error "Espace disque insuffisant: ${available}Go disponible, 10Go minimum requis"
        exit 1
    fi
    log_info "Espace disque: ${available}Go disponible ✓"
}

# === ÉTAPE 1 : Mise à jour système ===
step_update() {
    log_step "ÉTAPE 1/8 — Mise à jour du système"
    
    apt update
    apt full-upgrade -y
    log_info "Système mis à jour ✓"
}

# === ÉTAPE 2 : Installation du bureau Xfce ===
step_install_desktop() {
    log_step "ÉTAPE 2/8 — Installation du bureau Xfce"
    
    # Supprimer le bureau par défaut (PIXEL/LXDE) s'il existe
    apt remove -y rpd-plym-splash lxpanel lxsession pcmanfm 2>/dev/null || true
    
    # Installer Xfce
    apt install -y \
        xfce4 \
        xfce4-goodies \
        xfce4-terminal \
        xfce4-power-manager \
        xfce4-notifyd \
        xfce4-screenshooter \
        xfce4-taskmanager \
        xfce4-whiskermenu-plugin \
        xfce4-clipman-plugin \
        xfce4-pulseaudio-plugin \
        lightdm \
        lightdm-gtk-greeter \
        lightdm-gtk-greeter-settings \
        thunar \
        thunar-archive-plugin \
        thunar-volman

    log_info "Bureau Xfce installé ✓"
}

# === ÉTAPE 3 : Suite logicielle ===
step_install_apps() {
    log_step "ÉTAPE 3/8 — Installation de la suite logicielle"
    
    # Suite bureautique
    apt install -y \
        libreoffice-writer \
        libreoffice-calc \
        libreoffice-impress \
        libreoffice-l10n-fr \
        libreoffice-help-fr \
        libreoffice-gtk3

    # Navigateur
    apt install -y \
        firefox-esr \
        firefox-esr-l10n-fr

    # Email
    apt install -y \
        thunderbird \
        thunderbird-l10n-fr

    # Multimédia et utilitaires
    apt install -y \
        vlc \
        mousepad \
        atril \
        galculator \
        file-roller \
        ristretto \
        gnome-disk-utility \
        baobab \
        gparted \
        keepassxc \
        redshift \
        flameshot

    # Polices
    apt install -y \
        fonts-noto \
        fonts-noto-color-emoji \
        fonts-liberation \
        fonts-dejavu

    # Nextcloud Desktop
    apt install -y nextcloud-desktop 2>/dev/null || \
        log_warn "Nextcloud Desktop non disponible dans les repos, à installer manuellement"

    log_info "Suite logicielle installée ✓"
}

# === ÉTAPE 4 : Thème Windows-like ===
step_configure_theme() {
    log_step "ÉTAPE 4/8 — Configuration du thème (style Windows)"
    
    # Créer le profil utilisateur par défaut
    local SKEL="/etc/skel"
    mkdir -p "${SKEL}/.config/xfce4/xfconf/xfce-perchannel-xml"
    mkdir -p "${SKEL}/.config/xfce4/panel"
    mkdir -p "${SKEL}/.local/share/applications"

    # --- Configuration du panneau (barre en bas, style Windows) ---
    cat > "${SKEL}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml" << 'PANEL'
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
PANEL

    # --- Configuration du bureau ---
    cat > "${SKEL}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" << 'DESKTOP'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="desktop-icons" type="empty">
    <property name="icon-size" type="uint" value="48"/>
    <property name="file-icons" type="empty">
      <property name="show-home" type="bool" value="true"/>
      <property name="show-filesystem" type="bool" value="false"/>
      <property name="show-removable" type="bool" value="true"/>
      <property name="show-trash" type="bool" value="true"/>
    </property>
  </property>
</channel>
DESKTOP

    # --- Thunar : double-clic (pas simple clic) ---
    cat > "${SKEL}/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml" << 'THUNAR'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="thunar" version="1.0">
  <property name="misc-single-click" type="bool" value="false"/>
  <property name="misc-show-delete-action" type="bool" value="true"/>
  <property name="last-view" type="string" value="ThunarDetailsView"/>
  <property name="last-side-pane" type="string" value="ThunarShortcutsPane"/>
</channel>
THUNAR

    # --- Gestionnaire de fenêtres (boutons à droite comme Windows) ---
    cat > "${SKEL}/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml" << 'XFWM'
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="button_layout" type="string" value="|HMC"/>
    <property name="title_alignment" type="string" value="left"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="true"/>
    <property name="tile_on_move" type="bool" value="true"/>
    <property name="wrap_windows" type="bool" value="false"/>
  </property>
</channel>
XFWM

    # --- LibreOffice : Mode Tabbed (Ruban) ---
    local LO_DIR="${SKEL}/.config/libreoffice/4/user"
    mkdir -p "${LO_DIR}"
    cat > "${LO_DIR}/registrymodifications.xcu" << 'LIBREOFFICE'
<?xml version="1.0" encoding="UTF-8"?>
<oor:items xmlns:oor="http://openoffice.org/2001/registry"
           xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Writer">
    <prop oor:name="Active" oor:op="fuse"><value>Tabbed</value></prop>
  </item>
  <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Calc">
    <prop oor:name="Active" oor:op="fuse"><value>Tabbed</value></prop>
  </item>
  <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Impress">
    <prop oor:name="Active" oor:op="fuse"><value>Tabbed</value></prop>
  </item>
</oor:items>
LIBREOFFICE

    # --- Firefox : DuckDuckGo + anti-tracking ---
    mkdir -p /usr/lib/firefox-esr/distribution
    cat > /usr/lib/firefox-esr/distribution/policies.json << 'FIREFOX'
{
  "policies": {
    "Homepage": {
      "URL": "https://teranga-os.org/start",
      "Locked": false,
      "StartPage": "homepage"
    },
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
FIREFOX

    log_info "Thème Windows-like configuré ✓"
    log_info "  - Barre des tâches en bas"
    log_info "  - Menu Whisker (style Windows)"
    log_info "  - Double-clic pour ouvrir"
    log_info "  - Boutons fenêtre à droite (réduire, agrandir, fermer)"
    log_info "  - LibreOffice en mode Ruban"
    log_info "  - Firefox avec DuckDuckGo"
}

# === ÉTAPE 5 : Sécurité ===
step_security() {
    log_step "ÉTAPE 5/8 — Durcissement de sécurité"

    # Installer les outils de sécurité
    apt install -y \
        ufw \
        apparmor \
        apparmor-utils \
        clamav \
        clamav-daemon \
        fail2ban \
        unattended-upgrades

    # Activer le firewall
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw --force enable

    # Paramètres kernel sécurisés
    cat > /etc/sysctl.d/99-terangaos.conf << 'SYSCTL'
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
SYSCTL
    sysctl -p /etc/sysctl.d/99-terangaos.conf

    # Mises à jour automatiques
    cat > /etc/apt/apt.conf.d/50unattended-upgrades << 'AUTOUPDATE'
Unattended-Upgrade::Allowed-Origins {
    "${distro_id}:${distro_codename}-security";
};
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Automatic-Reboot "false";
AUTOUPDATE

    log_info "Sécurité configurée ✓"
    log_info "  - Firewall UFW activé"
    log_info "  - AppArmor activé"
    log_info "  - ClamAV installé"
    log_info "  - Fail2ban installé"
    log_info "  - Mises à jour auto de sécurité"
}

# === ÉTAPE 6 : Branding TérangaOS ===
step_branding() {
    log_step "ÉTAPE 6/8 — Branding TérangaOS"

    # OS release
    cat > /etc/os-release << 'OSRELEASE'
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
OSRELEASE

    # MOTD
    cat > /etc/motd << 'MOTD'

  ╔═══════════════════════════════════════════════╗
  ║          🇸🇳  TérangaOS  🇸🇳                   ║
  ║     Raspberry Pi Edition — v0.1 Alpha         ║
  ║                                               ║
  ║  Distribution souveraine pour l'Afrique       ║
  ║  Basée sur Debian 12 (Bookworm) ARM64        ║
  ╚═══════════════════════════════════════════════╝

MOTD

    # Hostname
    echo "terangaos" > /etc/hostname
    sed -i 's/127\.0\.1\.1.*/127.0.1.1\tterangaos/' /etc/hosts

    # Bannière de connexion
    cat > /etc/issue << 'ISSUE'

    🇸🇳 TérangaOS — Accès autorisé uniquement

ISSUE

    log_info "Branding appliqué ✓"
}

# === ÉTAPE 7 : Localisation FR / Sénégal ===
step_localization() {
    log_step "ÉTAPE 7/8 — Localisation (Français / Sénégal)"

    # Générer les locales
    sed -i 's/# fr_FR.UTF-8/fr_FR.UTF-8/' /etc/locale.gen
    sed -i 's/# fr_SN.UTF-8/fr_SN.UTF-8/' /etc/locale.gen 2>/dev/null || true
    locale-gen

    # Définir la locale par défaut
    update-locale LANG=fr_FR.UTF-8 LC_ALL=fr_FR.UTF-8

    # Fuseau horaire
    timedatectl set-timezone Africa/Dakar 2>/dev/null || \
        ln -sf /usr/share/zoneinfo/Africa/Dakar /etc/localtime

    # Clavier français
    cat > /etc/default/keyboard << 'KEYBOARD'
XKBMODEL="pc105"
XKBLAYOUT="fr"
XKBVARIANT=""
XKBOPTIONS=""
BACKSPACE="guess"
KEYBOARD

    log_info "Localisation configurée ✓"
    log_info "  - Langue : Français (fr_FR.UTF-8)"
    log_info "  - Fuseau : Africa/Dakar (UTC+0)"
    log_info "  - Clavier : AZERTY français"
}

# === ÉTAPE 8 : Nettoyage et finalisation ===
step_finalize() {
    log_step "ÉTAPE 8/8 — Finalisation"

    # Nettoyage
    apt autoremove -y
    apt clean

    # Activer lightdm comme display manager
    systemctl set-default graphical.target
    dpkg-reconfigure -f noninteractive lightdm 2>/dev/null || true

    # Résumé
    echo ""
    echo -e "${GREEN}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════╗"
    echo "  ║                                                   ║"
    echo "  ║🇸🇳   TérangaOS v${VERSION} —INSTALLATION terminée   ║"
    echo "  ║                                                   ║"
    echo "  ║   Redémarrez votre Raspberry Pi :                 ║"
    echo "  ║   $ sudo reboot                                   ║"
    echo "  ║                                                   ║"
    echo "  ║   Après le reboot, vous aurez :                   ║"
    echo "  ║   ✅ Bureau Xfce (style Windows)                  ║"
    echo "  ║   ✅ LibreOffice (mode Ruban)                     ║"
    echo "  ║   ✅ Firefox (DuckDuckGo, anti-tracking)          ║"
    echo "  ║   ✅ Thunderbird (email)                          ║"
    echo "  ║   ✅ Sécurité durcie (firewall, AppArmor)         ║"
    echo "  ║   ✅ Localisation FR / Sénégal                    ║"
    echo "  ║                                                   ║"
    echo "  ║   Ndank ndank mooy jàpp golo ci ñaay 🌍           ║"
    echo "  ║                                                   ║"
    echo "  ╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    echo "  Log complet : ${LOG_FILE}"
    echo ""
}

# ============================================================
# MAIN
# ============================================================
main() {
    echo ""
    echo -e "${GREEN}${BOLD}"
    echo "  ╔═══════════════════════════════════════════════════╗"
    echo "  ║                                                   ║"
    echo "  ║   🇸🇳  TérangaOS — Setup Raspberry Pi             ║"
    echo "  ║   Version : ${VERSION}                         ║"
    echo "  ║                                                   ║"
    echo "  ╚═══════════════════════════════════════════════════╝"
    echo -e "${NC}"

    # Vérifications
    check_root
    check_arch
    check_raspberry
    check_disk_space

    # Confirmation
    echo ""
    echo -e "${YELLOW}Ce script va transformer votre Raspberry Pi en poste TérangaOS.${NC}"
    echo -e "${YELLOW}Cela va installer ~2 Go de logiciels et modifier la configuration système.${NC}"
    echo ""
    read -p "Continuer ? (o/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Oo]$ ]]; then
        echo "Annulé."
        exit 0
    fi

    # Exécution
    local start_time
    start_time=$(date +%s)

    step_update
    step_install_desktop
    step_install_apps
    step_configure_theme
    step_security
    step_branding
    step_localization
    step_finalize

    local end_time duration
    end_time=$(date +%s)
    duration=$(( (end_time - start_time) / 60 ))
    log_info "Installation terminée en ${duration} minutes"
}

main "$@"
