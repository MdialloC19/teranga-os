<p align="center">
  <img src="assets/branding/logo-banner.png" alt="TérangaOS Logo" width="600">
</p>

<h1 align="center">🇸🇳 TérangaOS</h1>

<p align="center">
  <strong>Distribution Linux souveraine pour l'Afrique</strong><br>
  Basée sur Debian • Interface style Windows • Sécurité intégrée • 100% Open Source
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/Licence-GPLv3-blue.svg" alt="Licence: GPL v3"></a>
  <a href="#"><img src="https://img.shields.io/badge/Base-Debian%2012-red.svg" alt="Base: Debian 12"></a>
  <a href="#"><img src="https://img.shields.io/badge/Bureau-Xfce%204-blue.svg" alt="Bureau: Xfce"></a>
  <a href="#"><img src="https://img.shields.io/badge/État-Alpha-orange.svg" alt="État: Alpha"></a>
  <a href="CONTRIBUTING.md"><img src="https://img.shields.io/badge/PR-Bienvenue-brightgreen.svg" alt="PR Bienvenue"></a>
  <a href="https://github.com/MdialloC19/teranga-os/actions"><img src="https://github.com/MdialloC19/teranga-os/actions/workflows/ci.yml/badge.svg" alt="CI/CD"></a>
</p>

<p align="center">
  <a href="#-qu-est-ce-que-terangaos-">À propos</a> •
  <a href="#-fonctionnalités">Fonctionnalités</a> •
  <a href="#-démarrage-rapide">Démarrage rapide</a> •
  <a href="#-configuration-requise">Configuration requise</a> •
  <a href="#-documentation">Documentation</a> •
  <a href="#-contribuer">Contribuer</a> •
  <a href="#-communauté">Communauté</a>
</p>

<p align="center">
  🇫🇷 <strong>Français</strong> | 🇬🇧 <a href="README_EN.md"><strong>English</strong></a>
</p>

---

## 🌍 Qu'est-ce que TérangaOS ?

**TérangaOS** est une distribution Linux souveraine conçue pour les gouvernements, entreprises et citoyens africains. Elle fournit une interface familière de style Windows basée sur Debian stable, avec une sécurité intégrée et zéro coût de licence.

> *"Teranga"* signifie **hospitalité** en wolof. Notre OS accueille tout le monde — des débutants aux experts.

### Pourquoi TérangaOS ?

| Défi | Solution TérangaOS |
|-----|-------------------|
| **Dépendance technologique** | 100% open source, complètement auditable |
| **Coûts de licences élevés** | Gratuit à jamais, zéro dépendance commerciale |
| **Barrières à l'adoption** | Interface familière style Windows |
| **Pas optimisé pour l'Afrique** | Fonctionne en bas débit, vieux matériel, langues africaines |
| **Préoccupations sécurité** | Chiffrement complet + sécurité durcie par défaut |

---

## ✨ Fonctionnalités

### 🖥️ Interface familière
- Bureau **Xfce 4** avec thème style Windows 11 (Fluent Dark)
- Menu Démarrer, barre des tâches, accrochage fenêtres — exactement comme Windows
- **Aucun terminal requis** pour l'utilisation quotidienne
- Fonds d'écran du Sénégal et Afrique
- Disponible en 8+ langues africaines

### 📦 Suite logicielle complète
- **LibreOffice** — Remplace Microsoft Office
- **Firefox ESR** (durci) — Navigation web sécurisée
- **Thunderbird** — Client email
- **VLC** — Lecteur multimédia
- **GIMP** — Édition d'images
- **Nextcloud Desktop** — Synchronisation & cloud
- **Jitsi Meet** — Vidéoconférence
- **Element (Matrix)** — Messagerie chiffrée

### 🔒 Sécurité par défaut
- **Chiffrement disque complet** (LUKS) obligatoire
- **Contrôle d'accès obligatoire** (AppArmor, mode enforce)
- **Pare-feu activé** par défaut (UFW)
- **Mises à jour de sécurité automatiques**
- **Zéro télémétrie** — vos données restent vôtres
- **Anti-malware** (ClamAV)
- **Noyau durci** avec atténuations CVE
- **Conforme sécurité** (chemin certification ANSSI)

### 🌐 Conçu pour l'Afrique
- **Langues:** Français, Wolof, Pulaar, Serer, Diola, Mandinka, Anglais, Portugais
- **Optimisé bas débit** — conçu pour réseaux 3G/4G
- **Hors ligne** — conçu pour fonctionner sans Internet
- **Résilient** — conçu pour interruptions électriques fréquentes
- **Léger:** Fonctionne avec 512 Mo RAM minimum
- **Actuellement testé sur:** Raspberry Pi 5 avec Debian 12

### 🏢 Prêt pour l'entreprise
- **Intégration FreeIPA** — remplaçant gratuit Active Directory
- **Keycloak SSO** — authentification OIDC/SAML
- **Automation Ansible** — gestion centralisée
- **Intégration SIEM** — monitoring Wazuh
- **Inventaire GLPI** — suivi du matériel
- **Conforme ANSSI** — exigences gouvernement

---

## 📊 État actuel

| Aspect | Statut |
|--------|--------|
| **Phase** | Alpha (développement initial) |
| **Taille dépôt** | ~50 Mo |
| **Code** | ?? lignes |
| **Contributeurs** | ?? actifs |
| **Matériel testé** | 1: Raspberry Pi 5 (ARM64) |
| **OS testé** | Debian 12 (Bookworm) |
| **État build** | ✅ Compile avec succès sur Debian 12 |
| **Prêt production** | ❌ Toujours en développement |

---

## 🚀 Démarrage rapide

### Pour tester (build depuis sources)

Prérequis: **Debian 12 testé** • Ubuntu 22.04+ (compatibilité code seulement, non testé)

```bash
# Installer outils build
sudo apt update
sudo apt install -y live-build debootstrap git make coreutils

# Cloner dépôt
git clone https://github.com/MdialloC19/teranga-os.git
cd teranga-os

# Build édition Desktop
sudo make desktop

# Build édition Légère
sudo make leger

# Build édition Server
sudo make server
```

L'ISO sera générée dans `build/output/`

### Tester avec QEMU

```bash
make test-qemu
```

### Télécharger ISO pré-compilée

> Les ISOs pré-compilées arriveront bientôt sur la page releases

---

## 📋 Configuration requise

### Minimum (Édition Légère)
- CPU 64-bit
- 512 Mo RAM
- 20 Go stockage

### Recommandé (Édition Desktop)
- CPU multi-cœur 2+ GHz
- 2 Go RAM
- 40 Go stockage

### Actuellement testé
- ✅ Raspberry Pi 5 (ARM64) avec Debian 12

### Pas encore testé (Prévu)
- ❌ Matériel Intel x86_64
- ❌ Matériel AMD x86_64
- ❌ Anciens ordinateurs portables (ThinkPad, Dell)


---

## 📖 Documentation

| Document | Objectif |
|----------|----------|
| [Architecture](docs/ARCHITECTURE.md) | Plongée technique |
| [Guide installation](docs/INSTALLATION.md) | Installation pas à pas |
| [Guide utilisateur](docs/USER_GUIDE.md) | Guide d'utilisation |
| [Guide administrateur](docs/ADMIN_GUIDE.md) | Déploiement entreprise |
| [Guide sécurité](docs/SECURITY.md) | Durcissement & politiques |
| [FAQ](docs/FAQ.md) | Questions fréquentes |
| [Dépannage](docs/TROUBLESHOOTING.md) | Résolution problèmes |

---

## 🤝 Contribuer

**Toutes les contributions bienvenues!** Que vous soyez débutant ou expert, nous avons besoin de vous.

### Comment contribuer

- 🐛 **Signaler bugs:** [Ouvrir une issue](https://github.com/MdialloC19/teranga-os/issues)
- 💡 **Proposer fonctionnalités:** [Demande de feature](https://github.com/MdialloC19/teranga-os/issues/new)
- 🔧 **Écrire code:** Voir [CONTRIBUTING.md](CONTRIBUTING.md)
- 🌍 **Traduire:** Aider avec [traductions](docs/TRANSLATION.md)
- 📝 **Améliorer docs:** La documentation a toujours besoin d'aide
- 🧪 **Tester:** Essayer sur différent matériel et signaler résultats

### Domaines où nous avons besoin d'aide

| Domaine | Compétences | Effort |
|---------|------------|--------|
| Packaging Debian | dpkg, apt, live-build | Moyen |
| Design UI/UX | CSS, GTK, Design | Moyen |
| Traductions | Wolof, Pulaar, Serer, etc. | Faible |
| Audit sécurité | CVE audit, hardening | Élevé |
| Documentation | Rédaction technique | Faible |
| Tests | QA, tests matériel | Faible |
| Infrastructure | Ansible, Docker, CI/CD | Moyen |

### Code de conduite

Nous nous engageons pour une communauté inclusive. Lire notre [Code de conduite](CODE_OF_CONDUCT.md).

### Commencer comme contributeur

1. **Forkez** le dépôt
2. **Créez** une branche: `git checkout -b feature/ma-feature`
3. **Modifiez** et testez: `make test`
4. **Committez** clairement: `git commit -m "feat: ajouter ma feature"`
5. **Poussez** et créez une Pull Request

Voir [CONTRIBUTING.md](CONTRIBUTING.md) pour les directives détaillées.

---

## 🏗️ Structure du projet

```
teranga-os/
├── config/                   # Configuration build
│   ├── editions.json         # Définitions éditions
│   ├── package-lists/        # Paquets par édition
│   ├── includes.chroot/      # Fichiers ISO
│   ├── hooks/                # Scripts post-install
│   └── preseed/              # Config install auto
├── branding/                 # Identité visuelle
│   ├── logos/                # Marque TérangaOS
│   ├── wallpapers/           # Fonds d'écran
│   ├── icons/                # Thèmes icônes
│   └── kde-theme/            # Thème bureau
├── security/                 # Configs sécurité
│   ├── apparmor/             # Profils AppArmor
│   ├── firewall/             # Règles UFW
│   └── hardening/            # Scripts durcissement
├── src/                      # Code source
│   ├── lib/                  # Librairies partagées
│   └── mods/                 # Modules build (12+)
├── scripts/                  # Scripts utilitaires
├── tests/                    # Tests automatisés
├── docs/                     # Documentation
├── Makefile                  # Commandes build
├── LICENSE                   # GPLv3
└── README.md                 # README principal (bilingue)
```

---

## 🗺️ Roadmap

### Phase actuelle (Alpha)
- [x] Architecture & fondations
- [x] Modules de base (12 composants)
- [x] Sécurité durcie
- [x] Prototype RPi5 fonctionne
- [ ] Compléter thème Fluent
- [ ] Pipeline build ISO
- [ ] Suite tests (50+ tests)

### Phase suivante
- [ ] Installateur GUI (zéro terminal)
- [ ] Wine pour apps Windows legacy
- [ ] Benchmarks performance
- [ ] ISO Desktop stable
- [ ] Pilote gouvernement

### Futur
- [ ] Éditions Server & Légère
- [ ] Réseau mesh
- [ ] IA locale (Ollama)
- [ ] Production v1.0 LTS
- [ ] Support déploiement massif

---

## 💬 Communauté

| Canal | Lien |
|-------|------|
| **Chat** | [Matrix: #teranga-os:matrix.org](https://matrix.org) |
| **Issues** | [GitHub Issues](https://github.com/MdialloC19/teranga-os/issues) |
| **Discussions** | [GitHub Discussions](https://github.com/MdialloC19/teranga-os/discussions) |
| **Email** | contact@teranga-os.org |

### Directives de communication
- Soyez respectueux et inclusif
- Utilisez français, anglais ou wolof
- Cherchez avant de poser (évitez doublons)
- Soyez spécifique dans issues/questions

---

## 🔐 Sécurité

Trouvé une vulnérabilité? **N'ouvrez pas une issue publique.**

Email: security@teranga-os.org avec:
- Détails de la vulnérabilité
- Étapes de reproduction
- Impact potentiel

Voir [SECURITY.md](SECURITY.md) pour la politique complète.

---

## 📄 Licence

TérangaOS est un logiciel libre distribué sous **GNU General Public License v3.0**.

Voir fichier [LICENSE](LICENSE) pour les termes complets. En résumé:
- ✅ Libre d'utilisation, modification, distribution
- ✅ Code source ouvert
- ✅ Doit rester libre et ouvert
- ✅ Même licence pour les dérivés

---

## 🙏 Remerciements

Ce projet se tient sur les épaules de géants:

- **Debian Project** — fondation stable et communautaire
- **Xfce Project** — bureau léger et élégant
- **Kernel Linux** — le cœur de tout
- **Des milliers de projets FOSS** — rendant cela possible
- **DINUM (France)** — inspiration de LaSuite Numérique
- **Communauté tech africaine** — pour croire en souveraineté numérique
- **Vous** — d'être ici

---

## Impliquez-vous

1. **Essayez-le** — Buildez depuis les sources et testez
2. **Signalez problèmes** — Aidez à améliorer qualité
3. **Contribuez code** — Écrivez features, corrigez bugs
4. **Améliorez docs** — Aidez autres utilisateurs
5. **Traduisez** — Ajoutez langues africaines
6. **Parlez-en** — Dites aux autres sur TérangaOS

---

<p align="center">
  <strong>🇸🇳 Ndank ndank mooy jàpp golo ci ñaay</strong><br>
  <em>"Petit à petit, on attrape le singe dans la brousse"</em><br>
  <em>"Little by little, we catch the monkey in the bush"</em><br>
  <em>— Proverbe sénégalais sur la persévérance et le progrès</em>
</p>

<p align="center">
  <strong>🇸🇳 Souveraineté numérique pour l'Afrique</strong> 🌍<br>
  Fait avec ❤️ à Dakar, Sénégal • Pour l'Afrique et le Monde
</p>

<p align="center">
  <a href="https://github.com/MdialloC19/teranga-os">GitHub</a> •
  <a href="CONTRIBUTING.md">Contribuer</a> •
  <a href="docs/INSTALLATION.md">Installer</a> •
  <a href="https://matrix.to/#/#teranga-os:matrix.org">Chat</a>
</p>

---

**Dernière mise à jour:** Avril 2026 | **État:** Alpha | **Maintenu par:** Communauté TérangaOS
