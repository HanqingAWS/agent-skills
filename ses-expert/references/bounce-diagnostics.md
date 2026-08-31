# SES Bounce Diagnostics

Use the SMTP status and `diagnosticCode` as the primary evidence. SES
`bounceType`/`bounceSubType` can be useful but may be surprising; a receiver's explicit
SMTP response is usually more actionable.

## Count correctly

Raw log `hits` are not necessarily unique:

- broad substring searches overlap narrower searches;
- identity and configuration-set notifications can duplicate events;
- Standard SQS can redeliver;
- one recipient can produce multiple attempts or records.

Build mutually exclusive categories in priority order, then calculate unique
`mail.messageId` or recipient counts.

## Decision table

| Pattern | Likely cause | Classification | Action |
|---|---|---|---|
| `5.1.1`, `account does not exist`, `no such user` | Invalid or removed mailbox | Recipient permanent | Permanently suppress/remove |
| `5.1.2`, `invalid domain`, `unknown address` | Bad recipient domain/address | Recipient permanent | Remove after confirming field is recipient-side |
| `5.2.1 inactive` | Disabled mailbox | Recipient permanent or long-term | Suppress; require re-opt-in |
| `5.2.2`, `over quota`, `mailbox full` | Full mailbox | Recipient temporary | Hold and retry once after several days |
| `4.4.7 message expired`, `421`, `451` | Temporary DNS, throttling, or policy deferral | Sender/receiver temporary | Fix root cause; controlled retry |
| `5.7.515 ... DMARC=FAIL` | Authentication alignment failure | Sender configuration | Fix DKIM/MAIL FROM; retry valid recipients selectively |
| `invalid DNS MX or A/AAAA` | Visible sender domain lacked usable DNS | Sender configuration | Publish receiving MX/A; retest |
| `non-local sender verification failed` | Sender domain/mailbox could not be verified | Sender configuration | Publish MX and create mailbox/alias |
| Gmail `5.7.1 unsolicited` | Spam/reputation/content decision | Sender reputation/policy | Do not immediate-retry; improve audience, rate, content |
| GMX/WEB.DE policy restriction or `r0110` | Provider policy/rate/IP/domain reputation | Sender reputation/policy | Reduce provider rate; monitor; escalate if persistent |
| `DNSBL listing` | Sending IP listed or blocked | IP reputation | Check whether SES shared IP; gather evidence for AWS |
| `Suppression list` | SES did not attempt delivery | Prior suppression | Inspect original reason before removal |
| no `diagnosticCode` | Incomplete telemetry | Unknown | Inspect raw event/logging path |

## Important distinctions

- `550` is not one root cause. The enhanced status and text matter.
- A policy or authentication rejection does not prove the recipient address is invalid.
- A final Bounce event can have `Transient` classification after SES retried a temporary
  condition and exhausted its delivery window.
- `Send` means SES accepted the request. It does not mean recipient acceptance.
- `Delivery` means the recipient infrastructure accepted the message, not inbox
  placement.

## Suppression-list policy

Permanently retain:

- confirmed nonexistent addresses;
- complaints, unless the recipient explicitly re-subscribes;
- repeated disabled/inactive mailboxes.

Candidates for selective removal after a verified fix:

- DMARC or MAIL FROM failures;
- sender-domain MX/verification failures;
- temporary provider policy failures;
- addresses suppressed during a known sender-side outage.

Test a small representative sample before removing the rest.

## Recommended structured fields

Persist and expose:

```text
event_type
ses_message_id
recipient
bounce_type
bounce_subtype
smtp_status
diagnostic_code
provider_domain
project_id
environment
batch_id
event_timestamp
```

Dashboards and exports should show the full diagnostic code. Do not force operators to
infer it from a generic Bounce badge.

## Official references

- Bounce event contents:
  https://docs.aws.amazon.com/ses/latest/dg/event-publishing-retrieving-sns-contents.html
- Account suppression:
  https://docs.aws.amazon.com/ses/latest/dg/sending-email-suppression-list.html
- Reputation messages:
  https://docs.aws.amazon.com/ses/latest/dg/reputationdashboardmessages.html
