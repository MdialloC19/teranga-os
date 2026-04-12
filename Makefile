# ============================================================
# TérangaOS — Makefile
# Distribution Linux souveraine pour l'Afrique
# ============================================================

.PHONY: all desktop leger server clean test-qemu help

# Variables
BUILD_DIR := build
OUTPUT_DIR := $(BUILD_DIR)/output
EDITION ?= desktop
VERSION := 0.1.0-alpha

# Couleurs pour l'affichage
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
NC     := \033[0m # No Color

# ============================================================
# Aide
# ============================================================
help: ## Afficher cette aide
	@echo ""
	@echo "  🇸🇳 $(GREEN)TérangaOS$(NC) v$(VERSION) — Commandes disponibles"
	@echo "  ─────────────────────────────────────────────"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

# ============================================================
# Build des éditions
# ============================================================
all: desktop leger server ## Construire toutes les éditions

desktop: ## Construire TérangaOS Desktop (KDE Plasma)
	@echo "$(GREEN)[TérangaOS]$(NC) Construction de l'édition Desktop (KDE Plasma 6)..."
	@bash scripts/build.sh desktop $(VERSION)

leger: ## Construire TérangaOS Léger (Xfce)
	@echo "$(GREEN)[TérangaOS]$(NC) Construction de l'édition Léger (Xfce)..."
	@bash scripts/build.sh leger $(VERSION)

server: ## Construire TérangaOS Server (CLI)
	@echo "$(GREEN)[TérangaOS]$(NC) Construction de l'édition Server..."
	@bash scripts/build.sh server $(VERSION)

kiosk: ## Construire TérangaOS Kiosk (navigateur plein écran)
	@echo "$(GREEN)[TérangaOS]$(NC) Construction de l'édition Kiosk..."
	@bash scripts/build.sh kiosk $(VERSION)

# ============================================================
# Tests
# ============================================================
test: ## Lancer les tests automatisés
	@echo "$(GREEN)[TérangaOS]$(NC) Lancement des tests..."
	@bash scripts/test.sh

test-qemu: ## Tester l'ISO dans QEMU (nécessite qemu-system-x86_64)
	@echo "$(GREEN)[TérangaOS]$(NC) Lancement de l'ISO dans QEMU..."
	@ISO=$$(ls -t $(OUTPUT_DIR)/*.iso 2>/dev/null | head -1); \
	if [ -z "$$ISO" ]; then \
		echo "$(RED)[ERREUR]$(NC) Aucune ISO trouvée. Lancez d'abord 'make desktop'"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)[INFO]$(NC) Lancement de $$ISO"; \
	qemu-system-x86_64 \
		-m 4096 \
		-smp 2 \
		-enable-kvm \
		-cdrom "$$ISO" \
		-boot d \
		-vga virtio \
		-display gtk

# ============================================================
# Nettoyage
# ============================================================
clean: ## Nettoyer les fichiers de build
	@echo "$(YELLOW)[TérangaOS]$(NC) Nettoyage..."
	@rm -rf $(BUILD_DIR)
	@echo "$(GREEN)[TérangaOS]$(NC) Nettoyage terminé."

clean-all: clean ## Nettoyage complet (build + cache)
	@echo "$(YELLOW)[TérangaOS]$(NC) Nettoyage complet..."
	@sudo rm -rf .build_cache
	@echo "$(GREEN)[TérangaOS]$(NC) Nettoyage complet terminé."

# ============================================================
# Utilitaires
# ============================================================
check-deps: ## Vérifier les dépendances de build
	@echo "$(GREEN)[TérangaOS]$(NC) Vérification des dépendances..."
	@bash scripts/check-deps.sh

version: ## Afficher la version
	@echo "TérangaOS v$(VERSION)"

.DEFAULT_GOAL := help
