#!/bin/bash
# ============================================================
# TérangaOS — Test ISO build workflow locally (dry-run)
# Simulates what build-iso.yml does, step by step
# Run: bash scripts/test-build-local.sh
# ============================================================

set -euo pipefail

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'

pass() { echo -e "${GREEN}  ✓ $*${NC}"; }
fail() { echo -e "${RED}  ✗ $*${NC}"; ERRORS=$((ERRORS+1)); }
warn() { echo -e "${YELLOW}  ⚠ $*${NC}"; }

ERRORS=0
EDITION="${1:-desktop}"

echo ""
echo "🇸🇳 TérangaOS — Build Workflow Dry-Run"
echo "  Edition: ${EDITION}"
echo "========================================="
echo ""

# --- Step 1: Check editions.json ---
echo "📋 Step 1: Read editions.json"

if ! command -v jq &>/dev/null; then
    fail "jq not installed (brew install jq)"
else
    CONFIG=$(jq -c ".[] | select(.edition == \"${EDITION}\")" config/editions.json 2>/dev/null)
    if [ -z "$CONFIG" ]; then
        fail "Edition '${EDITION}' not found in config/editions.json"
    else
        ARCH=$(echo "$CONFIG" | jq -r '.arch')
        LANG_VAL=$(echo "$CONFIG" | jq -r '.lang')
        KB=$(echo "$CONFIG" | jq -r '.keyboard')
        TZ=$(echo "$CONFIG" | jq -r '.timezone')
        HOST=$(echo "$CONFIG" | jq -r '.hostname')
        OUTPUT=$(echo "$CONFIG" | jq -r '.output_name')
        DESKTOP=$(echo "$CONFIG" | jq -r '.desktop')

        pass "Edition: ${EDITION} | Arch: ${ARCH} | Desktop: ${DESKTOP}"
        pass "Lang: ${LANG_VAL} | TZ: ${TZ} | KB: ${KB}"
        pass "Hostname: ${HOST} | Output: ${OUTPUT}"
    fi
fi

echo ""

# --- Step 2: Check package lists ---
echo "📦 Step 2: Verify package lists"

if [ -f "config/package-lists/base.list.chroot" ]; then
    COUNT=$(wc -l < config/package-lists/base.list.chroot | tr -d ' ')
    pass "base.list.chroot (${COUNT} lines)"
else
    fail "config/package-lists/base.list.chroot MISSING"
fi

if [ -f "config/package-lists/${EDITION}.list.chroot" ]; then
    COUNT=$(wc -l < "config/package-lists/${EDITION}.list.chroot" | tr -d ' ')
    pass "${EDITION}.list.chroot (${COUNT} lines)"
elif [ -f "config/package-lists/desktop.list.chroot" ]; then
    COUNT=$(wc -l < config/package-lists/desktop.list.chroot | tr -d ' ')
    warn "No ${EDITION}.list.chroot — will use desktop.list.chroot (${COUNT} lines)"
else
    fail "No package list found for ${EDITION}"
fi

echo ""

# --- Step 3: Check hooks ---
echo "🪝 Step 3: Verify hooks"

HOOK_COUNT=$(ls config/hooks/*.hook.chroot 2>/dev/null | wc -l | tr -d ' ')
if [ "$HOOK_COUNT" -gt 0 ]; then
    pass "${HOOK_COUNT} hooks found"
    for h in config/hooks/*.hook.chroot; do
        if bash -n "$h" 2>/dev/null; then
            pass "  $(basename $h) — syntax OK"
        else
            fail "  $(basename $h) — SYNTAX ERROR"
        fi
    done
else
    warn "No hooks found in config/hooks/"
fi

echo ""

# --- Step 4: Simulate lb config command ---
echo "⚙️  Step 4: Simulated lb config command"

LB_CMD="lb config \\
  --architecture \"${ARCH}\" \\
  --distribution bookworm \\
  --mirror-bootstrap \"http://deb.debian.org/debian\" \\
  --mirror-chroot \"http://deb.debian.org/debian\" \\
  --mirror-binary \"http://deb.debian.org/debian\" \\
  --archive-areas \"main contrib non-free non-free-firmware\" \\
  --apt-recommends false \\
  --binary-images iso-hybrid \\
  --bootloader \"grub-efi\" \\
  --bootappend-live \"boot=live components locales=${LANG_VAL} keyboard-layouts=${KB} timezone=${TZ} hostname=${HOST}\" \\
  --memtest none \\
  --initsystem systemd"

echo "$LB_CMD"
pass "lb config command generated"

echo ""

# --- Step 5: Check branding assets ---
echo "🎨 Step 5: Verify branding assets"

for f in assets/branding/logo/logo.png assets/branding/wallpapers/dakar-sunset.png; do
    if [ -f "$f" ]; then
        SIZE=$(du -h "$f" | cut -f1)
        pass "$f (${SIZE})"
    else
        warn "$f MISSING"
    fi
done

echo ""

# --- Step 6: Verify all mods ---
echo "🧩 Step 6: Verify mods syntax"

MOD_COUNT=0
MOD_ERRORS=0
for mod_dir in src/mods/*/; do
    mod_name=$(basename "$mod_dir")
    install_sh="${mod_dir}install.sh"
    if [ -f "$install_sh" ]; then
        if bash -n "$install_sh" 2>/dev/null; then
            pass "$mod_name/install.sh — syntax OK"
            MOD_COUNT=$((MOD_COUNT+1))
        else
            fail "$mod_name/install.sh — SYNTAX ERROR"
            MOD_ERRORS=$((MOD_ERRORS+1))
        fi
    else
        warn "$mod_name — no install.sh"
    fi
done
pass "${MOD_COUNT} mods validated, ${MOD_ERRORS} errors"

echo ""

# --- Step 7: Check workflow YAML ---
echo "📄 Step 7: Validate build-iso.yml"

WORKFLOW=".github/workflows/build-iso.yml"
if [ -f "$WORKFLOW" ]; then
    # Check required keys
    for key in "workflow_dispatch" "live-build" "lb config" "lb build" "upload-artifact"; do
        if grep -q "$key" "$WORKFLOW"; then
            pass "Found: $key"
        else
            fail "Missing: $key in workflow"
        fi
    done

    # Check --bootloader (not --bootloaders)
    if grep -q "\-\-bootloaders" "$WORKFLOW"; then
        fail "--bootloaders found (should be --bootloader singular)"
    else
        pass "--bootloader spelling correct"
    fi

    # Check uses Debian container (not Ubuntu runner directly)
    if grep -q "debian:bookworm" "$WORKFLOW"; then
        pass "Uses Debian container (avoids Ubuntu keyring issues)"
    else
        warn "Not using Debian container — may have keyring/mirror issues"
    fi
else
    fail "$WORKFLOW not found"
fi

echo ""

# --- SUMMARY ---
echo "========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed! Ready to push and build.${NC}"
else
    echo -e "${RED}❌ ${ERRORS} error(s) found. Fix before pushing.${NC}"
fi
echo "========================================="
echo ""

exit $ERRORS
