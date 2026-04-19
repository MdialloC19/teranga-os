<p align="center">
  <img src="assets/branding/logo-banner.png" alt="TérangaOS Logo" width="600">
</p>

<h1 align="center">🇸🇳 TérangaOS</h1>

<p align="center">
  <strong>Distribution Linux souveraine pour l'Afrique</strong><br>
  Basée sur Debian • Interface Windows-like • Sécurisée • Open Source
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg" alt="License: GPL v3"></a>
  <a href="#"><img src="https://img.shields.io/badge/Base-Debian%2012-red.svg" alt="Base: Debian 12"></a>
  <a href="#"><img src="https://img.shields.io/badge/Desktop-Xfce%204-blue.svg" alt="Desktop: Xfce"></a>
  <a href="#"><img src="https://img.shields.io/badge/Status-Alpha-orange.svg" alt="Status: Alpha"></a>
  <a href="CONTRIBUTING.md"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome"></a>
  <a href="https://github.com/MdialloC19/teranga-os/actions"><img src="https://github.com/MdialloC19/teranga-os/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

<p align="center">
  <a href="#-fonctionnalités">Fonctionnalités</a> •
  <a href="#-téléchargement">Téléchargement</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-contribuer">Contribuer</a> •
  <a href="#-documentation">Documentation</a> •
  <a href="#-communauté">Communauté</a>
</p>

---

## 🌍 Qu'est-ce que TérangaOS ?

**TérangaOS** est une distribution Linux souveraine conçue pour les administrations, les entreprises et les citoyens africains. Basée sur **Debian Stable** avec un bureau **KDE Plasma 6** thémé pour ressembler à Windows, elle permet une transition en douceur depuis les systèmes propriétaires.

> *"Teranga"* signifie **hospitalité** en wolof. Notre OS accueille tout le monde — des débutants aux experts.

### Pourquoi TérangaOS ?

| Problème | Solution TérangaOS |
|----------|-------------------|
| Dépendance aux GAFAM | 100% open source, aucune télémétrie |
| Licences coûteuses (Windows + Office) | Gratuit. Pour toujours. |
| Agents dépaysés par Linux | Interface quasi identique à Windows 11 |
| Pas adapté à l'Afrique | Optimisé basse connectivité, vieux matériel, langues locales |
| Sécurité incertaine | Chiffrement intégré, sécurité durcie par défaut |

## ✨ Fonctionnalités

### 🖥️ Interface familière
- Bureau **KDE Plasma 6** thémé comme Windows 11
- Menu Démarrer, barre des tâches centrée, snap de fenêtres
- **Aucun terminal nécessaire** pour l'utilisation quotidienne

### 📦 Suite logicielle complète
- **LibreOffice** (interface ruban) — remplace Microsoft Office
- **Firefox ESR** (durci) — navigation web sécurisée
- **Thunderbird** — email
- **Element** (Matrix) — messagerie chiffrée
- **Jitsi Meet** — visioconférence
- **Nextcloud Desktop** — synchronisation de fichiers
- **VLC** — multimédia

### 🔒 Sécurité par défaut
- Chiffrement disque complet (LUKS)
- Contrôle d'accès (AppArmor)
- Firewall activé par défaut (UFW)
- Mises à jour de sécurité automatiques
- Zéro télémétrie — vos données restent les vôtres

### 🌐 Adapté à l'Afrique
- Langues : Français, Wolof, Pulaar, Serer, Diola, Mandinka, Anglais, Portugais
- Optimisé pour le matériel modeste (fonctionne avec 2 Go de RAM)
- Mode économie de bande passante
- Résilient aux coupures de courant (journalisation ext4)

### 🏢 Prêt pour l'entreprise / le gouvernement
- Intégration FreeIPA (Active Directory libre)
- SSO via Keycloak (OIDC/SAML)
- Gestion centralisée via Ansible
- Monitoring via Wazuh (SIEM)
- Inventaire parc via GLPI

## 📥 Téléchargement

> ⚠️ TérangaOS est en phase **Alpha**. Pour les tests uniquement.

| Édition | Description | RAM min | Télécharger |
|---------|-------------|---------|-------------|
| **Desktop** | Postes standards (KDE Plasma 6) | 2 Go | _Bientôt_ |
| **Léger** | Vieux matériel (Xfce 4.18) | 512 Mo | _Bientôt_ |
| **Server** | Serveurs (CLI uniquement) | 512 Mo | _Bientôt_ |
| **Kiosk** | Bornes d'accès public | 1 Go | _Bientôt_ |

## 🛠️ Construire depuis les sources

### Prérequis

```bash
# Debian 12 / Ubuntu 22.04+ requis pour le build
sudo apt update
sudo apt install -y \
  live-build \
  debootstrap \
  git \
  make \
  coreutils
```

### Build

```bash
# Cloner le dépôt
git clone https://github.com/mdialloc19/teranga-os.git
cd teranga-os

# Construire l'édition Desktop (KDE Plasma)
make desktop

# Construire l'édition Léger (Xfce)
make leger

# Construire l'édition Server
make server
```

L'ISO sera générée dans `build/output/`.

### Tester avec QEMU

```bash
# Lancer l'ISO dans une VM
make test-qemu
```

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [Architecture](docs/architecture.md) | Architecture technique complète |
| [Guide utilisateur](docs/user-guide.md) | Guide pour les utilisateurs finaux |
| [Guide administrateur](docs/admin-guide.md) | Déploiement et gestion du parc |
| [Guide de sécurité](docs/security.md) | Politiques de sécurité et durcissement |
| [Personnalisation](docs/customization.md) | Créer votre propre variante |
| [FAQ](docs/faq.md) | Questions fréquentes |

## 🤝 Contribuer

TérangaOS est un projet communautaire. **Toute contribution est la bienvenue !**

- 🐛 [Signaler un bug](https://github.com/mdialloc19/teranga-os/issues)
- 💡 [Proposer une fonctionnalité](https://github.com/mdialloc19/teranga-os/issues)
- 🔧 [Soumettre un Pull Request](CONTRIBUTING.md)
- 🌍 [Aider à la traduction](docs/translation.md)
- 📝 [Améliorer la documentation](docs/)

Lisez notre [Guide de contribution](CONTRIBUTING.md) et notre [Code de conduite](CODE_OF_CONDUCT.md) avant de commencer.

### Domaines où nous avons besoin d'aide

| Domaine | Compétences |
|---------|-------------|
| 🐧 Packaging Debian | dpkg, apt, live-build |
| 🎨 Thèmes & UX | CSS, Qt/QML, design |
| 🌍 Traduction | Wolof, Pulaar, Serer, Bambara, etc. |
| 🔒 Sécurité | Audit, pentest, hardening |
| 📝 Documentation | Rédaction technique, tutoriels |
| 🧪 Test | QA, tests sur différent matériel |
| 🏗️ Infrastructure | Ansible, Kubernetes, CI/CD |

## 🏗️ Structure du projet

```
teranga-os/
├── config/                 # Configuration live-build
│   ├── package-lists/      # Listes de paquets par édition
│   ├── includes.chroot/    # Fichiers inclus dans l'ISO
│   ├── hooks/              # Scripts post-installation
│   └── preseed/            # Réponses automatiques d'installation
├── branding/               # Thèmes, wallpapers, logos
│   ├── kde-theme/          # Thème KDE Plasma
│   ├── wallpapers/         # Fonds d'écran
│   ├── sddm-theme/        # Thème écran connexion
│   └── icons/              # Icônes custom
├── security/               # Configurations sécurité
│   ├── apparmor/           # Profils AppArmor
│   ├── firewall/           # Règles UFW
│   └── hardening/          # Scripts de durcissement
├── scripts/                # Scripts utilitaires
│   ├── build.sh            # Script de build principal
│   ├── test.sh             # Tests automatisés
│   └── deploy.sh           # Déploiement
├── docs/                   # Documentation
├── tests/                  # Tests automatisés
├── Makefile                # Commandes de build
├── LICENSE                 # GPLv3
├── README.md               # Ce fichier
├── CONTRIBUTING.md         # Guide de contribution
├── CODE_OF_CONDUCT.md      # Code de conduite
├── SECURITY.md             # Politique de sécurité
└── CHANGELOG.md            # Journal des changements
```

## 🗺️ Roadmap

- [x] Conception de l'architecture
- [x] Choix de la stack technique
- [ ] ISO Desktop v0.1 (prototype)
- [ ] Thème KDE Windows-like
- [ ] Suite logicielle intégrée
- [ ] Sécurité durcie
- [ ] ISO Léger v0.1
- [ ] Documentation utilisateur
- [ ] Tests communautaires
- [ ] Version Beta
- [ ] Pilote ministère
- [ ] Version 1.0 stable

## 💬 Communauté

| Canal | Lien |
|-------|------|
| 💬 Matrix/Element | `#teranga-os:matrix.org` |
| 🐦 Twitter/X | `@TérangaOS` |
| 📧 Email | `contact@teranga-os.org` |
| 📋 Forum | _Bientôt_ |

## 📄 Licence

TérangaOS est un logiciel libre distribué sous la licence **GNU General Public License v3.0**.

Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- La communauté **Debian** pour leur travail exceptionnel
- Le projet **KDE** pour Plasma Desktop
- La **DINUM** (France) pour l'inspiration via LaSuite
- La **Gendarmerie nationale française** pour le précédent GendBuntu
- Tous les projets open source qui composent cette distribution
- Le peuple sénégalais et la communauté tech africaine 🌍

---

<p align="center">
  <strong>🇸🇳 Ndank ndank mooy jàpp golo ci ñaay</strong><br>
  <em>Petit à petit, on attrape le singe dans la brousse</em>
</p>

<p align="center">
  Fait avec ❤️ au Sénégal
</p>
