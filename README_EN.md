<p align="center">
  <img src="assets/branding/logo-banner.png" alt="TérangaOS Logo" width="600">
</p>

<h1 align="center">🇸🇳 TérangaOS</h1>

<p align="center">
  <strong>A sovereign Linux distribution for Africa</strong><br>
  Based on Debian • Windows-like interface • Security-first • 100% Open Source
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg" alt="License: GPL v3"></a>
  <a href="#"><img src="https://img.shields.io/badge/Base-Debian%2012-red.svg" alt="Base: Debian 12"></a>
  <a href="#"><img src="https://img.shields.io/badge/Desktop-Xfce%204-blue.svg" alt="Desktop: Xfce"></a>
  <a href="#"><img src="https://img.shields.io/badge/Status-Alpha-orange.svg" alt="Status: Alpha"></a>
  <a href="CONTRIBUTING.md"><img src="https://img.shields.io/badge/PRs-Welcome-brightgreen.svg" alt="PRs Welcome"></a>
  <a href="https://github.com/MdialloC19/teranga-os/actions"><img src="https://github.com/MdialloC19/teranga-os/actions/workflows/ci.yml/badge.svg" alt="CI/CD"></a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#features">Features</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#requirements">Requirements</a> •
  <a href="#documentation">Documentation</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#community">Community</a>
</p>

<p align="center">
  🇬🇧 <strong>English</strong> | 🇫🇷 <a href="README_FR.md"><strong>Français</strong></a>
</p>

---

## About

**TérangaOS** is a sovereign Linux distribution designed for African governments, enterprises, and citizens. It provides a familiar Windows-like interface on top of Debian stable, with security-first design and zero licensing costs.

> *"Teranga"* means **hospitality** in Wolof. Our OS welcomes everyone — beginners to experts.

### Why TérangaOS?

| Challenge | TérangaOS Solution |
|-----------|-------------------|
| **Tech dependency** | 100% open source, fully auditable |
| **High licensing costs** | Free forever, zero vendor lock-in |
| **User adoption barriers** | Familiar Windows-like interface |
| **Not optimized for Africa** | Works with low bandwidth, old hardware, African languages |
| **Security concerns** | Full disk encryption + hardening by default |

---

## Features

### 🖥️ Familiar Interface
- **Xfce 4** desktop with Windows 11-style theme (Fluent Dark)
- Start menu, taskbar, window snapping — exactly like Windows
- **No terminal required** for daily use
- Wallpapers featuring Senegal/African scenes
- Available in 8+ African languages

### 📦 Complete Software Suite
- **LibreOffice** — Replace Microsoft Office
- **Firefox ESR** (hardened) — Secure web browsing
- **Thunderbird** — Email client
- **VLC** — Multimedia player
- **GIMP** — Image editing
- **Nextcloud Desktop** — File sync & cloud storage
- **Jitsi Meet** — Video conferencing
- **Element (Matrix)** — Encrypted messaging

### 🔒 Security by Default
- **Full disk encryption** (LUKS) mandatory
- **Mandatory Access Control** (AppArmor, enforce mode)
- **Firewall enabled** by default (UFW)
- **Automatic security updates**
- **Zero telemetry** — your data stays yours
- **Anti-malware** (ClamAV)
- **Kernel hardening** with CVE mitigations
- **Compliance-ready** (ANSSI certification path)

### 🌐 Built for Africa
- **Languages:** French, Wolof, Pulaar, Serer, Diola, Mandinka, English, Portuguese
- **Low bandwidth optimized** — designed for 3G/4G networks
- **Works offline** — designed to work without internet
- **Resilient** — designed for frequent power interruptions
- **Lightweight:** Runs on 512 MB RAM minimum
- **Currently tested on:** Raspberry Pi 5 with Debian 12

### 🏢 Enterprise Ready
- **FreeIPA integration** — free Active Directory replacement
- **Keycloak SSO** — OIDC/SAML authentication
- **Ansible automation** — centralized management
- **SIEM integration** — Wazuh monitoring
- **GLPI inventory** — hardware tracking
- **ANSSI compliance path** — government requirements

---

## Current Status

| Aspect | Status |
|--------|--------|
| **Phase** | Alpha (early development) |
| **Repository Size** | ~50 MB |
| **Code** | .??? lines |
| **Contributors** | ?? active |
| **Hardware Tested** | 1: Raspberry Pi 5 (ARM64) |
| **OS Tested** | Debian 12 (Bookworm) |
| **Build Status** | ✅ Builds successfully on Debian 12 |
| **Production Ready** | ❌ Still in development |

---

## Quick Start

### For Testing (Build from Source)

Prerequisites: **Debian 12 verified** • Ubuntu 22.04+ (code compatible only, not tested)

```bash
# Install build tools
sudo apt update
sudo apt install -y live-build debootstrap git make coreutils

# Clone repository
git clone https://github.com/MdialloC19/teranga-os.git
cd teranga-os

# Build Desktop edition
sudo make desktop

# Build Lightweight edition
sudo make leger

# Build Server edition
sudo make server
```

ISO will be generated in `build/output/`

### Test with QEMU

```bash
make test-qemu
```

### Download Pre-built ISO

> Pre-built ISOs coming soon in releases page

---

## Requirements

### Minimum (Lightweight Edition)
- 64-bit CPU
- 512 MB RAM
- 20 GB storage

### Recommended (Desktop Edition)
- Multi-core 2+ GHz CPU
- 2 GB RAM
- 40 GB storage

### Currently Tested
- ✅ Raspberry Pi 5 (ARM64) with Debian 12

### Not Yet Tested (Planned)
- ❌ Intel x86_64 hardware
- ❌ AMD x86_64 hardware
- ❌ Old laptops (ThinkPad, Dell)
- ❌ Ubuntu 22.04+ (code compatibility only)

---

## Documentation

| Document | Purpose |
|----------|---------|
| [Architecture](docs/ARCHITECTURE.md) | Technical deep-dive |
| [Installation Guide](docs/INSTALLATION.md) | Step-by-step install |
| [User Guide](docs/USER_GUIDE.md) | Daily usage guide |
| [Admin Guide](docs/ADMIN_GUIDE.md) | Enterprise deployment |
| [Security Guide](docs/SECURITY.md) | Hardening & policies |
| [FAQ](docs/FAQ.md) | Common questions |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Problem solving |

---

## Contributing

**All contributions welcome!** Whether you're a beginner or expert, we need you.

### How to Contribute

- 🐛 **Report bugs:** [Open an issue](https://github.com/MdialloC19/teranga-os/issues)
- 💡 **Request features:** [Feature request](https://github.com/MdialloC19/teranga-os/issues/new)
- 🔧 **Write code:** See [CONTRIBUTING.md](CONTRIBUTING.md)
- 🌍 **Translate:** Help with [translations](docs/TRANSLATION.md)
- 📝 **Improve docs:** Documentation always needs help
- 🧪 **Test:** Try on different hardware and report results

### Areas We Need Help

| Area | Skills | Effort |
|------|--------|--------|
| Debian packaging | dpkg, apt, live-build | Medium |
| UI/UX design | CSS, GTK, Design | Medium |
| Translations | Wolof, Pulaar, Serer, etc. | Low |
| Security audit | CVE audit, hardening | High |
| Documentation | Technical writing | Low |
| Testing | QA, hardware testing | Low |
| Infrastructure | Ansible, Docker, CI/CD | Medium |

### Code of Conduct

We're committed to an inclusive community. Please read our [Code of Conduct](CODE_OF_CONDUCT.md).

### Getting Started as a Contributor

1. **Fork** the repository
2. **Create** a branch: `git checkout -b feature/my-feature`
3. **Make changes** and test locally: `make test`
4. **Commit** with clear messages: `git commit -m "feat: add my feature"`
5. **Push** and create a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## Project Structure

```
teranga-os/
├── config/                   # Build configuration
│   ├── editions.json         # Edition definitions
│   ├── package-lists/        # Packages per edition
│   ├── includes.chroot/      # Files to include in ISO
│   ├── hooks/                # Post-install scripts
│   └── preseed/              # Unattended install config
├── branding/                 # Visual identity
│   ├── logos/                # TérangaOS branding
│   ├── wallpapers/           # Desktop backgrounds
│   ├── icons/                # Icon themes
│   └── kde-theme/            # Desktop theme
├── security/                 # Security configurations
│   ├── apparmor/             # AppArmor profiles
│   ├── firewall/             # UFW rules
│   └── hardening/            # Hardening scripts
├── src/                      # Source code
│   ├── lib/                  # Shared libraries
│   └── mods/                 # Build modules (12+)
├── scripts/                  # Utility scripts
├── tests/                    # Automated tests
├── docs/                     # Documentation
├── Makefile                  # Build commands
├── LICENSE                   # GPLv3
└── README.md                 # Main README (bilingual hub)
```

---

## Roadmap

### Current (Alpha)
- [x] Architecture & foundation
- [x] Base modules (12 components)
- [x] Security hardening
- [x] RPi5 prototype boots
- [ ] Complete Fluent theme
- [ ] ISO build pipeline
- [ ] Test suite (50+ tests)

### Next Phase
- [ ] GUI installer (zero terminal)
- [ ] Wine for legacy Windows apps
- [ ] Performance benchmarks
- [ ] Desktop ISO stable
- [ ] Government pilot

### Future
- [ ] Server & lightweight editions
- [ ] Mesh networking
- [ ] Local AI (Ollama)
- [ ] Production v1.0 LTS
- [ ] Mass deployment support

---

## Community

| Channel | Link |
|---------|------|
| **Chat** | [Matrix: #teranga-os:matrix.org](https://matrix.org) |
| **Issues** | [GitHub Issues](https://github.com/MdialloC19/teranga-os/issues) |
| **Discussions** | [GitHub Discussions](https://github.com/MdialloC19/teranga-os/discussions) |
| **Email** | contact@teranga-os.org |

### Communication Guidelines
- Be respectful and inclusive
- Use French, English, or Wolof
- Search before asking (avoid duplicates)
- Be specific in issues/questions

---

## Security

Found a security vulnerability? **Do not open a public issue.**

Email: security@teranga-os.org with:
- Vulnerability details
- Steps to reproduce
- Potential impact

See [SECURITY.md](SECURITY.md) for full policy.

---

## License

TérangaOS is free software distributed under **GNU General Public License v3.0**.

See [LICENSE](LICENSE) file for complete terms. In short:
- ✅ Free to use, modify, distribute
- ✅ Source code open
- ✅ Must remain free and open
- ✅ Same license for derivatives

---

## Acknowledgments

This project stands on the shoulders of giants:

- **Debian Project** — stable, community-driven foundation
- **Xfce Project** — lightweight, elegant desktop
- **Linux Kernel** — the core of everything
- **Thousands of FOSS projects** — making this possible
- **DINUM (France)** — inspiration from LaSuite Numérique
- **African tech community** — for believing in digital sovereignty
- **You** — for being here

---

## Get Involved

1. **Try it** — Build from source and test
2. **Report issues** — Help improve quality
3. **Contribute code** — Write features, fix bugs
4. **Improve docs** — Help other users
5. **Translate** — Add African languages
6. **Spread the word** — Tell others about TérangaOS

---

<p align="center">
  <strong>🇸🇳 Ndank ndank mooy jàpp golo ci ñaay</strong><br>
  <em>"Little by little, we catch the monkey in the bush"</em><br>
  <em>"Petit à petit, on attrape le singe dans la brousse"</em><br>
  <em>— Senegalese proverb about perseverance and progress</em>
</p>

<p align="center">
  <strong>🇸🇳 Digital Sovereignty for Africa</strong> 🌍<br>
  Made with ❤️ in Dakar, Senegal • For Africa and the World
</p>

<p align="center">
  <a href="https://github.com/MdialloC19/teranga-os">GitHub</a> •
  <a href="CONTRIBUTING.md">Contribute</a> •
  <a href="docs/INSTALLATION.md">Install</a> •
  <a href="https://matrix.to/#/#teranga-os:matrix.org">Chat</a>
</p>

---

**Last updated:** April 2026 | **Status:** Alpha | **Maintained by:** TérangaOS Community
