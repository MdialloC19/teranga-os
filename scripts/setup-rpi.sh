#!/bin/bash
# ============================================================
# TérangaOS — Orchestrateur de setup (système modulaire)
#
# Usage :
#   sudo bash scripts/setup-rpi.sh           → installation complète
#   sudo bash scripts/setup-rpi.sh --mod 05  → seulement le mod 05
#   sudo bash scripts/setup-rpi.sh --list    → lister les mods
#
# Architecture inspirée d'AnduinOS (github.com/Anduin2017/AnduinOS)
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MODS_DIR="${REPO_ROOT}/src/mods"
LOG_FILE="/var/log/terangaos-setup.log"

source "${REPO_ROOT}/src/lib/common.sh"

# ============================================================
# Afficher les mods disponibles
# ============================================================
list_mods() {
    echo ""
    echo -e "${BLUE}${BOLD}Mods TérangaOS disponibles :${NC}"
    echo ""
    for mod_dir in "${MODS_DIR}"/*/; do
        mod_name=$(basename "$mod_dir")
        if [ -f "${mod_dir}/install.sh" ]; then
            desc=$(grep "^# MOD" "${mod_dir}/install.sh" 2>/dev/null | \
                   sed 's/# MOD [0-9]* — //' || echo "")
            printf "  %-35s %s\n" "${mod_name}" "${desc}"
        fi
    done
    echo ""
}

# ============================================================
# Exécuter un mod
# ============================================================
run_mod() {
    local mod_dir="$1"
    local mod_name
    mod_name=$(basename "$mod_dir")

    if [ ! -f "${mod_dir}/install.sh" ]; then
        log_warn "Mod ignoré (pas de install.sh) : ${mod_name}"
        return 0
    fi

    local start
    start=$(date +%s)
    log_info "▶ ${mod_name}..."

    if bash "${mod_dir}/install.sh" 2>&1 | tee -a "$LOG_FILE"; then
        local duration=$(( $(date +%s) - start ))
        log_info "✓ ${mod_name} (${duration}s)"
    else
        log_error "✗ ${mod_name} a échoué ! Voir : ${LOG_FILE}"
        exit 1
    fi
}

# ============================================================
# MAIN
# ============================================================
main() {
    local only_mod=""
    local do_list=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --mod|-m)   only_mod="$2"; shift 2 ;;
            --list|-l)  do_list=true; shift ;;
            --help|-h)
                echo "Usage: sudo bash $0 [--mod <numéro>] [--list]"
                exit 0 ;;
            *) log_error "Argument inconnu : $1"; exit 1 ;;
        esac
    done

    # Root check
    if [[ $EUID -ne 0 ]]; then
        log_error "Exécuter avec sudo : sudo bash $0"
        exit 1
    fi

    touch "$LOG_FILE"

    if [ "$do_list" = true ]; then
        list_mods
        exit 0
    fi

    # Bannière
    echo ""
    echo -e "${GREEN}${BOLD}"
    echo "  ╔══════════════════════════════════════════════╗"
    echo "  ║                                              ║"
    echo "  ║   🇸🇳  TérangaOS — Installation modulaire    ║"
    echo "  ║   Raspberry Pi Edition — v0.1 Alpha          ║"
    echo "  ║                                              ║"
    echo "  ╚══════════════════════════════════════════════╝"
    echo -e "${NC}"

    local start_total
    start_total=$(date +%s)

    if [ -n "$only_mod" ]; then
        # Exécuter un seul mod
        local found=false
        for mod_dir in "${MODS_DIR}"/*/; do
            if [[ "$(basename "$mod_dir")" == "${only_mod}"* ]]; then
                run_mod "$mod_dir"
                found=true
                break
            fi
        done
        if [ "$found" = false ]; then
            log_error "Mod '${only_mod}' non trouvé. Utilisez --list pour voir les mods."
            exit 1
        fi
    else
        # Confirmation avant installation complète
        echo -e "${YELLOW}Ce script va transformer votre RPi en TérangaOS.${NC}"
        echo -e "${YELLOW}Durée estimée : 30-60 minutes selon la connexion.${NC}"
        echo ""
        read -p "Continuer ? (o/N) " -n 1 -r; echo
        [[ ! $REPLY =~ ^[Oo]$ ]] && echo "Annulé." && exit 0

        # Exécuter tous les mods dans l'ordre
        for mod_dir in "${MODS_DIR}"/*/; do
            run_mod "$mod_dir"
        done
    fi

    local duration=$(( ($(date +%s) - start_total) / 60 ))
    echo ""
    echo -e "${GREEN}${BOLD}"
    echo "  ╔══════════════════════════════════════════════╗"
    echo "  ║   ✅ Installation terminée en ${duration} min        ║"
    echo "  ║                                              ║"
    echo "  ║   → sudo reboot  pour redémarrer             ║"
    echo "  ║   → Ndank ndank mooy jàpp golo ci ñaay 🌍   ║"
    echo "  ╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo "  Log complet : ${LOG_FILE}"
}

main "$@"
