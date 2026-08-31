# Multi-project and Multi-environment SES Design

## Configuration-set layout

Use a dedicated configuration set when a project needs distinct:

- event destinations;
- metrics and attribution;
- IP pool;
- TLS or delivery policy;
- suppression override;
- VDM settings.

For strict routing:

```text
project-a-prod -> SNS/SQS A-prod
project-b-prod -> SNS/SQS B-prod
```

For operational simplicity, configuration sets can share an environment queue:

```text
project-a-prod --\
project-b-prod ----> SNS-prod -> SQS-prod
project-c-prod --/
```

Route using `ses:configuration-set`, `project_id`, and `environment` tags.

## Environment strategy

Different environments do not require different Regions. Usually prefer:

```text
same Region
  project-a-test
  project-a-staging
  project-a-prod
```

Templates only isolate content; they do not isolate event streams or reputation.

For strong production isolation, separate AWS accounts are more effective than using
different Regions as environment boundaries. SES identities, quotas, configuration sets,
and templates are Regional.

## SES tenants

SES tenants provide tenant-level:

- reputation attribution;
- automatic policy enforcement;
- resource assignment;
- suppression options.

They are not a complete external reputation boundary. Mailbox providers evaluate visible
domains, DKIM domains, IPs, content, and behavior. If tenants share those signals, a poor
project can still affect external deliverability. Combined tenant activity can also affect
the SES account's overall reputation.

For stronger separation:

```text
project A -> a.mail.example.com -> configuration set A -> optional IP pool A
project B -> b.mail.example.com -> configuration set B -> optional IP pool B
```

Subdomains can benefit from organizational continuity but still require controlled
ramping. Separate dedicated IP pools also require IP warm-up.

## Application requirements

Every send should explicitly select the configuration set and attach project/environment
tags. Tenant-aware sends must also pass the SES tenant name. Creating resources in the
console alone does not make existing send code tenant-aware.

## Official references

- SES tenants:
  https://docs.aws.amazon.com/ses/latest/dg/tenants.html
- Configuration sets:
  https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html
