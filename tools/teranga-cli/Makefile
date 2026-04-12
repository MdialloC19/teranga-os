# ============================================================
# TérangaOS — teranga-cli Makefile
# ============================================================

CC      := gcc
CFLAGS  := -Wall -Wextra -Wpedantic -O2 -std=c11
LDFLAGS :=
TARGET  := teranga
SRC     := src/main.c
PREFIX  := /usr/local

.PHONY: all clean install uninstall deb

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "✓ Compilé : $(TARGET)"

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
	rm -f $(TARGET)
	@echo "✓ Nettoyé"
