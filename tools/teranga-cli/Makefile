# ============================================================
# TérangaOS — teranga-cli Makefile
# ============================================================

CC      := gcc
CFLAGS  := -Wall -Wextra -Wpedantic -O2 -std=c11 -Iinc
LDFLAGS :=
TARGET  := teranga
SRC     := src/main.c
PREFIX  := /usr/local

# Cross-compilation ARM64 (Raspberry Pi 5)
CC_ARM64  := aarch64-linux-gnu-gcc
TARGET_ARM64 := teranga-arm64

.PHONY: all arm64 clean install uninstall deb

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "✓ Compilé : $(TARGET) (x86_64)"

# Cross-compiler pour RPi 5
arm64: $(SRC)
	$(CC_ARM64) $(CFLAGS) -o $(TARGET_ARM64) $^ $(LDFLAGS)
	@echo "✓ Compilé : $(TARGET_ARM64) (ARM64/RPi)"

install: $(TARGET)
	install -Dm755 $(TARGET) $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "✓ Installé : $(PREFIX)/bin/$(TARGET)"

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/$(TARGET)
	@echo "✓ Désinstallé"

# Construire un paquet .deb
deb: $(TARGET)
	@bash ../../scripts/build-deb-cli.sh

clean:
	rm -f $(TARGET) $(TARGET_ARM64)
	@echo "✓ Nettoyé"
