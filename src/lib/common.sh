#!/bin/bash
# ============================================================
# LIB — Fonctions communes à tous les mods
# ============================================================

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'
BLUE='\033[0;34m'; BOLD='\033[1m'; NC='\033[0m'

# Log file : seulement si on est root
if [[ $EUID -eq 0 ]]; then
    LOG_FILE="/var/log/terangaos-setup.log"
    touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/dev/null"
else
    LOG_FILE="/dev/null"
fi

log_info()  { echo -e "${GREEN}[TérangaOS]${NC} $*" | tee -a "$LOG_FILE"; }
log_warn()  { echo -e "${YELLOW}[ATTENTION]${NC} $*" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERREUR]${NC} $*" | tee -a "$LOG_FILE" >&2; }
log_step()  { echo -e "\n${BLUE}${BOLD}══════════════════════════════${NC}"; \
              echo -e "${BLUE}${BOLD}  $*${NC}"; \
              echo -e "${BLUE}${BOLD}══════════════════════════════${NC}\n"; }

# Chemin racine du repo (2 niveaux au-dessus de src/mods/<mod>/)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
