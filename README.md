# Agent Skills

A collection of reusable AI agent skills.

## Skills

### [web-ppt](./web-ppt)
Generate a single-file interactive HTML slide deck (web-based PPT) from a conversational brief. Features keyboard navigation, fullscreen, overview mode, and touch support.

### [drawio-diagram](./drawio-diagram)
Generate any type of diagram using draw.io. Supports Mermaid, XML, and CSV formats with automatic URL generation and one-click opening. Covers flowcharts, UML, AWS architecture, ERD, org charts, and more.

### [ses-expert](./ses-expert)
Diagnose and operate Amazon SES authentication, bounce codes, configuration-set events, suppression lists, high-volume campaigns, and sender reputation recovery.

Highlights:

- SPF, DKIM, DMARC, custom MAIL FROM, MX, and sender verification
- SMTP bounce-code classification and selective suppression handling
- Configuration sets, identity notifications, SNS/SQS, Open/Click, and event deduplication
- New-domain warm-up, high-volume send runbooks, and reputation recovery
- Multi-project, multi-environment, and SES tenant design
- Interactive generation of DNS, AWS CLI, SQL, and log verification commands

See the detailed [ses-expert README](./ses-expert/README.md) for installation, examples, script usage, and validation.

### [cde-project-delivery](./cde-project-delivery)
Plan, build, govern, validate, and hand off time-bounded Customer Delivery Engagement
(CDE) prototypes. Covers stakeholder discovery, scope boundaries, measurable PoC
criteria, sandbox implementation, data/security/IP/cost controls, exact acceptance
testing, deployment evidence, GitHub delivery, cleanup, and customer continuation.

## Usage

Copy the skill folder into your agent's skills directory:

- **Kiro**: Copy `SKILL.md` into `.kiro/steering/` as a `.md` file
- **Claude Code**: Copy the skill folder into `~/.claude/skills/`
- **Other Agents**: Include the `SKILL.md` content in your agent's system prompt or custom instructions

## Contributing

Feel free to submit a PR to add new skills. Each skill should be a folder containing at minimum a `SKILL.md` file.
