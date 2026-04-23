# Contribution Guide — TérangaOS

**Version:** 2.0 (Rigorous Standards)  
**Last Updated:** April 2026  
**Language:** English

---

## Important Policy

**BEFORE contributing, you MUST read:**
1. [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT_EN.md) — Community standards (enforcement, sanctions)
2. [AI_POLICY.md](AI_POLICY_EN.md) — AI usage rules **very important**
3. [SECURITY.md](SECURITY.md) — Security responsibility
4. This file (CONTRIBUTING.md)

**Each PR assumes you have read and understood these documents.**

---

## Table of Contents

- [Important Policy](#important-policy)
- [Code of Conduct](#code-of-conduct)
- [Before Contributing](#before-contributing)
- [Types of Contributions](#types-of-contributions)
- [Contribution Process](#contribution-process)
- [Code Standards](#code-standards)
- [Mandatory Tests](#mandatory-tests)
- [Required Documentation](#required-documentation)
- [Review Process](#review-process)
- [Commit Guidelines](#commit-guidelines)
- [Translation](#translation)

---

## Code of Conduct

By participating in TérangaOS, you accept our [Code of Conduct](CODE_OF_CONDUCT_EN.md).

**Non-negotiable:**
- Respect other contributors
- Remain professional and constructive
- Accept criticism
- Admit your mistakes

**Violation** → Warning → Suspension → Ban (see CODE_OF_CONDUCT.md)

---

## Before Contributing

### Pre-checks

- This is **not already developed** (check branches, PRs, discussions)
- This is **aligned with TérangaOS mission**
- You have **resources to finish**
- Read [AI_POLICY.md](AI_POLICY_EN.md) if using AI

### TérangaOS Mission (important!)

**TérangaOS is:**
- Debian desktop distribution for individuals wanting to leave Windows
- Windows replacement with familiar interface (Windows 11 theme)
- Reclaim control of your data (no Microsoft, no surveillance)
- Localized in African languages (FR, Wolof, Pulaar, etc.)
- Focused on simple office use cases (Email, Browser, Calc, Writer)
- For Africans (priority) but also international users

**TérangaOS is NOT:**
- Server solution (use Debian server)
- Technological innovation (it's Debian + customization)
- For enterprises (it's for individuals)
- Competitor to RedHat/SUSE/Ubuntu (we are niche)

**Orientation question:** "Is this useful for individual (African or international) wanting to leave Windows and control their data?"

## Types of Contributions

### Report a Bug

**You MUST use the Bug Report template. Without template = closed.**

1. Check [existing issues](https://github.com/MdialloC19/teranga-os/issues?q=is%3Aissue+label%3Abug)
2. Create GitHub issue with "Bug Report" template
3. **Include ALL this info (mandatory):**

```markdown
## Version
TérangaOS version: [e.g: 0.2-alpha]

## Environment
- Architecture: ARM64 / AMD64 / other
- Hardware: [e.g: Raspberry Pi 5, ThinkPad X1]
- Edition: desktop / leger / server / rpi

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Logs or Attachments
[dmesg, journalctl, build.log, screenshots]
```

**Without complete info** → Marked "needs-more-info" → Closed after 7 days

### Suggest a Feature

**MANDATORY: Discuss first, code after**

1. Check [existing discussions](https://github.com/MdialloC19/teranga-os/discussions)
2. Open a **Discussion** (not issue)
3. Ask: "Is this aligned with the mission?"
4. Wait for feedback (+3 days)
5. Only after agreement → Code + PR

**Discussion template:**
```markdown
## Problem
[What's happening or missing?]

## Proposed Solution
[How do you solve it?]

## Alternatives
[Other solutions?]

## Beneficiaries
[Who benefits? Why is this priority?]

## Effort
[1h? 1 day? 1 week?]
```

### Submit Code

See **Contribution Process** section below.

---

## Contribution Process (step by step)

### Step 0: Local Setup

```bash
# Clone
git clone https://github.com/MdialloC19/teranga-os.git
cd teranga-os

# Check dependencies
./scripts/check-deps.sh

# Optional pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
make test 2>/dev/null || true
EOF
chmod +x .git/hooks/pre-commit
```

### Step 1: Create a Branch

**MANDATORY naming:**
```bash
# Feature
git checkout -b feature/short-description
# Example: feature/wolof-keyboard-layout

# Bug fix
git checkout -b fix/short-description
# Example: fix/lightdm-crash-arm64

# Documentation
git checkout -b docs/short-description
# Example: docs/installation-guide

# Security
git checkout -b security/short-description
# Example: security/clamav-update

# Translation
git checkout -b i18n/short-description
# Example: i18n/pulaar-translation
```

**NEVER:** `develop`, `main-fix`, `test123`, `fix-stuff`

### Step 2: Modify locally + Test

**MANDATORY tests before PR:**

```bash
# 1. Lint bash
shellcheck src/**/*.sh scripts/*.sh
# Must pass without errors

# 2. Local build
make desktop  # or make rpi, make leger, make server
# Must compile without fatal errors

# 3. Functional tests
make test
# Checklist: Boot OK? Keyboard OK? Language OK? Encryption OK?

# 4. Documentation updated
grep -r "feature-name" *.md
# Verify docs exist

# 5. Final ShellCheck
shellcheck -x src/**/*.sh scripts/*.sh || exit 1
```

**If a test fails → PR rejected. No exceptions.**

### Step 3: Commits with RIGOROUS messages

**MANDATORY format: Conventional Commits**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type (MANDATORY):**
| Type | Usage | Example |
|------|-------|---------|
| `feat` | New feature | `feat(i18n): add Pulaar keyboard`
| `fix` | Bug fix | `fix(lightdm): prevent crash on ARM64`
| `docs` | Documentation | `docs: update installation guide`
| `style` | Theme/CSS/UI | `style(fluent): darker button colors`
| `security` | Security | `security(firewall): restrict SSH port`
| `perf` | Performance | `perf(build): reduce ISO size by 15%`
| `test` | Tests | `test(shell): add validation tests`
| `build` | Build/CI/Deps | `build(github-actions): add ARM64 runner`
| `i18n` | Translation | `i18n(wolof): translate UI strings`
| `refactor` | Refactor | `refactor(build): consolidate functions`
| `revert` | Cancel commit | `revert: revert "feat: feature X"`

**Subject (50 characters max):**
- Imperative: "add", "fix", "update" (not "added", "fixes")
- Lowercase except proper nouns
- No period at the end
- Short and clear

**Body (highly recommended if >50 chars):**
```
- Explain WHY not WHAT
- Blank line after subject
- Max 72 characters per line
- Bullet points OK
- Reference issues: Fixes #123, Related to #456
```

**GOOD commit example:**
```
fix(preseed): fix LUKS passphrase escaping in unattended install

The preseed file was not properly escaping special characters,
causing installation to fail on encrypted disks.

- Escape special characters in preseed answers
- Add tests for LUKS with special passwords
- Tested on RPi5 ARM64 + ThinkPad X1 AMD64

Fixes #42
Tested-on: RPi5, ThinkPad X1
```

**BAD commit example:**
```
updated stuff
```

### Step 4: Push + Pull Request

```bash
# Push
git push origin feature/your-feature

# Create PR on GitHub
# (or: gh pr create --fill)
```

**PR template (MANDATORY):**

```markdown
## Description
[Short description of what's changing]

## Related Issue
Fixes #123 (or Relates to #456)

## Tests
- [ ] Local tests passed: `make test`
- [ ] Build successful: `make [edition]`
- [ ] ShellCheck no warnings
- [ ] Documentation updated

## AI Usage
- [ ] No AI-generated code
- [ ] AI used for: [describe if yes]
- [ ] Code reviewed and understood

## Breaking changes?
- [ ] No breaking changes
- [ ] Yes, documented in: ...

## Screenshots (if visual)
[If applicable]
```

---

## Code Standards

### Shell Scripts (Bash)

**MANDATORY: ShellCheck passes without errors**

```bash
#!/bin/bash
# Description
# Author: Your Name
# Date: YYYY-MM-DD

set -euo pipefail

# Variables in UPPERCASE
readonly BUILD_DIR="/tmp/teranga-build"
readonly VERSION="0.2"

# Functions lowercase_with_underscores
build_iso() {
    local edition="${1:?Edition required}"
    local output_dir="${2:-.}"
    
    if [[ ! -d "$BUILD_DIR" ]]; then
        mkdir -p "$BUILD_DIR"
    fi
    
    echo "[INFO] Building ${edition}..." >&2
    # ...
}

# Error handling
trap 'echo "Error at line $LINENO"' ERR
```

**Checklist:**
- `set -euo pipefail` at beginning
- No unquoted variables: `"$var"` not `$var`
- Functions documented
- Messages to stderr: `>&2`
- No hardcoded paths
- `shellcheck -x` = clean

### JSON & Configuration

```json
{
  "edition": "desktop",
  "description": "Desktop edition for government",
  "languages": ["fr", "wo", "ff"]
}
```

**Checklist:**
- Useful comments
- Secure defaults
- No secrets (API keys, passwords)
- Valid format

### Documentation (Markdown)

**Each change = doc update**

- French + English if possible
- Examples in `bash` blocks
- Table of contents if >10 sections
- Functional links
- No typos

---

## Mandatory Tests

### Test 1: ShellCheck

```bash
shellcheck -x src/**/*.sh scripts/*.sh
```
**Fail** → PR rejected | **Pass** → Continue

### Test 2: Build

```bash
make desktop  # or make rpi/leger/server
```
**Fail** → PR rejected | **Pass** → Continue

### Test 3: Functional

```bash
make test
```
Checklist: Boot ✅? Keyboard ✅? Language ✅? Encryption ✅?  
**Fail** → PR rejected | **Pass** → Continue

### Test 4: Manual

If visual/security/boot change → real testing mandatory  
**No testing** → PR rejected

---

## Required Documentation

| Change Type | Documentation Required |
|---|---|
| New feature | README + code comments |
| Bug fix | "Why + how" in commit |
| Security | Risk + mitigation in SECURITY.md |
| Translation | No hardcoded strings |
| Architecture | Diagram if complex (drawio) |

---

## Rigorous Review Process

### Phase 1: Automatic Check (~30 min)
- CI/CD GitHub Actions (ShellCheck, build)
- PR template completed
- Commits well formatted

**Result:** Pass → Phase 2 | Fail → Feedback

### Phase 2: Maintainer Review (24-72h)
**Maintainer checks:**
- [ ] Aligned with mission
- [ ] Code follows standards
- [ ] Tests pass locally
- [ ] Documentation complete
- [ ] No undisclosed AI code (AI_POLICY)

**Results:**
- **Approved** → Phase 3 (merge)
- **Changes requested** → Contributor modifies
- **Rejected** → Clear explanation

### Phase 3: Merge (immediate)
- Squash + merge OR rebase + merge
- Commit = PR title (well formatted)
- Branch deleted

### Strict Rejection Rules

PR rejected if:
- No local test report
- AI code without disclosure
- Poorly formatted commits
- Missing documentation
- Code quality < project
- No response after 7 days of feedback

---

## Translation

### Priority Languages

| Language | Code | Status |
|----------|------|--------|
| French | `fr` | ✅ Complete |
| English | `en` | 90% |
| **Wolof** | `wo` | ❌ **URGENT** |
| **Pulaar** | `ff` | ❌ **URGENT** |
| Serer | `srr` | ❌ Needed |
| Diola | `dyo` | ❌ Needed |
| Mandinka | `mnk` | ❌ Needed |
| Portuguese | `pt` | ❌ Needed |

### How to Contribute

1. Open Discussion: "Translate TérangaOS to [Language]"
2. Maintainers validate
3. Fork → `i18n/` → Copy `fr.po` as template
4. Translate everything
5. PR: `i18n(wo): complete Wolof translation`

### Translation Standards

- Native speakers preferred
- Test on real system
- Respect placeholders: `%s`, `%d`
- African government context
- No direct Google Translate

---

## FAQ

**Q: How long before merge?**  
A: 24-72h depending on complexity. No exceptions.

**Q: Can I use Copilot/ChatGPT?**  
A: YES, but disclosure mandatory. Read [AI_POLICY.md](AI_POLICY_EN.md)

**Q: PR rejected, why?**  
A: Reason in comment. Ask for clarification.

**Q: I'm a first-time contributor**  
A: Normal! Start with translation or small fix. Maintainers help.

**Q: I want to be a maintainer?**  
A: 5+ good PRs + ask in discussion.

---

## Contributor Support

- Questions: [GitHub Discussions](https://github.com/MdialloC19/teranga-os/discussions)
- Bugs: [GitHub Issues](https://github.com/MdialloC19/teranga-os/issues)
- Security: security@teranga-os.org
- Code of Conduct: conduct@teranga-os.org

---

## Resources

- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT_EN.md) - Community standards + enforcement
- [AI_POLICY.md](AI_POLICY_EN.md) - AI usage + disclosure (Linux kernel model)
- [SECURITY.md](SECURITY.md) - Vulnerability reporting
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | April 2026 | Rigorous standards, mandatory AI policy, strict review |
| 1.0 | Initial | Basic version |

---

<p align="center">
  <strong>Thank you for contributing to TérangaOS!</strong><br>
  Together, let's build a sovereign African alternative. 🇸🇳
</p>
