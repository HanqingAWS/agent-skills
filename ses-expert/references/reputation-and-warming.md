# SES Reputation and Domain Warming

## Reputation is layered

Separate:

- SES account/Region reputation and enforcement;
- domain and DKIM reputation observed by mailbox providers;
- sending-IP reputation;
- recipient-level engagement and prior trust.

Configuration sets and SES tenants improve attribution and targeted enforcement, but do
not create independent Gmail/Yahoo reputation when projects share the same visible
domain, DKIM identity, and IP path.

## What a sudden cold-domain burst causes

The first symptoms are commonly:

- temporary deferrals and throttling (`421`, `451`, `4.x`);
- delayed delivery and retry exhaustion;
- spam-folder placement;
- policy rejection (`5.7.1`);
- provider-specific blocks.

Invalid-recipient errors (`5.1.1`) primarily indicate list quality. Authentication and
DNS failures are configuration defects, not warming defects.

## Shared versus dedicated IP

- SES shared IP: AWS manages IP-pool reputation; the sender still owns domain, audience,
  and content reputation.
- Dedicated IP: the customer owns IP reputation and must warm it.
- Moving a troubled new domain immediately to a cold dedicated IP adds another cold
  reputation dimension. Do not recommend that as the first recovery action.
- Managed dedicated IP can automate IP warm-up, but it does not eliminate domain
  reputation building.

## Recovery after an oversized first campaign

1. Wait for delayed events before declaring the final outcome.
2. Fix all authentication/DNS defects and prove them with fresh raw headers.
3. Deduplicate events and classify recipient versus sender failures.
4. Remove invalid, complained, unsubscribed, and stale recipients.
5. Resume only with recent, explicitly opted-in, highly engaged users.
6. Maintain a consistent cadence. Increase only when each provider remains healthy.

Example conservative recovery cadence, adapted to the normal business volume:

```text
Day 1: essential/transactional only; finish incident analysis
Days 2-3: 20k-50k engaged recipients/day
Days 4-5: 50k-100k/day
Days 6-7: 100k-200k/day
Following weeks: increase 25%-50% per healthy step
```

This is a starting point, not a universal schedule. Provider-level evidence overrides it.

## Practical health gates

Use stricter operational targets than enforcement thresholds:

- target hard bounce below 2%; investigate above 3%;
- keep complaints below 0.1%;
- no recurring authentication or sender-DNS errors;
- no sustained increase in provider policy blocks;
- stable queue/DLQ health;
- positive engagement from the segment being expanded.

AWS recommends keeping hard bounces below 5%; higher rates can trigger account review,
and substantially higher rates can lead to sending pauses. Always verify current
thresholds from official documentation.

## Audience order

Send in this order:

1. recent active customers with explicit consent;
2. recent purchasers or authenticated active users;
3. older but previously engaged subscribers;
4. catch-all, risky, or long-inactive addresses only in a separate re-permission
   strategy, not the main campaign.

Do not use artificial opens, seed farms, purchased lists, or forced interactions as
reputation shortcuts.

## Provider tooling

- SES Reputation Dashboard and Virtual Deliverability Manager
- Google Postmaster Tools
- provider-specific postmaster responses and feedback loops
- configuration-set and project tags for ISP-level analysis

## Official references

- SES warming guidance:
  https://aws.amazon.com/blogs/messaging-and-targeting/guide-to-ip-and-domain-warming-and-migrating-to-amazon-ses/
- SES success metrics:
  https://docs.aws.amazon.com/ses/latest/dg/success-metrics.html
- Gmail sender guidelines:
  https://support.google.com/a/answer/81126
