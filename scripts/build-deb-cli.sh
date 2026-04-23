#!/bin/bash
# ============================================================
# TérangaOS — Build the .deb package for teranga-cli
# ============================================================

set -euo pipefail

TOOL_DIR="$(cd "$(dirname "$0")/../tools/teranga-cli" && pwd)"
VERSION="0.1.0"
ARCH=$(dpkg --print-architecture 2>/dev/null || echo "arm64")
PKG_NAME="teranga-cli"
PKG_DIR="/tmp/${PKG_NAME}_${VERSION}_${ARCH}"

echo "[TérangaOS] Building package ${PKG_NAME}_${VERSION}_${ARCH}.deb..."

# Compile the binary
cd "${TOOL_DIR}"
make clean && make

# Create the package structure
mkdir -p "${PKG_DIR}/DEBIAN"
mkdir -p "${PKG_DIR}/usr/bin"
mkdir -p "${PKG_DIR}/usr/share/doc/${PKG_NAME}"
mkdir -p "${PKG_DIR}/usr/share/man/man1"

# Copy the binary
install -m 755 "${TOOL_DIR}/teranga" "${PKG_DIR}/usr/bin/teranga"

# Debian control file
cat > "${PKG_DIR}/DEBIAN/control" << CONTROL
Package: ${PKG_NAME}
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: Moussa Diallo <contact@teranga-os.org>
Depends: ufw, apparmor, clamav
Recommends: fail2ban
Section: admin
Priority: optional
Homepage: https://teranga-os.org
Description: TérangaOS system management tool
 teranga-cli is the official command-line tool for TérangaOS.
 It allows checking system status, auditing security,
 running updates and displaying system information.
CONTROL

# Documentation
cat > "${PKG_DIR}/usr/share/doc/${PKG_NAME}/copyright" << COPYRIGHT
TérangaOS — teranga-cli
Copyright (C) 2026 Moussa Diallo
Licence: GNU General Public License v3.0
https://github.com/MdialloC19/teranga-os
COPYRIGHT

# Build the .deb
dpkg-deb --build "${PKG_DIR}" "build/output/${PKG_NAME}_${VERSION}_${ARCH}.deb"

echo "[TérangaOS] ✓ Package created: build/output/${PKG_NAME}_${VERSION}_${ARCH}.deb"
echo "[TérangaOS] To install: sudo dpkg -i build/output/${PKG_NAME}_${VERSION}_${ARCH}.deb"

# Cleanup
rm -rf "${PKG_DIR}"
