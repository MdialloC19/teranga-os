#!/bin/bash
# ============================================================
# TérangaOS — Main build script
# Builds a live/installable ISO based on Debian
# ============================================================

set -euo pipefail

# --- Variables ---
EDITION="${1:?Usage: $0 <desktop|leger|server|kiosk> [version]}"
VERSION="${2:-0.1.0-alpha}"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="${PROJECT_ROOT}/build/${EDITION}"
OUTPUT_DIR="${PROJECT_ROOT}/build/output"
CONFIG_DIR="${PROJECT_ROOT}/config"

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[TérangaOS]${NC} $*"; }
log_warn()  { echo -e "${YELLOW}[WARNING]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# --- Checks ---
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root (sudo)"
        exit 1
    fi
}

check_dependencies() {
    local deps=(live-build debootstrap xorriso mtools)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_error "Missing dependency: $dep"
            log_info "Install with: sudo apt install -y ${deps[*]}"
            exit 1
        fi
    done
    log_info "All dependencies present ✓"
}

# --- live-build configuration ---
configure_build() {
    log_info "Configuring edition: ${EDITION} v${VERSION}"

    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"

    # Cleanup if previous build
    lb clean 2>/dev/null || true

    # Base configuration
    lb config \
        --distribution bookworm \
        --archive-areas "main contrib non-free non-free-firmware" \
        --bootappend-live "boot=live components locales=fr_FR.UTF-8 keyboard-layouts=fr" \
        --debian-installer live \
        --iso-application "TérangaOS" \
        --iso-publisher "TérangaOS Project; https://teranga-os.org" \
        --iso-volume "TérangaOS-${EDITION}-${VERSION}" \
        --image-name "terangaos-${EDITION}-${VERSION}" \
        --apt-recommends true \
        --security true \
        --updates true \
        --backports true

    # Copy package lists per edition
    mkdir -p config/package-lists
    cp "${CONFIG_DIR}/package-lists/base.list.chroot" config/package-lists/
    cp "${CONFIG_DIR}/package-lists/${EDITION}.list.chroot" config/package-lists/

    # Copy files to include in ISO
    if [[ -d "${CONFIG_DIR}/includes.chroot" ]]; then
        cp -r "${CONFIG_DIR}/includes.chroot" config/
    fi

    # Copy post-installation hooks
    if [[ -d "${CONFIG_DIR}/hooks" ]]; then
        mkdir -p config/hooks/normal
        cp "${CONFIG_DIR}/hooks/"*.hook.chroot config/hooks/normal/ 2>/dev/null || true
    fi

    # Copy preseed
    if [[ -f "${CONFIG_DIR}/preseed/${EDITION}.preseed.cfg" ]]; then
        mkdir -p config/includes.installer
        cp "${CONFIG_DIR}/preseed/${EDITION}.preseed.cfg" config/includes.installer/preseed.cfg
    fi

    log_info "Configuration complete ✓"
}

# --- Build ---
build_iso() {
    log_info "Building ISO... (this may take 15-30 minutes)"
    
    cd "${BUILD_DIR}"
    lb build 2>&1 | tee "${BUILD_DIR}/build.log"

    # Move ISO to output folder
    mkdir -p "${OUTPUT_DIR}"
    mv *.iso "${OUTPUT_DIR}/" 2>/dev/null || true

    local iso_file
    iso_file=$(ls -t "${OUTPUT_DIR}"/*.iso 2>/dev/null | head -1)

    if [[ -n "$iso_file" ]]; then
        local iso_size
        iso_size=$(du -h "$iso_file" | cut -f1)
        log_info "═══════════════════════════════════════════"
        log_info "Build successful!"
        log_info "  📀 ISO : ${iso_file}"
        log_info "  📏 Size : ${iso_size}"
        log_info "═══════════════════════════════════════════"
    else
        log_error "No ISO generated. Check ${BUILD_DIR}/build.log"
        exit 1
    fi
}

# --- Main ---
main() {
    log_info "═══════════════════════════════════════════"
    log_info "  🇸🇳 TérangaOS Builder v${VERSION}"
    log_info "  Édition : ${EDITION}"
    log_info "═══════════════════════════════════════════"

    check_root
    check_dependencies
    configure_build
    build_iso
}

main "$@"
