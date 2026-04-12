#!/bin/bash
# ============================================================
# TérangaOS — Builder le paquet .deb pour teranga-cli
# ============================================================

set -euo pipefail

TOOL_DIR="$(cd "$(dirname "$0")/../tools/teranga-cli" && pwd)"
VERSION="0.1.0"
ARCH=$(dpkg --print-architecture 2>/dev/null || echo "arm64")
PKG_NAME="teranga-cli"
PKG_DIR="/tmp/${PKG_NAME}_${VERSION}_${ARCH}"

echo "[TérangaOS] Construction du paquet ${PKG_NAME}_${VERSION}_${ARCH}.deb..."

# Compiler le binaire
cd "${TOOL_DIR}"
make clean && make

# Créer la structure du paquet
mkdir -p "${PKG_DIR}/DEBIAN"
mkdir -p "${PKG_DIR}/usr/bin"
mkdir -p "${PKG_DIR}/usr/share/doc/${PKG_NAME}"
mkdir -p "${PKG_DIR}/usr/share/man/man1"

# Copier le binaire
install -m 755 "${TOOL_DIR}/teranga" "${PKG_DIR}/usr/bin/teranga"

# Fichier de contrôle Debian
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
Description: Outil de gestion système TérangaOS
 teranga-cli est l'outil en ligne de commande officiel de TérangaOS.
 Il permet de vérifier l'état du système, auditer la sécurité,
 lancer des mises à jour et afficher les informations système.
CONTROL

# Documentation
cat > "${PKG_DIR}/usr/share/doc/${PKG_NAME}/copyright" << COPYRIGHT
TérangaOS — teranga-cli
Copyright (C) 2026 Moussa Diallo
Licence: GNU General Public License v3.0
https://github.com/MdialloC19/teranga-os
COPYRIGHT

# Construire le .deb
dpkg-deb --build "${PKG_DIR}" "build/output/${PKG_NAME}_${VERSION}_${ARCH}.deb"

echo "[TérangaOS] ✓ Paquet créé : build/output/${PKG_NAME}_${VERSION}_${ARCH}.deb"
echo "[TérangaOS] Pour installer : sudo dpkg -i build/output/${PKG_NAME}_${VERSION}_${ARCH}.deb"

# Nettoyage
rm -rf "${PKG_DIR}"
