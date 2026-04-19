#!/bin/bash
# ============================================================
# MOD 00 — Vérification système
# ============================================================
source "$(dirname "$0")/../../lib/common.sh"

mod_name="00-check-system"

log_step "[${mod_name}] Vérification du système"

# Root
if [[ $EUID -ne 0 ]]; then
    log_error "Ce script doit être exécuté en tant que root"
    exit 1
fi
log_info "Droits root ✓"

# Architecture ARM64
arch=$(uname -m)
if [[ "$arch" != "aarch64" ]]; then
    log_warn "Architecture : ${arch} (attendu: aarch64)"
    read -p "Continuer quand même ? (o/N) " -n 1 -r; echo
    [[ ! $REPLY =~ ^[Oo]$ ]] && exit 1
fi
log_info "Architecture : ${arch} ✓"

# Raspberry Pi
if ! grep -q "Raspberry Pi\|BCM" /proc/cpuinfo 2>/dev/null; then
    log_warn "Matériel non reconnu comme Raspberry Pi"
    read -p "Continuer quand même ? (o/N) " -n 1 -r; echo
    [[ ! $REPLY =~ ^[Oo]$ ]] && exit 1
fi
log_info "Matériel RPi détecté ✓"

# Espace disque (10 Go minimum)
available=$(df / --output=avail -BG | tail -1 | tr -d ' G')
if [[ "$available" -lt 10 ]]; then
    log_error "Espace disque insuffisant : ${available}Go (minimum 10Go)"
    exit 1
fi
log_info "Espace disque : ${available}Go disponible ✓"

log_info "[${mod_name}] ✓ Vérifications passées"
