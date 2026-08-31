---
name: ses-expert
description: Diagnose and operate Amazon SES email delivery, including SPF/DKIM/DMARC and custom MAIL FROM, configuration sets and SNS/SQS events, bounce-code triage, suppression lists, sending quotas, multi-project isolation, bulk-send safety, and domain/IP reputation recovery. Use for SES delivery failures, missing Open/Click/Delivery events, high bounce rates, new-domain warm-up, or large campaign planning. Do not use for general-purpose mailbox administration unrelated to SES.
---

# Amazon SES Expert

Treat delivery incidents as an evidence problem. Separate what SES accepted from what
recipient infrastructure delivered, rejected, delayed, or classified as spam.

## Operating principles

- Use current official AWS and mailbox-provider documentation for changing limits,
  feature behavior, sender requirements, and reputation thresholds.
- Do not infer root cause from a dashboard count alone. Inspect the SES event payload,
  especially `eventType`, `mail.messageId`, `mail.tags`, `bounceType`,
  `bounceSubType`, SMTP status, and `diagnosticCode`.
- Count unique recipients or `mail.messageId` values. Raw log `hits`, SQS
  `NumberOfMessagesReceived`, and overlapping text searches can double-count.
- Distinguish recipient defects from sender defects. Never delete or permanently
  suppress valid recipients because the sender had broken DNS, DMARC alignment, or
  reputation-based rejection.
- Do not clear an entire suppression list to make a retry succeed. Classify and remove
  only addresses whose original failure was sender-side and has been fixed.
- For live DNS and authentication incidents, verify public DNS from at least two
  independent resolvers and validate a newly sent message's raw authentication headers.

## Route the task

- For SPF, DKIM, DMARC, MX, custom MAIL FROM, or sender-verification failures, read
  [references/authentication-and-dns.md](references/authentication-and-dns.md).
- For configuration sets, identity notifications, Open/Click tracking, SNS/SQS, event
  duplication, and project tags, read
  [references/event-publishing.md](references/event-publishing.md).
- For SMTP errors, bounce classification, suppression decisions, or log aggregation,
  read [references/bounce-diagnostics.md](references/bounce-diagnostics.md).
- For new-domain reputation, sudden volume, mailbox-provider throttling, or recovery,
  read [references/reputation-and-warming.md](references/reputation-and-warming.md).
- For high-volume campaigns, quotas, queue readiness, staged sends, and stop conditions,
  read [references/bulk-send-runbook.md](references/bulk-send-runbook.md).
- For projects, environments, configuration-set layout, SES tenants, or account/region
  isolation, read [references/multi-project-tenancy.md](references/multi-project-tenancy.md).

## Default diagnostic workflow

1. Establish scope: AWS account, Region, identity, From address, MAIL FROM domain,
   configuration set, sending API/SMTP path, campaign/batch identifier, and timeline.
2. Confirm quota semantics: `Max24HourSend` is rolling 24 hours; `MaxSendRate` is a
   sustained acceptance ceiling, not a deliverability target.
3. Separate application outcomes:
   - API/task failure: SES did not accept the request.
   - `Send`: SES accepted it.
   - `Delivery`: recipient infrastructure accepted it, not necessarily inbox placement.
   - `Bounce`/`Reject`: inspect SMTP response and diagnostic code.
   - `Open`/`Click`: requires tracking and recipient/client behavior.
4. Check DNS and alignment. Run:

   ```bash
   scripts/check_ses_dns.sh <from-domain> <region> [mail-from-domain] [selector1,selector2,selector3]
   ```

5. Verify a fresh message's raw headers. A healthy aligned example is:

   ```text
   spf=pass smtp.mailfrom=ses.mail.example.com
   dkim=pass header.d=mail.example.com
   dmarc=pass header.from=mail.example.com
   ```

6. Aggregate bounce events using mutually exclusive rules and unique message IDs.
7. Apply the narrow fix, send a representative test across the affected mailbox
   providers, then expand only if stop conditions remain healthy.

## Safety boundaries

- Never advise bypassing SES quotas by rapidly opening Regions or accounts.
- Do not recommend retrying permanent recipient errors such as `5.1.1` or complaints.
- Do not treat `p=none` as DMARC success; policy and authentication result are separate.
- Do not promise inbox placement. SES acceptance and Delivery events are weaker claims.
- For a new or damaged domain, prefer consistent engaged traffic over maximum quota use.
