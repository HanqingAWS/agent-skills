# drawio-diagram

Generate any type of diagram using [draw.io](https://app.diagrams.net/). Supports Mermaid, XML, and CSV formats with automatic URL generation.

## Supported Diagram Types

- **Standard**: Flowcharts, org charts, mind maps, timelines, Venn diagrams
- **Software**: UML (class, sequence, activity, use case), ERD, architecture diagrams
- **Cloud/Infrastructure**: AWS, Azure, GCP, Kubernetes, network topology
- **Engineering**: Electrical circuits, digital logic, P&ID, floor plans
- **Business**: BPMN, value streams, customer journeys, SWOT
- **UI/UX**: Wireframes, mockups, sitemaps

## How It Works

1. You describe the diagram you want
2. The agent selects the best format (Mermaid / XML / CSV)
3. Generates diagram code and compresses it into a draw.io URL
4. Outputs an HTML artifact with a one-click button to open in draw.io

## Usage

### Kiro

Copy `SKILL.md` into your `.kiro/steering/` directory:

```bash
cp drawio-diagram/SKILL.md ~/.kiro/steering/drawio-diagram.md
```

### Claude Code

Copy the skill folder into your `~/.claude/skills/` directory:

```bash
cp -r drawio-diagram ~/.claude/skills/
```

### Other AI Agents

The `SKILL.md` file is a self-contained prompt that can be used with any AI agent that supports system prompts or custom instructions. Simply include its content in your agent's context.

## Example Prompts

- "Draw a flowchart for user login process"
- "Create an AWS architecture diagram with VPC, EC2, RDS, and S3"
- "Generate an org chart for my team"
- "Make a sequence diagram for the payment flow"
- "Design an ERD for an e-commerce database"
