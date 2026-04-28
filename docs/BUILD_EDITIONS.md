# 📦 Building TérangaOS Editions

This document explains the multi-edition build system, how each edition is customized, and how to build them.

---

## 🎯 Why Multiple Editions?

TérangaOS supports **4 editions** optimized for different hardware and use cases:

| Edition | Desktop | RAM | CPU | Use Case |
|---------|---------|-----|-----|----------|
| **Desktop** | KDE Plasma 6 | 2GB+ | x86_64 | Full-featured PC/Laptop with modern UI |
| **RPi** | Xfce 4 | 512MB+ | ARM64 | Raspberry Pi 5 with lightweight UI |
| **Leger** | Xfce 4 | 512MB+ | x86_64 | Legacy/low-resource x86_64 systems |
| **Server** | None (CLI) | 256MB+ | x86_64 | Headless server, command-line only |

---

## 🔧 Build System Architecture

The build system uses **live-build** (Debian's ISO creation framework) with a modular structure:

```
config/
├── editions.json                 # Edition definitions (arch, desktop, packages)
├── preseed/
│   ├── desktop.preseed.cfg       # Desktop edition: KDE + interactive credentials
│   ├── rpi.preseed.cfg           # RPi edition: Xfce + interactive credentials  
│   └── (auto-selected by build script)
├── hooks/
│   ├── common/                   # Applied to ALL editions
│   │   ├── 01-security-hardening.hook.chroot
│   │   └── 02-branding.hook.chroot
│   ├── desktop/                  # Desktop edition only
│   │   └── 03-kde-windows-theme.hook.chroot
│   └── rpi/                      # RPi, Leger, Server editions
│       └── 03-xfce-windows-theme.hook.chroot
└── package-lists/
    ├── desktop.list.chroot       # KDE Plasma packages
    ├── rpi.list.chroot           # Xfce packages (RPi/Leger/Server use this)
    └── ...
```

### Key Components

1. **editions.json** — Edition metadata (arch, desktop env, packages, hostname)
2. **Preseed files** — Automated installer configuration (credentials, partitioning, locale)
3. **Hooks** — Bash scripts executed during build (branding, theme, security)
4. **Package lists** — Package selections per edition

---

## 📋 Edition Definitions (editions.json)

### Example: Desktop Edition

```json
{
  "edition": "desktop",
  "name": "TérangaOS Desktop",
  "description": "Desktop Edition — KDE Plasma 6 for x86_64 PC (2GB+ RAM, full-featured)",
  "base": "debian",
  "codename": "bookworm",
  "arch": "amd64",
  "desktop": "kde-plasma",
  "theme": "Fluent-Dark",
  "icons": "Fluent",
  "font": "Inter 11",
  "lang": "fr_FR.UTF-8",
  "timezone": "Africa/Dakar",
  "keyboard": "fr",
  "hostname": "terangaos",
  "packages_extra": ["libreoffice", "thunderbird", "firefox-esr", "vlc"],
  "target_device": "x86_64-pc",
  "output_name": "terangaos-0.1-desktop-amd64"
}
```

**Key fields:**
- `edition` — Build script uses this to select preseed, hooks, and packages
- `arch` — Target architecture: `amd64` (x86_64) or `arm64` (ARM)
- `desktop` — Desktop environment: `kde-plasma`, `xfce`, or `none`
- `hostname` — Machine name after install

---

## 🔐 Preseed Configuration

### What is Preseed?

Preseed is Debian's automated installer configuration. It:
- Automates partitioning, software selection, and basic setup
- **Requests user credentials interactively** (username/password)
- Provides fallback credentials if interactive setup fails
- Prevents installation hangs on attended systems

### Interactive User Setup (Fixed Issue #10)

**Problem (Before PR #18):**
- Preseed had hardcoded username: `user`
- No mechanism to collect custom credentials
- Installation would hang on systems expecting interactive input

**Solution (After PR #18):**
```bash
# Request user credentials during installation
d-i passwd/make-user boolean true

# Allow weak passwords for lab/testing environments
d-i user-setup/allow-password-weak boolean true

# Fallback credentials (if interactive setup fails)
# Username: teranga
# Password: teranga123
```

**Important:** These credentials are **independent of the desktop environment**. The same preseed works for both KDE (desktop) and Xfce (RPi) because we separated:
1. **Credentials system** (login/user management) ← handled by preseed
2. **UI selection** (desktop environment) ← handled by package lists & hooks

### Desktop Edition Preseed

File: `config/preseed/desktop.preseed.cfg`

```bash
# Locale & Timezone
d-i debian-installer/locale string fr_FR.UTF-8
d-i debian-installer/keymap select fr

# Partitioning
d-i partman-auto/method string lvm
d-i partman-lvm/confirm boolean true
d-i partman-auto-lvm/guided_size string max

# User credentials (INTERACTIVE)
d-i passwd/make-user boolean true
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

# Security updates
unattended-upgrades unattended-upgrades/enable_auto_updates boolean true

# Desktop environment: KDE Plasma
tasksel tasksel/first multiselect kde-desktop, french

# Bootloader (x86_64 uses GRUB, not U-Boot)
d-i grub-installer/only_debian boolean true
```

### RPi Edition Preseed

File: `config/preseed/rpi.preseed.cfg`

```bash
# Same credentials setup as desktop
d-i passwd/make-user boolean true
d-i user-setup/allow-password-weak boolean true

# Hostname differs
d-i netcfg/get_hostname string terangaos-rpi

# Desktop environment: Xfce (lightweight)
tasksel tasksel/first multiselect xfce-desktop, french

# RPi bootloader (U-Boot, not GRUB)
d-i grub-installer/skip boolean true

# Rest is same as desktop...
```

---

## 🎨 Hooks: Branding & Customization

Hooks are bash scripts executed **during the build** to customize the ISO.

### Common Hooks (All Editions)

#### 1. Security Hardening (`config/hooks/common/01-security-hardening.hook.chroot`)

Applied to **every edition**. Includes:

```bash
# Firewall
ufw default deny incoming
ufw allow ssh

# AppArmor
aa-enforce /etc/apparmor.d/*

# Kernel hardening
sysctl -w kernel.randomize_va_space=2           # ASLR
sysctl -w net.ipv4.tcp_syncookies=1              # SYN cookies
sysctl -w net.ipv4.conf.all.forwarding=0         # Disable IP forwarding
sysctl -w kernel.printk="3 3 3 3"                # Restrict dmesg

# Automatic security updates
unattended-upgrades
```

#### 2. Branding (`config/hooks/common/02-branding.hook.chroot`)

Applied to **every edition**. Includes:

```bash
# /etc/os-release
NAME="TérangaOS"
PRETTY_NAME="TérangaOS 0.1 (Dakar)"

# MOTD banner with Senegal flag
🇸🇳 TérangaOS 🇸🇳
Authorized access only

# Branding directories
/usr/share/terangaos/wallpapers/
/usr/share/terangaos/branding/
```

### Desktop-Specific Hooks

#### 3a. KDE Theme (`config/hooks/desktop/03-kde-windows-theme.hook.chroot`)

Applied **only for Desktop edition**. Configures **KDE Plasma 6** for Windows 11-style appearance:

**Panel Configuration (Bottom, Windows-like):**
- Location: Bottom of screen, 48px height
- Widgets: Kickoff menu (start), Tasklist (open windows), System tray, Clock
- Alignment: Left-aligned (Windows style)
- Shows open applications with thumbnails

**Color Scheme (Fluent Dark):**
- Colors: Grays (#1e1e2e to #e4e4e7) with Windows 11 blue accent (#0078d4)
- Theme: Breeze Dark (built-in KDE theme)
- Consistency with login screen and system apps

**Window Management (Windows 11-compatible):**
- Button layout: Close, Minimize, Maximize on RIGHT side (like Windows)
- Double-click behavior (not single-click)
- Focus follows click
- Window placement: Smart

**Typography:**
- Font: Inter 11pt (elegant, readable, similar to Windows)
- Menu font: Inter 11pt
- Fixed-width: Noto Mono 10pt

**Icon Theme:**
- Theme: Fluent (Windows-style icons)
- Consistent with login screen

**Applications Configuration:**
- Dolphin (file manager): Windows Explorer-like layout
- LibreOffice: Tabbed/Ribbon UI mode
- Firefox: DuckDuckGo search, privacy-first, tracking protection
- Shortcuts: Win+D to show desktop, Meta+Tab for activities

**Wallpaper:**
- Default: `/usr/share/backgrounds/terangaos/dakar-sunset.png`
- Shows on desktop and during login

#### 3b. SDDM Login Screen (`config/hooks/desktop/04-sddm-theme.hook.chroot`)

Applied **only for Desktop edition**. Configures the login screen with:

**Login Screen Appearance:**
- Background: Dakar sunset wallpaper (same as desktop)
- Theme: Breeze (KDE's default dark theme)
- Font: Inter 11pt
- Colors: Fluent Dark (consistent with desktop)

**Features:**
- Displays wallpaper behind login form
- Cursor theme: Adwaita (smooth, modern)
- Language: French (fr_FR)
- Keyboard layout: French (AZERTY)

**How it's installed:**
1. Hook copies wallpaper to `/usr/share/pixmaps/terangaos/`
2. Creates SDDM config at `/etc/sddm.conf.d/terangaos.conf`
3. Sets background image path
4. Configures color scheme
5. Sets font and cursor theme

### Desktop-Specific Hooks

### RPi/Lightweight-Specific Hooks

#### 3b. Xfce Theme (`config/hooks/rpi/03-xfce-windows-theme.hook.chroot`)

Applied **for RPi, Leger, Server editions**. Includes:

```bash
# Xfce4 panel (bottom, 48px)
~/.config/xfce4/xfconf/xfce4-panel.xml
  - ApplicationsMenu (start menu)
  - Tasklist (open windows)
  - SystemTray (clock, volume, etc.)
  - ShowDesktop button

# Window manager theme
~/.config/xfce4/xfwm4.xml
  - Fluent-Dark theme
  - Button layout: C|HMX (close, max, minimize, help)

# Desktop wallpaper
~/.config/xfce4/desktop.xml
  - Path: /usr/share/backgrounds/terangaos/dakar-sunset.png

# File manager (Thunar)
~/.config/Thunar/thunarrc
  - Detailed list view
  - Show full path
```

---

## 📦 Package Lists

### desktop.list.chroot

KDE Plasma desktop + productivity apps:

```bash
task-kde-desktop
kde-plasma-desktop
kde-plasma-nm
kde-plasma-pa
kde-full
konsole
dolphin
okular
gwenview
amarok
libqalculate
libreoffice
thunderbird
firefox-esr
vlc
```

### rpi.list.chroot

Lightweight Xfce desktop (used for **RPi, Leger, Server**):

```bash
task-xfce-desktop
xfce4
xfce4-goodies
xfce4-terminal
xfce4-power-manager
thunar
xfce4-clipman-plugin
xfce4-pulseaudio-plugin
mousepad
```

---

## 🔨 Build Script: How Editions Are Built

File: `scripts/build-edition.sh`

### Key Logic

```bash
# Get edition config from editions.json
get_edition_config() {
  local edition=$1
  jq ".[] | select(.edition==\"$edition\")" config/editions.json
}

# Select preseed based on edition
if [ -f "config/preseed/${edition}.preseed.cfg" ]; then
  cp config/preseed/${edition}.preseed.cfg config/preseed.cfg
else
  cp config/preseed/desktop.preseed.cfg config/preseed.cfg  # fallback
fi

# Copy common hooks to build directory
cp config/hooks/common/*.chroot build/

# Copy desktop-specific or RPi-specific hooks
if [ "$edition" = "desktop" ]; then
  cp config/hooks/desktop/*.chroot build/
else
  cp config/hooks/rpi/*.chroot build/
fi

# Copy appropriate package list
cp config/package-lists/${edition}.list.chroot build/package-list.chroot
```

### Build Commands

```bash
# Desktop edition (KDE Plasma, x86_64)
sudo bash scripts/build-edition.sh --edition desktop

# RPi edition (Xfce, ARM64)
sudo bash scripts/build-edition.sh --edition rpi

# Lightweight edition (Xfce, x86_64)
sudo bash scripts/build-edition.sh --edition leger

# Server edition (CLI only, x86_64)
sudo bash scripts/build-edition.sh --edition server
```

**Output:** `output/terangaos-0.1-<edition>-<arch>.iso`

---

## 🧪 Testing Editions

### Desktop Edition (x86_64)

```bash
# Build
sudo bash scripts/build-edition.sh --edition desktop

# Boot in QEMU
qemu-system-x86_64 \
  -enable-kvm \
  -m 2048 \
  -cdrom output/terangaos-0.1-desktop-amd64.iso

# Verify:
# ✓ KDE Plasma login screen appears
# ✓ Credentials prompt shows
# ✓ After login, KDE desktop with Fluent-Dark theme
```

### RPi Edition (ARM64)

```bash
# Build
sudo bash scripts/build-edition.sh --edition rpi

# Boot on actual RPi 5 (using Raspberry Pi Imager or dd)
sudo dd if=output/terangaos-0.1-rpi-arm64.iso of=/dev/sdX bs=4M status=progress

# Verify:
# ✓ Xfce desktop with Fluent-Dark theme
# ✓ Credentials login works
# ✓ CLI tools accessible (./teranga security)
# ✓ Branding visible (wallpaper, MOTD)
```

---

## 🔍 Troubleshooting

### Problem: Installation hangs waiting for credentials

**Cause:** Preseed missing `d-i passwd/make-user boolean true`

**Fix:** Add to preseed file:
```bash
d-i passwd/make-user boolean true
d-i user-setup/allow-password-weak boolean true
```

### Problem: Wrong desktop environment in built ISO

**Cause:** Edition definition in `editions.json` doesn't match package list

**Fix:** Verify alignment:
```bash
# Check what desktop is defined
jq '.[] | select(.edition=="desktop") | .desktop' config/editions.json

# Check what packages are in the list
grep "task-" config/package-lists/desktop.list.chroot
```

### Problem: Preseed not loading, default used instead

**Cause:** Preseed file path not found

**Debug:**
```bash
# Check if preseed exists
ls -la config/preseed/${edition}.preseed.cfg

# Look at build script output for which preseed was used
grep -i preseed build.log
```

---

## 🪟 Customizing KDE Plasma for Windows-like Experience

If you want to modify the KDE interface to better resemble Windows, this guide explains the key customization points:

### Configuration Files

KDE Plasma configuration files are stored in `~/.config/`:

| File | Purpose | Windows Equivalent |
|------|---------|-------------------|
| `plasma-org.kde.plasma.desktop-appletsrc` | Panel layout and applets | Taskbar configuration |
| `kdeglobals` | Global colors, fonts, theme | Windows appearance settings |
| `kwinrc` | Window manager (buttons, focus) | Window management settings |
| `dolphinrc` | File manager appearance | Windows Explorer settings |
| `kglobalshortcutsrc` | Keyboard shortcuts | Keyboard shortcuts |

### Key Customizations

**1. Bottom Panel (Taskbar):**
```ini
[Containments][2]
location=4              # 4 = bottom
thickness=48            # height in pixels
plugin=org.kde.panel
```

**2. Panel Widgets (in order):**
- `org.kde.plasma.kickoff` — Start menu
- `org.kde.plasma.icontasks` — Open windows (like Windows taskbar)
- `org.kde.plasma.systemtray` — System tray
- `org.kde.plasma.digitalclock` — Clock

**3. Windows 11 Button Layout:**
```ini
[Windows]
ButtonsOnLeft=          # empty = no buttons on left
ButtonsOnRight=AXC      # A=Maximize, X=Close, C=Minimize on right
```

**4. Color Scheme (Fluent Dark):**
```ini
[ColorScheme]
BackgroundColor=30,30,46             # Dark background
DecorationFocus=0,120,212            # Windows 11 blue
ForegroundColor=228,228,231          # Light text
```

**5. Fonts (Inter for elegance):**
```ini
[General]
font=Inter,11,-1,5,50,0,0,0,0,0
menuFont=Inter,11,-1,5,50,0,0,0,0,0
```

**6. Single-click vs Double-click:**
```ini
[KDE]
SingleClick=false                    # false = double-click to open
```

**7. Wallpaper:**
```ini
[Containments][1][Wallpaper][org.kde.image][General]
Image=file:///usr/share/backgrounds/terangaos/dakar-sunset.png
```

### Where to Make Changes

1. **In Build Hooks** (best for ISO distribution):
   - Edit `config/hooks/desktop/03-kde-windows-theme.hook.chroot`
   - Configuration files are written to `/etc/skel/.config/`
   - Affects all new user accounts created after installation

2. **On Live System** (for testing):
   - Edit `~/.config/plasma-org.kde.plasma.desktop-appletsrc`
   - Changes apply immediately
   - Good for iterating before adding to hook

3. **System-wide** (for all users):
   - Edit `/etc/skel/.config/` files
   - Affects new user accounts
   - Use in build hooks for distribution

### Testing Changes

After modifying the hook:

```bash
# Rebuild the ISO
sudo bash scripts/build-edition.sh --edition desktop

# Boot and login
# - New user accounts will get the updated configuration
# - Existing users keep their current settings
```

If testing manually on a live system:

```bash
# Edit config file
nano ~/.config/kdeglobals

# Restart Plasma (some changes need it)
kquitapp5 plasmashell && kstart5 plasmashell &

# Or logout and login for full restart
```

### Advanced: Icon Theme & Cursors

**Install custom icon theme:**
```bash
# In hook script:
cp -r /root/terangaos/assets/branding/icons/Fluent \
   /usr/share/icons/Fluent
```

**Set in kdeglobals:**
```ini
[Icons]
Theme=Fluent
```

**Cursor theme:**
```ini
[General]
cursorTheme=Adwaita
cursorSize=24
```

### Advanced: Panel Height & Margins

```ini
[Containments][2]
screenEdgeMargin=0          # distance from screen edge (0 = none)
thickness=48                # panel height in pixels
```

Reduce thickness to 40 for compact, or increase to 56 for spacious.

---



- [scripts/build-edition.sh](../scripts/build-edition.sh) — Build orchestration
- [config/editions.json](../config/editions.json) — Edition definitions
- [config/preseed/](../config/preseed/) — Preseed files
- [config/hooks/](../config/hooks/) — Customization scripts
- [config/package-lists/](../config/package-lists/) — Package selections

---

## 🔗 References

- [Debian Live-Build Documentation](https://live-team.pages.debian.net/live-manual/)
- [Debian Preseed Documentation](https://www.debian.org/releases/bookworm/amd64/preseed/)
- [KDE Plasma Configuration](https://userbase.kde.org/)
- [Xfce Configuration](https://docs.xfce.org/)

---

**Last updated:** April 2026  
**Status:** Alpha  
**Maintainer:** TérangaOS Community
