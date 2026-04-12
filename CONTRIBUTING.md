# 🤝 Guide de Contribution — TérangaOS

Merci de votre intérêt pour TérangaOS ! Ce guide vous aidera à contribuer efficacement au projet.

## 📋 Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Signaler un bug](#-signaler-un-bug)
- [Proposer une fonctionnalité](#-proposer-une-fonctionnalité)
- [Soumettre du code](#-soumettre-du-code)
- [Traduction](#-traduction)
- [Standards de code](#standards-de-code)
- [Processus de review](#processus-de-review)

## Code de conduite

En participant à ce projet, vous acceptez notre [Code de conduite](CODE_OF_CONDUCT.md). TérangaOS est un espace inclusif et bienveillant.

## Comment contribuer

### 🐛 Signaler un bug

1. Vérifiez que le bug n'a pas déjà été signalé dans les [Issues](https://github.com/mdialloc19/teranga-os/issues)
2. Créez une nouvelle issue en utilisant le template "Bug Report"
3. Incluez :
   - Version de TérangaOS
   - Matériel (CPU, RAM, GPU)
   - Étapes pour reproduire le bug
   - Comportement attendu vs obtenu
   - Screenshots si pertinent

### 💡 Proposer une fonctionnalité

1. Ouvrez une issue avec le template "Feature Request"
2. Décrivez clairement :
   - Le problème que ça résout
   - La solution proposée
   - Les alternatives considérées

### 🔧 Soumettre du code

#### Première contribution

1. **Fork** le dépôt
2. **Clone** votre fork :
   ```bash
   git clone https://github.com/VOTRE-USERNAME/teranga-os.git
   cd teranga-os
   ```
3. Créez une **branche** :
   ```bash
   git checkout -b feature/ma-fonctionnalite
   # ou
   git checkout -b fix/correction-bug
   ```
4. Faites vos modifications
5. **Testez** :
   ```bash
   make test
   ```
6. **Committez** (messages en français ou anglais) :
   ```bash
   git commit -m "feat: ajout du support Wolof dans le clavier"
   # ou
   git commit -m "fix: correction de l'affichage du menu démarrer"
   ```
7. **Push** et créez une **Pull Request**

#### Convention de commits

Nous utilisons [Conventional Commits](https://www.conventionalcommits.org/) :

| Préfixe | Usage |
|---------|-------|
| `feat:` | Nouvelle fonctionnalité |
| `fix:` | Correction de bug |
| `docs:` | Documentation uniquement |
| `style:` | Thèmes, CSS, apparence |
| `security:` | Corrections de sécurité |
| `perf:` | Optimisation de performance |
| `test:` | Tests |
| `build:` | Système de build, CI/CD |
| `i18n:` | Traduction, internationalisation |

### 🌍 Traduction

La traduction est une contribution **très précieuse** ! Nous avons besoin de traducteurs dans :

| Langue | Code | Statut |
|--------|------|--------|
| Français | `fr` | ✅ Complet |
| Wolof | `wo` | 🔧 En cours |
| Pulaar | `ff` | ❌ Besoin d'aide |
| Serer | `srr` | ❌ Besoin d'aide |
| Diola | `dyo` | ❌ Besoin d'aide |
| Mandinka | `mnk` | ❌ Besoin d'aide |
| Anglais | `en` | 🔧 En cours |
| Portugais | `pt` | ❌ Besoin d'aide |
| Bambara | `bm` | ❌ Besoin d'aide |
| Arabe | `ar` | ❌ Besoin d'aide |

Pour contribuer à la traduction :
1. Allez dans `i18n/`
2. Copiez le fichier `fr.po` comme base
3. Traduisez les chaînes
4. Soumettez une PR

## Standards de code

### Scripts Shell (Bash)

```bash
#!/bin/bash
# Description du script
# Auteur: Prénom Nom
# Date: YYYY-MM-DD

set -euo pipefail  # Toujours utiliser le mode strict

# Variables en MAJUSCULES
readonly BUILD_DIR="/tmp/teranga-build"

# Fonctions en snake_case
build_iso() {
    local edition="${1:?Edition requise}"
    echo "[INFO] Construction de l'édition ${edition}..."
}
```

### Configuration (YAML, TOML, INI)

- Toujours commenter les options
- Utiliser des valeurs par défaut sécurisées
- Documenter les alternatives

### Documentation

- Écrire en **français** (langue principale du projet)
- Traduction anglaise souhaitée pour la doc technique
- Utiliser Markdown
- Inclure des exemples

## Processus de review

1. Chaque PR nécessite **au moins 1 review**
2. Les PRs de sécurité nécessitent **2 reviews**
3. Les CI checks doivent passer (lint, build test)
4. Le mainteneur merge après approbation

## 🏗️ Architecture des branches

```
main              ← Version stable
├── develop       ← Développement actif
├── feature/*     ← Nouvelles fonctionnalités
├── fix/*         ← Corrections de bugs
├── release/*     ← Préparation de release
└── hotfix/*      ← Corrections urgentes
```

## ❓ Questions ?

- 💬 Rejoignez `#teranga-os:matrix.org` sur Matrix/Element
- 📧 Écrivez à `contrib@teranga-os.org`

---

**Merci de contribuer à la souveraineté numérique africaine !** 🇸🇳🌍
