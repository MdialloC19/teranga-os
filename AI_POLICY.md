# AI Policy — TérangaOS

**Version:** 2.0 (Linux Kernel Model)  
**Effective:** April 2026  
**Language:** English

---

## AI Tools and Development

This document provides guidance for AI tools and developers using AI assistance when contributing to TérangaOS.

AI tools helping with TérangaOS development should follow the standard development process:
- [CONTRIBUTING.md](CONTRIBUTING_EN.md) - Contribution guidelines
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT_EN.md) - Community standards
- [SECURITY.md](SECURITY.md) - Security policy

---

## Licensing and Legal Requirements

All contributions must comply with TérangaOS licensing requirements:

**All code must be compatible with GPLv3-or-later**
- Use appropriate SPDX license identifiers
- See [LICENSE](LICENSE) for full details
- All AI-generated code inherits the same GPL-3.0+ license from the human contributor

---

## Signed-off-by and Developer Certificate of Origin

AI agents **MUST NOT** add Signed-off-by tags. Only humans can legally certify the Developer Certificate of Origin (DCO).

**The human submitter is responsible for:**
- Reviewing all AI-generated code
- Ensuring compliance with licensing requirements (GPL-3.0+)
- Adding their own Signed-off-by tag to certify the DCO
- Taking full responsibility for the contribution

---

## Attribution for AI-Assisted Code

When humans use AI tools to develop contributions, proper attribution helps track the evolving role of AI.

**Include an Assisted-by tag in commits:**

```
Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]
```

Where:
- AGENT_NAME: Claude, ChatGPT, GitHub-Copilot, Gemini
- MODEL_VERSION: claude-3-opus, gpt-4-turbo, copilot-2024
- [TOOL1] [TOOL2]: shellcheck, flake8, pylint (optional)

**Examples:**
```
Assisted-by: Claude:claude-3-opus shellcheck
Assisted-by: GitHub-Copilot:2024.1
```

**Commit format:**
```
fix(preseed): fix LUKS passphrase escaping

The preseed file was not properly escaping special characters,
causing installation to fail on encrypted disks.

- Escape special characters in preseed answers
- Add tests for LUKS with special passwords
- Tested on RPi5 ARM64 + ThinkPad X1 AMD64

Assisted-by: Claude:claude-3-opus shellcheck
Fixes #42

Signed-off-by: Developer Name <developer@example.com>
```

---

## AI-Assisted Code Requirements

When AI assists with code contributions:

1. **Human review mandatory**
   - Developer must read and understand all code
   - Must be able to justify changes during review

2. **Testing required**
   - All tests must pass: make test, shellcheck, build, functional
   - Same quality standards as manual code

3. **Documentation required**
   - Code must be commented
   - Functional behavior must be explained

4. **Licensing compliance**
   - Human certifies via Signed-off-by that code is GPL-3.0+ compatible
   - Developer is responsible for copyright compliance

---

## Prohibited AI Practices

Developers MUST NOT:

1. Submit unreviewed AI code
2. Use AI to bypass licensing requirements
3. Fabricate compliance ("thoroughly tested" when not tested)
4. Submit without personal accountability
5. Use undisclosed AI (>20% AI contribution requires Assisted-by tag)

---

## Detecting Undisclosed AI Code

Reviewers may flag suspicious patterns:
- Overly verbose comments with logic errors
- Unusual code structure
- Code that works but logic unclear
- Tests that test nothing
- Perfect formatting with zero context

If suspected but not disclosed:
1. Reviewer asks: "Was this AI-generated?"
2. If denied but evidence clear → Code rejected
3. Repeated violations → Code of Conduct escalation

---

## Acceptable AI Use Cases

AI CAN help with:
- Understanding existing code
- Generating boilerplate
- Writing tests
- Documentation review
- Debugging suggestions
- Code review automation
- Translating concepts

AI CANNOT replace:
- Human code review
- Human testing
- Human responsibility (Signed-off-by)
- Human understanding

---

## Approved Automated Tools

Tools approved for automatic PRs:
- GitHub Actions (CI/CD linters)
- ShellCheck (lint automation)
- Dependabot (dependency updates)
- Static analysis tools

Tools NOT approved:
- Automated code generation bots
- Bots that modify code without approval

---

## Confidentiality Warnings

If using GitHub Copilot:
- Code used for training (GitHub terms)
- TérangaOS is public anyway
- Do NOT use Copilot on proprietary code

If using ChatGPT/Claude/Gemini:
- Code may be used for training
- Do NOT paste sensitive information

---

## Policy Evolution

This policy reviewed annually because:
- AI tools evolve rapidly
- Project needs may change
- Community feedback matters

Revision process:
1. Proposal in GitHub Discussions
2. Community feedback (14 days)
3. Maintainer decision
4. Documentation update

---

## Questions?

- AI usage: [GitHub Discussions](https://github.com/MdialloC19/teranga-os/discussions)
- Legal/licensing: security@teranga-os.org
- Code of Conduct: conduct@teranga-os.org

---

## References

Modeled on:
- [Linux Kernel AI Coding Assistants Policy](https://docs.kernel.org/process/coding-assistants.html)
- [Developer Certificate of Origin](https://developercertificate.org/)
- [GPL-3.0 License](https://www.gnu.org/licenses/gpl-3.0.html)

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | April 2026 | Linux kernel model: Assisted-by tags, DCO, Signed-off-by |
| 1.0 | Initial | Initial AI policy |

---

AI is a tool. Humans are responsible.
Transparency + Accountability = Quality Code
