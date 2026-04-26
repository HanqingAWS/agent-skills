# Agent Skills

A collection of reusable AI agent skills.

## Skills

### [web-ppt](./web-ppt)
Generate a single-file interactive HTML slide deck (web-based PPT) from a conversational brief. Features keyboard navigation, fullscreen, overview mode, and touch support.

### [drawio-diagram](./drawio-diagram)
Generate any type of diagram using draw.io. Supports Mermaid, XML, and CSV formats with automatic URL generation and one-click opening. Covers flowcharts, UML, AWS architecture, ERD, org charts, and more.

## Usage

Copy the skill folder into your agent's skills directory:

- **Kiro**: Copy `SKILL.md` into `.kiro/steering/` as a `.md` file
- **Claude Code**: Copy the skill folder into `~/.claude/skills/`
- **Other Agents**: Include the `SKILL.md` content in your agent's system prompt or custom instructions

## Contributing

Feel free to submit a PR to add new skills. Each skill should be a folder containing at minimum a `SKILL.md` file.
