# teranga-cli

Outil de gestion système en ligne de commande pour **TérangaOS**.

Écrit en **C** — léger, rapide, sans dépendances lourdes.

## Compilation

```bash
# Prérequis : gcc, make
sudo apt install -y gcc make

# Compiler
cd tools/teranga-cli
make

# Installer
sudo make install
```

## Usage

```bash
teranga help          # Aide
teranga version       # Version
teranga info          # Infos système (RAM, CPU, disque, réseau...)
teranga status        # État des services et applications
teranga security      # Audit de sécurité (score /8)
sudo teranga update   # Mettre à jour le système
```

## Exemple de sortie — `teranga security`

```
  🔒 Vérification de sécurité TérangaOS
  ─────────────────────────────────────

  ✓  Firewall UFW actif
  ✓  AppArmor activé
  ⚠  Disque NON chiffré — risque si vol physique
  ✓  Mises à jour automatiques configurées
  ✓  SSH : login root désactivé
  ✓  Fail2ban actif (anti brute-force)
  ✓  Paramètres kernel sécurisés
  ✓  Antivirus ClamAV actif

  Score : 7/8 (87%) — EXCELLENT
```

## Construire le paquet .deb

```bash
# Depuis la racine du projet
mkdir -p build/output
bash scripts/build-deb-cli.sh

# Installer le .deb sur le RPi
sudo dpkg -i build/output/teranga-cli_0.1.0_arm64.deb
```
