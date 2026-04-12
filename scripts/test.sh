#!/bin/bash
# ============================================================
# TérangaOS — Tests automatisés
# Vérifie la cohérence de la configuration
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

pass() {
    echo -e "  ✅ ${GREEN}PASS${NC}: $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
    echo -e "  ❌ ${RED}FAIL${NC}: $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

echo ""
echo "🧪 TérangaOS — Suite de tests"
echo "═══════════════════════════════"

# --- Test 1: Structure du projet ---
echo ""
echo "📁 Structure du projet :"
for dir in config/package-lists config/hooks config/preseed scripts docs branding security; do
    if [[ -d "${PROJECT_ROOT}/${dir}" ]]; then
        pass "Dossier ${dir}/ existe"
    else
        fail "Dossier ${dir}/ manquant"
    fi
done

# --- Test 2: Fichiers requis ---
echo ""
echo "📄 Fichiers requis :"
for file in README.md LICENSE CONTRIBUTING.md CODE_OF_CONDUCT.md SECURITY.md Makefile; do
    if [[ -f "${PROJECT_ROOT}/${file}" ]]; then
        pass "${file} existe"
    else
        fail "${file} manquant"
    fi
done

# --- Test 3: Listes de paquets ---
echo ""
echo "📦 Listes de paquets :"
for edition in base desktop leger server; do
    if [[ -f "${PROJECT_ROOT}/config/package-lists/${edition}.list.chroot" ]]; then
        count=$(grep -cve '^\s*$' "${PROJECT_ROOT}/config/package-lists/${edition}.list.chroot" | head -1 || echo 0)
        pass "${edition}.list.chroot (${count} paquets)"
    else
        fail "${edition}.list.chroot manquant"
    fi
done

# --- Test 4: Scripts exécutables ---
echo ""
echo "⚙️  Scripts :"
for script in scripts/build.sh scripts/check-deps.sh scripts/test.sh; do
    if [[ -f "${PROJECT_ROOT}/${script}" ]]; then
        if [[ -x "${PROJECT_ROOT}/${script}" ]]; then
            pass "${script} est exécutable"
        else
            fail "${script} n'est pas exécutable (chmod +x ${script})"
        fi
    else
        fail "${script} manquant"
    fi
done

# --- Résultats ---
echo ""
echo "═══════════════════════════════"
TOTAL=$((TESTS_PASSED + TESTS_FAILED))
echo -e "Résultats : ${GREEN}${TESTS_PASSED} passés${NC} / ${RED}${TESTS_FAILED} échoués${NC} / ${TOTAL} total"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "${GREEN}🎉 Tous les tests passent !${NC}"
    exit 0
else
    echo -e "${RED}⚠️  Certains tests échouent. Corrigez les problèmes ci-dessus.${NC}"
    exit 1
fi
