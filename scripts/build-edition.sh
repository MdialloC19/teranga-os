#!/bin/bash
# ============================================================
# TérangaOS — Main build script
# Reads config/editions.json and builds corresponding ISO
#
# Usage:
#   sudo bash scripts/build-edition.sh --edition rpi
#   sudo bash scripts/build-edition.sh --edition desktop
#   sudo bash scripts/build-edition.sh --edition leger
#   sudo bash scripts/build-edition.sh --edition server
#   sudo bash scripts/build-edition.sh --all
# ============================================================

set -euo pipefail

CONFIG_JSON="./config/editions.json"
BUILD_DIR="./build"
OUTPUT_DIR="${BUILD_DIR}/output"
LOG_DIR="${BUILD_DIR}/logs"

# --- Colors ---
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

log_info()  { echo -e "${GREEN}[TérangaOS]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARNING]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_step()  { echo -e "\n${BLUE}${BOLD}══ $* ══${NC}\n"; }

# ============================================================
# Checks
# ============================================================
check_deps() {
    local missing=0

    for cmd in jq live-build debootstrap git; do
        if ! command -v "$cmd" &>/dev/null; then
            log_warn "Missing: $cmd"
            missing=1
        fi
    done

    if [ "$missing" -eq 1 ]; then
        log_info "Installing dependencies..."
        apt-get update -qq
        apt-get install -y live-build debootstrap jq git
    fi
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        echo "Usage: sudo bash $0 --edition rpi"
        exit 1
    fi
}

# ============================================================
# Read JSON config of an edition
# ============================================================
get_edition_config() {
    local edition="$1"
    jq -c ".[] | select(.edition == \"${edition}\")" "$CONFIG_JSON"
}

get_field() {
    local config="$1"
    local field="$2"
    echo "$config" | jq -r ".${field}"
}

# ============================================================
# Build an edition
# ============================================================
build_edition() {
    local edition="$1"
    local config
    config=$(get_edition_config "$edition")

    if [ -z "$config" ]; then
        log_error "Edition '$edition' not found in ${CONFIG_JSON}"
        echo "Available editions: rpi, desktop, leger, server"
        exit 1
    fi

    # Read parameters
    local name arch desktop theme icons font lang timezone keyboard hostname output_name
    name=$(get_field "$config" "name")
    arch=$(get_field "$config" "arch")
    desktop=$(get_field "$config" "desktop")
    theme=$(get_field "$config" "theme")
    lang=$(get_field "$config" "lang")
    timezone=$(get_field "$config" "timezone")
    keyboard=$(get_field "$config" "keyboard")
    hostname=$(get_field "$config" "hostname")
    output_name=$(get_field "$config" "output_name")

    log_step "Build: ${name}"
    log_info "  Edition   : ${edition}"
    log_info "  Arch      : ${arch}"
    log_info "  Desktop   : ${desktop}"
    log_info "  Theme     : ${theme}"
    log_info "  Output    : ${output_name}.iso"

    # Create folders
    mkdir -p "${OUTPUT_DIR}" "${LOG_DIR}"
    local log_file="${LOG_DIR}/${edition}-build.log"
    local lb_dir="${BUILD_DIR}/lb-${edition}"

    # Clean previous build
    rm -rf "${lb_dir}"
    mkdir -p "${lb_dir}"
    cd "${lb_dir}"

    # Configure live-build
    lb config \
        --architecture "${arch}" \
        --distribution bookworm \
        --archive-areas "main contrib non-free non-free-firmware" \
        --apt-recommends false \
        --binary-images iso-hybrid \
        --bootappend-live "boot=live components locales=${lang} keyboard-layouts=${keyboard} timezone=${timezone} hostname=${hostname}" \
        --memtest none \
        2>&1 | tee -a "${log_file}"

    # Copy hooks and package lists
    cp -r ../../config/package-lists/base.list.chroot config/package-lists/
    if [ "$desktop" != "none" ]; then
        cp -r ../../config/package-lists/"${edition}".list.chroot \
              config/package-lists/ 2>/dev/null || \
        cp -r ../../config/package-lists/desktop.list.chroot \
              config/package-lists/
    fi

    # Copy preseed configuration (edition-specific or fallback to desktop)
    # Live-build expects preseed at config/preseed.cfg
    if [ -f "../../config/preseed/${edition}.preseed.cfg" ]; then
        cp "../../config/preseed/${edition}.preseed.cfg" config/preseed.cfg
        log_info "Preseed: Using ${edition}.preseed.cfg"
    else
        cp ../../config/preseed/desktop.preseed.cfg config/preseed.cfg
        log_info "Preseed: Using desktop.preseed.cfg (default)"
    fi

    # Copy hooks (organized structure: common + edition-specific)
    mkdir -p config/hooks/live
    
    # Copy common hooks (security, branding - all editions)
    cp ../../config/hooks/common/01-security-hardening.hook.chroot config/hooks/live/
    cp ../../config/hooks/common/02-branding.hook.chroot config/hooks/live/
    log_info "Common hooks: security hardening + branding"
    
    # Copy edition-specific theme hook
    if [ "$edition" = "desktop" ]; then
        cp ../../config/hooks/desktop/03-kde-windows-theme.hook.chroot config/hooks/live/
        log_info "Theme hook: KDE Plasma (desktop edition)"
    else
        # RPi, Leger, Server use Xfce
        cp ../../config/hooks/rpi/03-xfce-windows-theme.hook.chroot config/hooks/live/
        log_info "Theme hook: Xfce lightweight (${edition} edition)"
    fi

    # Launch build
    log_info "Starting build (may take 30-60 min)..."
    lb build 2>&1 | tee -a "${log_file}"

    # Copy ISO to output folder
    if [ -f "live-image-${arch}.hybrid.iso" ]; then
        cp "live-image-${arch}.hybrid.iso" \
           "../../${OUTPUT_DIR}/${output_name}.iso"

        # Generate SHA256 checksum
        sha256sum "../../${OUTPUT_DIR}/${output_name}.iso" | \
            awk '{print $1}' > "../../${OUTPUT_DIR}/${output_name}.sha256"

        log_info "✓ ISO created: ${OUTPUT_DIR}/${output_name}.iso"
        log_info "✓ SHA256  : ${OUTPUT_DIR}/${output_name}.sha256"
    else
        log_error "Build failed! Check logs: ${log_file}"
        exit 1
    fi

    cd - > /dev/null
}

# ============================================================
# MAIN
# ============================================================
main() {
    local edition=""
    local build_all=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -e|--edition)
                edition="$2"
                shift 2
                ;;
            --all)
                build_all=true
                shift
                ;;
            -h|--help)
                echo "Usage: sudo bash $0 --edition <rpi|desktop|leger|server>"
                echo "       sudo bash $0 --all"
                exit 0
                ;;
            *)
                log_error "Unknown argument: $1"
                exit 1
                ;;
        esac
    done

    check_root
    check_deps

    echo ""
    echo -e "${GREEN}${BOLD}"
    echo "  ╔════════════════════════════════════════╗"
    echo "  ║   🇸🇳  TérangaOS — Build ISO            ║"
    echo "  ╚════════════════════════════════════════╝"
    echo -e "${NC}"

    if [ "$build_all" = true ]; then
        log_info "Building all editions..."
        local editions
        mapfile -t editions < <(jq -r '.[].edition' "$CONFIG_JSON")
        for ed in "${editions[@]}"; do
            build_edition "$ed"
        done
    elif [ -n "$edition" ]; then
        build_edition "$edition"
    else
        log_error "Specify an edition: --edition rpi|desktop|leger|server"
        echo "       or --all for all editions"
        exit 1
    fi

    log_info "Build complete! ISOs in: ${OUTPUT_DIR}/"
    ls -lh "${OUTPUT_DIR}/"*.iso 2>/dev/null || true
}

main "$@"
