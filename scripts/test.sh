#!/bin/bash
# ============================================================
# TérangaOS — System test script
# Verifies that all components are correctly installed
#
# Usage:
#   sudo bash scripts/test.sh          → full test
#   bash scripts/test.sh --dry-run     → checks without privileges
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "${REPO_ROOT}/src/lib/common.sh" 2>/dev/null || {
    # Fallback if common.sh missing
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
    BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'
    log_info()  { echo -e "${GREEN}[✓]${NC} $*"; }
    log_warn()  { echo -e "${YELLOW}[⚠]${NC} $*"; }
    log_error() { echo -e "${RED}[✗]${NC} $*"; }
    log_step()  { echo -e "\n${BLUE}${BOLD}━━ $* ━━${NC}"; }
}

DRY_RUN=false
PASS=0; FAIL=0; WARN=0

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

pass() { log_info "$*";  ((PASS++)); }
fail() { log_error "$*"; ((FAIL++)); }
warn() { log_warn "$*";  ((WARN++)); }

require_root() {
    if [[ $EUID -ne 0 ]] && [[ "$DRY_RUN" == false ]]; then
        echo -e "${YELLOW}Tip: run with sudo for complete tests${NC}"
        echo "  sudo bash scripts/test.sh"
        echo "  bash scripts/test.sh --dry-run   (without sudo)"
        echo ""
    fi
}

# ============================================================
check_cmd() {
    local cmd="$1"; local desc="${2:-$cmd}"
    command -v "$cmd" &>/dev/null && pass "${desc} installed" || fail "${desc} missing"
}

check_service() {
    local svc="$1"
    systemctl is-active --quiet "$svc" 2>/dev/null && \
        pass "Service ${svc} active" || fail "Service ${svc} inactive"
}

check_file() {
    local f="$1"; local desc="${2:-$f}"
    [[ -f "$f" ]] && pass "${desc} present" || fail "${desc} missing"
}

check_dir() {
    local d="$1"; local desc="${2:-$d}"
    [[ -d "$d" ]] && pass "${desc} present" || fail "${desc} missing"
}
# ============================================================

main() {
    echo ""
    echo -e "${BLUE}${BOLD}"
    echo "  ╔══════════════════════════════════════════════╗"
    echo "  ║   🇸🇳  TérangaOS — System Audit             ║"
    echo "  ╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    require_root

    # ----------------------------------------------------------
    log_step "1/6 — System identity"
    # ----------------------------------------------------------
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release 2>/dev/null
        if echo "${PRETTY_NAME:-}" | grep -q "TérangaOS" 2>/dev/null; then
            pass "OS : ${PRETTY_NAME}"
        else
            warn "os-release : ${PRETTY_NAME:-unknown} (not TérangaOS ?)"
        fi
    fi

    hostname_val=$(cat /etc/hostname 2>/dev/null || hostname)
    if echo "$hostname_val" | grep -q "terangaos"; then
        pass "Hostname : ${hostname_val}"
    else
        warn "Hostname : ${hostname_val} (expected: terangaos)"
    fi

    tz=$(cat /etc/timezone 2>/dev/null || timedatectl show -p Timezone --value 2>/dev/null || echo "?")
    [[ "$tz" == "Africa/Dakar" ]] && pass "Timezone : Africa/Dakar" || warn "Timezone : ${tz} (expected: Africa/Dakar)"

    lang_val=${LANG:-}
    echo "$lang_val" | grep -q "fr_FR" && pass "Language : ${lang_val}" || warn "Language : ${lang_val} (expected: fr_FR.UTF-8)"

    # ----------------------------------------------------------
    log_step "2/6 — Branding"
    # ----------------------------------------------------------
    check_file /usr/share/terangaos/branding/logo.png          "TérangaOS Logo"
    check_file /usr/share/terangaos/branding/wallpaper-default.png "Default Wallpaper"
    check_dir  /usr/share/backgrounds/terangaos                 "System Wallpapers"
    check_file /etc/lightdm/lightdm.conf                        "Config LightDM"
    check_file /etc/lightdm/lightdm-gtk-greeter.conf            "Config Greeter"

    # ----------------------------------------------------------
    log_step "3/6 — Xfce Desktop"
    # ----------------------------------------------------------
    check_cmd xfce4-session     "Xfce4 Session"
    check_cmd xfwm4             "Xfce4 Window Manager"
    check_cmd thunar             "Thunar"
    check_cmd lightdm            "LightDM"
    check_dir /usr/share/themes/Fluent-Dark "Fluent-Dark Theme"
    check_dir /usr/share/icons/Fluent       "Fluent Icons"

    # ----------------------------------------------------------
    log_step "4/6 — Software Suite"
    # ----------------------------------------------------------
    check_cmd libreoffice "LibreOffice"
    check_cmd firefox-esr "Firefox ESR"
    check_cmd thunderbird  "Thunderbird"
    check_cmd vlc          "VLC"

    # ----------------------------------------------------------
    log_step "5/6 — Security"
    # ----------------------------------------------------------
    if [[ $EUID -eq 0 ]]; then
        # UFW
        ufw status | grep -q "Status: active" && pass "UFW : active" || fail "UFW : inactive"
        # AppArmor
        check_service apparmor
        # Fail2ban
        check_service fail2ban
        # ClamAV
        check_service clamav-daemon
        # sysctl
        val=$(sysctl -n net.ipv4.ip_forward 2>/dev/null)
        [[ "$val" == "0" ]] && pass "ip_forward=0 ✓" || fail "ip_forward=${val} (should be 0)"
        val=$(sysctl -n kernel.dmesg_restrict 2>/dev/null)
        [[ "$val" == "1" ]] && pass "dmesg_restrict=1 ✓" || warn "dmesg_restrict=${val}"
    else
        warn "Security tests skipped (run with sudo)"
    fi

    # ----------------------------------------------------------
    log_step "6/6 — teranga-cli"
    # ----------------------------------------------------------
    if command -v teranga &>/dev/null; then
        pass "teranga-cli installed : $(teranga version 2>/dev/null | head -1)"
        teranga info    &>/dev/null && pass "teranga info    ✓" || fail "teranga info    ✗"
        teranga status  &>/dev/null && pass "teranga status  ✓" || fail "teranga status  ✗"
    else
        fail "teranga-cli not installed"
    fi

    # ----------------------------------------------------------
    echo ""
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "  ${GREEN}${BOLD}RESULT: ${PASS} OK${NC}  |  ${YELLOW}${WARN} WARNINGS${NC}  |  ${RED}${FAIL} FAILURES${NC}"
    echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if [[ $FAIL -eq 0 ]]; then
        echo -e "  ${GREEN}${BOLD}✅ TérangaOS is correctly configured!${NC}"
        exit 0
    else
        echo -e "  ${RED}${BOLD}❌ ${FAIL} test(s) failed. See logs above.${NC}"
        echo -e "  Re-run a mod: sudo bash scripts/setup-rpi.sh --mod <n>"
        exit 1
    fi
}

main "$@"
