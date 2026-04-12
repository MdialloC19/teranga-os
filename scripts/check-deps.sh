#!/bin/bash
# ============================================================
# TérangaOS — Vérification des dépendances
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}[TérangaOS]${NC} Vérification des dépendances de build..."
echo ""

MISSING=0

check() {
    local name="$1"
    local package="${2:-$1}"
    if command -v "$name" &> /dev/null; then
        echo -e "  ✅ ${GREEN}${name}${NC} — installé"
    else
        echo -e "  ❌ ${RED}${name}${NC} — MANQUANT (apt install ${package})"
        MISSING=$((MISSING + 1))
    fi
}

echo "Outils de build :"
check "lb" "live-build"
check "debootstrap" "debootstrap"
check "xorriso" "xorriso"
check "mtools" "mtools"
check "git" "git"
check "make" "make"

echo ""
echo "Outils optionnels :"
check "qemu-system-x86_64" "qemu-system-x86"
check "docker" "docker.io"

echo ""
if [[ $MISSING -eq 0 ]]; then
    echo -e "${GREEN}✅ Toutes les dépendances sont installées !${NC}"
else
    echo -e "${YELLOW}⚠️  ${MISSING} dépendance(s) manquante(s).${NC}"
    echo -e "Installez-les avec :"
    echo -e "  ${GREEN}sudo apt install -y live-build debootstrap xorriso mtools git make${NC}"
fi
