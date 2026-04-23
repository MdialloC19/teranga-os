#!/bin/bash
# ============================================================
# MOD 00 — System verification
# ============================================================
source "$(dirname "$0")/../../lib/common.sh"

mod_name="00-check-system"

log_step "[${mod_name}] System verification"

# Root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root"
    exit 1
fi
log_info "Root privileges ✓"

# ARM64 architecture
arch=$(uname -m)
if [[ "$arch" != "aarch64" ]]; then
    log_warn "Architecture: ${arch} (expected: aarch64)"
    read -p "Continue anyway? (y/N) " -n 1 -r; echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
fi
log_info "Architecture: ${arch} ✓"

# Raspberry Pi
if ! grep -q "Raspberry Pi\|BCM" /proc/cpuinfo 2>/dev/null; then
    log_warn "Hardware not recognized as Raspberry Pi"
    read -p "Continue anyway? (y/N) " -n 1 -r; echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
fi
log_info "RPi hardware detected ✓"

# Disk space (10 GB minimum)
available=$(df / --output=avail -BG | tail -1 | tr -d ' G')
if [[ "$available" -lt 10 ]]; then
    log_error "Insufficient disk space: ${available}GB (minimum 10GB)"
    exit 1
fi
log_info "Disk space: ${available}GB available ✓"

log_info "[${mod_name}] ✓ All checks passed"
