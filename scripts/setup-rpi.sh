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
ARGS_SH="${REPO_ROOT}/src/lib/args.sh"
EDITIONS_JSON="${REPO_ROOT}/config/editions.json"
LOG_FILE="/var/log/terangaos-setup.log"

source "${REPO_ROOT}/src/lib/common.sh"

# ============================================================
# Charger une édition depuis editions.json → args.sh
# ============================================================
load_edition() {
    local edition="${1:-rpi}"

    if ! command -v jq &>/dev/null; then
        log_warn "jq non installé — config JSON ignorée, valeurs par défaut utilisées"
        source "$ARGS_SH"
        return 0
    fi

    local config
    config=$(jq -c ".[] | select(.edition == \"${edition}\")" "$EDITIONS_JSON" 2>/dev/null)

    if [ -z "$config" ]; then
        log_error "Édition '${edition}' introuvable dans ${EDITIONS_JSON}"
        exit 1
    fi

    log_info "Chargement édition '${edition}' depuis editions.json..."

    # Remplir args.sh dynamiquement (comme AnduinOS)
    cat > "$ARGS_SH" << ARGS
#!/bin/bash
# Généré par setup-rpi.sh le $(date '+%Y-%m-%d %H:%M:%S')
# Source: editions.json → edition="${edition}"

export TERANGA_EDITION="$(echo "$config" | jq -r '.edition')"
export TERANGA_NAME="$(echo "$config" | jq -r '.name')"
export TERANGA_VERSION="0.1"
export TERANGA_CODENAME="Diamniadio"
export TERANGA_HOSTNAME="$(echo "$config" | jq -r '.hostname')"
export TERANGA_ARCH="$(echo "$config" | jq -r '.arch')"
export TERANGA_DESKTOP="$(echo "$config" | jq -r '.desktop')"
export TERANGA_THEME="$(echo "$config" | jq -r '.theme')"
export TERANGA_ICONS="$(echo "$config" | jq -r '.icons')"
export TERANGA_FONT="$(echo "$config" | jq -r '.font')"
export TERANGA_LANG="$(echo "$config" | jq -r '.lang')"
export TERANGA_TIMEZONE="$(echo "$config" | jq -r '.timezone')"
export TERANGA_KEYBOARD="$(echo "$config" | jq -r '.keyboard')"
export TERANGA_OUTPUT="$(echo "$config" | jq -r '.output_name')"
export TERANGA_WALLPAPER="dakar-sunset"
export TERANGA_CURSOR="Bibata-Modern-Classic"
ARGS

    source "$ARGS_SH"
    log_info "✓ Config chargée : THEME=${TERANGA_THEME} | LANG=${TERANGA_LANG} | HOSTNAME=${TERANGA_HOSTNAME}"
}

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
    local edition="rpi"  # édition par défaut

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --edition|-e) edition="$2"; shift 2 ;;
            --mod|-m)     only_mod="$2"; shift 2 ;;
            --list|-l)    do_list=true; shift ;;
            --help|-h)
                echo "Usage: sudo bash $0 [--edition rpi|desktop|leger|server] [--mod <n>] [--list]"
                echo "  --edition   Édition à installer (défaut: rpi)"
                echo "  --mod       Exécuter un seul mod"
                echo "  --list      Lister les mods disponibles"
                exit 0 ;;
            *) log_error "Argument inconnu : $1"; exit 1 ;;
        esac
    done

    # Root check
    if [[ $EUID -ne 0 ]]; then
        log_error "Exécuter avec sudo : sudo bash $0"
        exit 1
    fi

    touch "$LOG_FILE" 2>/dev/null || true

    # ── Charger la config depuis editions.json ──
    load_edition "$edition"

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
    printf "  ║   %-44s║\n" "${TERANGA_NAME} — v${TERANGA_VERSION}"
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
