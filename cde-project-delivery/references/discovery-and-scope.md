# Discovery and Scope

Use this reference before architecture or implementation when the ask is broad, the
business metric is unclear, or stakeholders disagree on priority.

## Map the decision chain

Identify the actual roles, not only titles:

- **Economic sponsor:** approves funding and business priority.
- **Business owner:** owns conversion, retention, revenue, productivity, or customer
  experience.
- **Product/content owner:** defines user behavior, quality, and release acceptance.
- **Technical owner:** owns architecture, integration, latency, and engineering effort.
- **Platform owner:** owns accounts, network, identity, pipelines, operations, and cost.
- **Security/privacy owner:** can block data use or release.
- **Finance/procurement/legal:** owns budget, contract, IP, and formal risk acceptance.

Do not ask a cooperative operator to approve work they do not own.

## Build the outcome chain

Write the shortest defensible chain:

```text
Current pain
  -> user or operational impact
  -> proposed capability
  -> measurable PoC evidence
  -> go/no-go or funding decision
  -> later production/business experiment
```

Example categories, not universal metrics:

- quality: precision, recall, factual correctness, unsupported-claim rate;
- experience: task time, interaction completion, useful-result rate;
- reliability: completion, error, timeout, fallback, recovery;
- cost: per event, per user, P50, P95, high-usage cohort;
- safety: blocked severe cases, escape rate, detection and mitigation time.

For every metric capture:

```text
name | baseline | target | denominator | segment | dataset | method | owner
```

If any field is unknown, record it instead of guessing.

## Discover the real job

Ask:

- Where in the workflow or funnel does failure occur?
- Which segment, market, device, language, or scenario is affected?
- What does the customer do today, and why is it insufficient?
- What evidence supports the stated cause?
- What is the frequency, loss, workload, or operational burden?
- What does the user actually hire the capability to accomplish?
- What outcome would justify the next investment?

Distinguish survey intent from observed behavior and observed behavior from causal
impact.

## Use failure history carefully

When a customer mentions an incident:

1. acknowledge the operational impact without assigning blame;
2. request a sanitized incident chain and evidence;
3. distinguish the external communication from the internal root cause;
4. capture affected users, cost, detection time, mitigation time, and control failure;
5. turn same-class incidents into acceptance or red-team cases.

Do not repeat a convenient public explanation such as "sync delay" as verified root
cause.

## Scope with four decisions

### Accept

Work essential to prove the central hypothesis and controllable during the engagement.

### Decline

Valid work that is not required for the proof or belongs to another discipline.

### Defer

Work awaiting approval, data classification, legal review, access, or another
dependency.

### Separate

Production deployment, full scale, support, frontend redesign, unrelated AI workloads,
or long-term experiments with different owners and timelines.

State what replaces declined or deferred work: an interface, synthetic fixture,
integration guide, design note, or later workstream.

## Select the minimum viable proof

Prefer one representative:

- market or Region;
- device or customer segment;
- language or content type;
- workflow node or business event;
- one to three user-visible scenarios.

Choose a slice that can fail honestly. Avoid a broad demo that cannot produce a useful
decision.

## Keep stakeholder wording consistent

Maintain a decision ledger containing:

- problem and outcome chain;
- accepted, declined, deferred, and separate scope;
- business and technical metrics;
- data allowed and forbidden;
- environment and identity boundary;
- cost denominator and limit;
- safety gate and kill conditions;
- support, IP, and production-readiness wording;
- open decisions and owners.

Update it after each meeting. Do not tell each stakeholder a locally convenient version.

## One-page requirements memo

Use this order:

1. **Problem and evidence**
2. **Target user/workflow**
3. **PoC hypothesis and scope**
4. **Success and failure criteria**
5. **Data and environment**
6. **Owners and decisions needed**
7. **Explicit exclusions**

Mark targets as baseline, candidate, approved, or measured. Do not blur these states.
