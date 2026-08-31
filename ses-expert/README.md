# Amazon SES Expert Skill

`ses-expert` is a reusable AI-agent skill for diagnosing and operating Amazon
Simple Email Service delivery workflows.

It was created from real production support scenarios involving:

- SPF, Easy DKIM, DMARC alignment, and custom MAIL FROM;
- sender-domain MX and sender-verification failures;
- configuration sets, identity feedback notifications, SNS, SQS, and duplicate events;
- missing Delivery, Open, and Click metrics;
- suppression-list handling;
- SMTP bounce-code diagnosis;
- new-domain warm-up and reputation recovery;
- large sends from tens of thousands to hundreds of thousands of recipients;
- multiple projects, environments, configuration sets, and SES tenants.

## What the skill helps with

Use this skill when an agent needs to:

- explain why `SPF=Pass` and `DKIM=Pass` can still produce `DMARC=Fail`;
- troubleshoot Microsoft `550 5.7.515`;
- distinguish invalid recipients from sender-side DNS/authentication failures;
- interpret Gmail `550 5.7.1 unsolicited mail`;
- diagnose GMX/WEB.DE policy, DNS, and sender-verification responses;
- determine which suppressed addresses may safely be retried;
- verify configuration-set event destinations and SNS/SQS processing;
- avoid double-counting SES events;
- design a safe staged campaign under SES sending quotas;
- create a domain/IP reputation recovery plan;
- decide how projects and environments should share configuration sets and queues.

## Directory structure

```text
ses-expert/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
│   ├── authentication-and-dns.md
│   ├── bounce-diagnostics.md
│   ├── bulk-send-runbook.md
│   ├── event-publishing.md
│   ├── multi-project-tenancy.md
│   └── reputation-and-warming.md
└── scripts/
    └── check_ses_dns.sh
```

`SKILL.md` is intentionally concise. It routes the agent to the relevant reference
instead of loading every SES topic into context.

## Installation

Copy the complete `ses-expert` directory into the skills directory used by your agent.

For Codex:

```bash
cp -R ses-expert "${CODEX_HOME:-$HOME/.codex}/skills/"
```

The skill supports implicit discovery and can also be invoked explicitly:

```text
$ses-expert
```

## Example prompts

### Authentication

```text
Use $ses-expert to diagnose why Outlook returns:
SPF=Pass, DKIM=Pass, DMARC=Fail, 550 5.7.515.
```

### Bounce analysis

```text
Use $ses-expert to classify these SES diagnosticCode values into:
permanent recipient failure, sender configuration, temporary failure,
and reputation/policy rejection.
```

### Event publishing

```text
Use $ses-expert to investigate why Delivery events arrive in SQS
but Open and Click remain zero.
```

### Bulk send

```text
Use $ses-expert to create a staged plan for 800,000 recipients.
The SES quota is 1,000,000 per rolling 24 hours and 300 recipients/second.
```

### Reputation recovery

```text
Use $ses-expert to create a 30-day recovery plan after a cold domain
sent 800,000 messages and received Gmail 5.7.1 policy blocks.
```

## DNS preflight script

The included script performs read-only public DNS checks before a campaign.

Requirements:

```text
bash
dig
```

Basic usage:

```bash
ses-expert/scripts/check_ses_dns.sh \
  mail.example.com \
  us-west-2 \
  ses.mail.example.com
```

Validate SES Easy DKIM selectors as well:

```bash
ses-expert/scripts/check_ses_dns.sh \
  mail.example.com \
  us-west-2 \
  ses.mail.example.com \
  selector1,selector2,selector3
```

The script checks:

- visible From-domain MX, A/AAAA, TXT, and DMARC;
- custom MAIL FROM MX and SPF;
- expected regional SES feedback endpoint;
- optional DKIM selector CNAME records;
- the risky case where the visible From domain has neither MX nor A/AAAA.

Exit codes:

- `0`: no critical error found;
- `1`: one or more required records failed validation;
- `2`: invalid invocation or missing `dig`.

## Diagnostic model

The skill separates incidents into four root-cause families.

### Recipient failures

Examples:

```text
5.1.1 account does not exist
no such user
unknown recipient
```

These should normally be permanently removed or suppressed.

### Sender authentication and DNS failures

Examples:

```text
550 5.7.515 DMARC=Fail
invalid DNS MX or A/AAAA resource record
non-local sender verification failed
```

The recipient may still be valid. Fix the sender, verify a small sample, and only then
consider selective suppression removal.

### Temporary recipient or provider failures

Examples:

```text
421 / 451 temporary deferral
5.2.2 mailbox full
4.4.7 message expired
```

These require controlled retry behavior, not permanent deletion.

### Reputation and policy failures

Examples:

```text
Gmail 550 5.7.1 unsolicited mail
GMX/WEB.DE policy restriction
DNSBL listing
```

Immediate bulk retry usually makes these worse. Improve audience quality, rate,
engagement, authentication, and provider-specific reputation first.

## Event-counting guidance

Do not treat raw log hits or SQS receive counts as unique emails.

Potential duplication sources include:

- overlapping diagnostic-code searches;
- identity feedback and configuration-set event destinations targeting the same topic;
- Standard SQS at-least-once delivery;
- multiple delivery attempts.

Prefer a stable business dedupe key based on:

```text
mail.messageId + eventType + recipient + event timestamp
```

Store the full SMTP status and `diagnosticCode`; generic Bounce badges are insufficient
for production incident response.

## Safety and limitations

- This skill does not promise inbox placement.
- `Send` means SES accepted a request; `Delivery` means the receiving infrastructure
  accepted it.
- Do not bypass quotas by opening Regions or accounts solely to continue a risky send.
- Do not bulk-clear an SES suppression list.
- Do not classify all `550` responses as invalid recipients.
- Always verify current AWS and mailbox-provider requirements from official sources.

## Validation

Validate the skill structure with the Codex skill-creator validator:

```bash
python3 quick_validate.py ses-expert
```

Validate the shell script:

```bash
bash -n ses-expert/scripts/check_ses_dns.sh
```

Run a real read-only DNS test before publishing:

```bash
ses-expert/scripts/check_ses_dns.sh \
  mail.aniimo.com \
  us-west-2 \
  ses.mail.aniimo.com
```

## Source documentation

The reference files link to current official AWS and mailbox-provider documentation.
For changing quotas, sender requirements, feature behavior, and enforcement thresholds,
the agent should verify the latest official source rather than rely on static numbers.
