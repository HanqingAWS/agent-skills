# SES Bulk Send Runbook

Use this runbook before and during high-volume sends.

## Preflight

### Quotas and timing

- Read live `Max24HourSend`, `SentLast24Hours`, and `MaxSendRate`.
- SES daily quota is rolling 24 hours, not a midnight reset.
- Reserve headroom for transactional traffic, retries, and existing sends.
- Calculate duration at the planned rate, including observation pauses.
- Set application-level daily limits and global rate limits consistently with SES.

### Authentication and DNS

- SES identity verified in the sending Region.
- Easy DKIM successful.
- Custom MAIL FROM successful and aligned.
- DMARC record present.
- Visible From domain has receiving MX/A when broad-provider compatibility requires it.
- Actual From mailbox or alias exists.
- Test raw headers show SPF, DKIM, and DMARC pass.

### Data hygiene

- Deduplicate case-insensitively where application semantics permit.
- Remove invalid syntax, prior `5.1.1`, complaints, unsubscribes, and hard suppressions.
- Check recipient domains in batches with DNS caching.
- Treat catch-all/risky/unknown validation results as a separate segment.
- Never classify sender-side authentication failures as invalid recipients.

### Events and queues

- Send queue, callback queue, and DLQs healthy.
- Long polling and visibility timeout appropriate for processing time.
- Consumer capacity can handle at least Send + Delivery events per message, plus
  engagement events if enabled.
- Identity feedback and configuration-set events do not duplicate the same business
  events.
- Event consumer is idempotent.

## Staged send

For a new or recently repaired domain, do not use the SES quota as the initial target
rate. Example emergency staging:

| Stage | Volume | Rate | Observation |
|---|---:|---:|---:|
| A | 2,000 | 20/s | 10-15 minutes |
| B | 10,000 | 40/s | 10-15 minutes |
| C | 50,000 | 60/s | 15-20 minutes |
| D | 150,000 | 80/s | 15-20 minutes |
| E | remainder | 100/s or evidence-based rate | continuous |

Prefer randomized provider distribution or explicit provider lanes so one mailbox
provider is not hit with the entire burst.

## Stop or reduce conditions

Stop immediately:

- recurring DMARC/DKIM/MAIL FROM failures;
- sender-domain MX or sender-verification failures;
- complaints at or above the operating ceiling;
- DLQ messages or data-loss indications.

Pause and investigate:

- hard bounce exceeds 3%;
- new provider `5.7.x` blocks rise sharply;
- callback queue age grows continuously;
- SES throttling persists;
- one provider's delivery materially diverges from the rest.

Reduce the rate by half for temporary provider throttling before considering a retry.

## Retry rules

- Permanent recipient failure: never retry.
- Complaint/unsubscribe: never retry without explicit re-consent.
- Mailbox full: retry once after several days.
- Sender authentication/DNS failure: fix, prove with a small provider-specific test,
  selectively unsuppress, then retry in stages.
- Reputation/policy rejection: cooldown, improve audience and cadence, then retry only
  engaged recipients.

## Post-send

- Wait for the delivery window and delayed events.
- Report unique recipients by event type and provider.
- Compare Send, Delivery, Bounce, Complaint, Open, and Click using consistent
  denominators.
- Preserve full SMTP diagnostics.
- Update suppression and audience-quality data before the next campaign.

## Official references

- SES quotas:
  https://docs.aws.amazon.com/ses/latest/dg/manage-sending-quotas.html
- Increasing quotas:
  https://docs.aws.amazon.com/ses/latest/dg/manage-sending-quotas-request-increase.html
