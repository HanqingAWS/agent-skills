# SES Event Publishing and Queues

Use this reference for missing or duplicated Delivery/Open/Click events, configuration
sets, identity notifications, SNS/SQS, message tags, and queue metrics.

## Two notification paths

### Identity feedback notifications

Configured on an SES identity. They publish only:

- Bounce
- Complaint
- Delivery

They do not provide Send, Open, or Click.

### Configuration-set event destinations

The send request must specify the configuration set. Event destinations can publish
selected event types such as:

```text
Send, Delivery, DeliveryDelay, Bounce, Complaint, Reject,
RenderingFailure, Open, Click, Subscription
```

For SQS, use:

```text
SES configuration set -> SNS topic -> SQS queue
```

or EventBridge routing. SES configuration-set event publishing does not directly target
SQS.

## Prevent duplicate events

If identity feedback notifications and a configuration-set destination publish
Delivery/Bounce/Complaint to the same SNS/SQS path, the consumer can receive duplicate
logical events. Standard SQS is also at-least-once.

Choose one primary event path, or deduplicate using stable event content such as:

```text
mail.messageId + eventType + event timestamp + recipient
```

Do not use raw SNS message IDs as the only dedupe key when two SNS publications can
represent the same SES event.

## Open and Click behavior

Open tracking inserts a small tracking image. Click tracking rewrites HTTP/HTTPS links
through a tracking redirect. Therefore the delivered MIME is not identical to the
original template.

Open/Click can remain zero when:

- the event destination did not select Open/Click;
- the send omitted `ConfigurationSetName`;
- the email is not HTML;
- images were blocked or never loaded;
- no trackable link was clicked;
- a security scanner or bot triggered the action and the application reports human-only
  engagement;
- the consumer failed to parse the SNS envelope or event payload.

Some recipient security products treat generic redirect domains as suspicious. If
tracking is required, consider an SES custom redirect domain and compare a fresh A/B test:

```text
A: no Open/Click
B: Open only
C: Open and Click
```

## Message tags

Set per-message tags in the send request, not as AWS resource tags:

```json
[
  {"Name": "project_id", "Value": "project-a"},
  {"Name": "environment", "Value": "prod"},
  {"Name": "batch_id", "Value": "batch-123"}
]
```

SES events expose custom tags under `mail.tags`. The configuration set is also visible
as an SES-provided tag. Tags support shared event queues while preserving project-level
routing and analysis.

## SQS metric interpretation

- `NumberOfMessagesSent`: messages added to the queue.
- `NumberOfMessagesReceived`: receive operations/messages returned; the same logical
  message can be counted more than once.
- `NumberOfMessagesDeleted`: successful acknowledgements/deletes, not unique business
  events.
- Visible/in-flight counts are approximate snapshots.

Queue counts never identify SES event types. Inspect payload `eventType`.

## Debug checklist

1. Confirm Region and configuration-set name.
2. Confirm destination is enabled and its matching event types.
3. Confirm the send contains `ConfigurationSetName`.
4. Confirm SNS subscription and SQS policy.
5. Inspect a raw event for `eventType`, `mail.messageId`, `mail.tags`.
6. Review consumer logs and DLQ.
7. Compare unique message IDs, not raw queue receives.

## Official references

- Event publishing:
  https://docs.aws.amazon.com/ses/latest/dg/monitor-using-event-publishing.html
- SNS event destination:
  https://docs.aws.amazon.com/ses/latest/dg/event-publishing-add-event-destination-sns.html
