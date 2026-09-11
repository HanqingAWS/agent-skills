# Governance and Design

Use this reference when architecture must address data, model, content, security, cost,
IP, support, production, or exit concerns.

## Explain the architecture as decisions

Describe:

```text
Input -> processing stages -> deterministic gates -> output -> monitoring/fallback
```

For each stage state:

- purpose and owner;
- input/output contract;
- selected option and alternatives;
- failure behavior;
- metric and evidence;
- portability and exit impact.

Do not list services without explaining why they fit the customer constraint.

## Keep model and business authority separate

Models produce candidate classifications, summaries, recommendations, or actions.
Deterministic systems should decide:

- whether a merchant, product, account, or resource exists;
- inventory, price, entitlement, policy, and transaction state;
- whether required evidence and freshness thresholds passed;
- whether an action is authorized.

Low confidence, missing evidence, stale data, timeout, or validation failure should use
an explicit fail-closed, fallback, or review path. A human approval should not override
a missing hard data prerequisite unless the risk owner explicitly designed that
exception.

## Data sovereignty and privacy

Build a data inventory:

```text
data class | purpose | source | Region | reader | model exposure |
retention | deletion | owner | approval
```

Consider raw input, prompts, outputs, logs, embeddings, indexes, caches, backups,
evaluation sets, and derived weights.

Important distinctions:

- masking is not anonymization;
- pseudonymous data can remain personal data;
- region-bound inference does not automatically approve the use case;
- inference, logging, evaluation, and training are different purposes;
- deleting a source record does not automatically remove derived indexes or models.

Prefer bringing code to the approved data environment. Avoid moving data to the builder.

## Model-provider controls

For the selected model and feature, verify from current official sources:

- input/output training use;
- provider access and subprocessor terms;
- supported Regions and cross-Region routing;
- request and response retention;
- invocation logging defaults and destinations;
- fine-tuning, distillation, or evaluation data behavior;
- deletion and export capabilities.

Record the exact service, feature, Region, date, and source. Do not promise the behavior
of an unreleased model.

## Content and AI safety

Use layered controls:

1. approved sources and scenario scope;
2. input validation and prompt-injection handling;
3. grounded generation;
4. deterministic output and business-rule checks;
5. high-risk human review;
6. active post-publication detection;
7. kill switch, fallback, and audited recovery.

Measure:

- pre-release interception;
- severe-case escape;
- unsupported claims;
- fallback and review rate;
- proactive detection share;
- time to detect, stop exposure, repair, and recover.

User complaints are a final sensor, not the primary detection system.

## Cost and unit economics

Separate:

```text
recurring cloud runtime
one-time engineering or amortization
trial/acquisition cost
content, support, payment, and operations
exit/migration cost
```

Use an explicit denominator such as active device, paid user, request, event, or batch.
Report P50, P95, and high-usage cohorts. Never hide high-cost users inside an average.

Create a machine-readable policy with:

- target and hard ceiling;
- warning, degradation, and stop thresholds;
- included quota and trial pool;
- price-table version;
- approvers and effective date;
- fallback action;
- audit and rollback behavior.

Store policy in the customer-controlled repository. Finance proposes budget changes;
platform owns measurement and distribution; product owns degradation experience;
engineering implements and tests. Numeric-only changes can use controlled configuration
release. Behavior, model routing, data, or permission changes require full release
testing.

Treat cost ranges before live measurement as budget envelopes, not forecasts.

## IP and licensing

Create an asset matrix:

| Category | Questions |
|---|---|
| Customer pre-existing IP | What existed before the engagement? |
| Customer-specific code/config | Where is it stored and who can export it? |
| Reference code | What source and license are delivered? |
| Third-party components | What licenses or commercial restrictions apply? |
| Provider models/weights | What is not transferred? |
| Joint inventions | How are contributors and decisions recorded? |

Do not promise ownership or patent rights orally. Get the task or contract appendix
approved before customer-specific invention or tuning work.

Avoid lock-in by using stable business interfaces, customer-owned source data, versioned
prompts/rules/evals, documented adapters, declared licenses, and an actual replacement
test.

## Support, SLA, and exclusivity

Separate:

- provider service-specific SLA;
- provider support-plan response;
- customer application operations;
- content and business incident response;
- contracted managed or professional services.

A CDE PoC does not automatically include application SLA, on-call support, exclusivity,
or indefinite remediation.

Protect customer confidential information and isolate customer-specific deliverables.
Do not claim that generic architecture patterns or public service capabilities are
exclusive. Route exclusivity to authorized commercial and legal representatives.

## Production boundary

PoC success does not prove:

- production scale or quota;
- long-running reliability;
- regional failover and disaster recovery;
- production privacy and security approval;
- on-call ownership;
- statistical business uplift;
- operational cost at full volume.

Reuse code, contracts, tests, and IaC where appropriate, but deploy a separately
approved production candidate. Do not promote PoC accounts, credentials, data, or
temporary shortcuts.

## Exit path

Classify assets as:

- exportable;
- exportable but provider/model-specific;
- reproducibly rebuildable;
- provider-owned and non-exportable.

Run an exit drill:

1. freeze versions;
2. export customer assets;
3. switch an adapter or model;
4. rebuild embeddings/indexes if needed;
5. rerun quality, safety, latency, and cost tests;
6. validate rollback;
7. delete old data and revoke access;
8. record time, people, fees, and residual risk.

The customer, platform, security, product, and technical owners should sign the evidence
relevant to their responsibility.
