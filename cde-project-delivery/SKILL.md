---
name: cde-project-delivery
description: Plan, build, govern, validate, and hand off time-bounded Customer Delivery Engagement (CDE) prototypes. Use for customer discovery, scope negotiation, measurable PoC design, sandbox implementation, data/security/IP/cost controls, deployment evidence, acceptance testing, GitHub delivery, and customer continuation. Do not use to imply production readiness, legal approval, SLA, exclusivity, or business-outcome guarantees.
---

# CDE Project Delivery

Turn an uncertain customer request into the smallest credible technical proof, then
leave the customer with working code, evidence, ownership boundaries, and an exit
path.

## Route the work

- For stakeholder interviews, business baselines, scope, success criteria, and the
  requirements memo, read [references/discovery-and-scope.md](references/discovery-and-scope.md).
- For architecture, data sovereignty, content safety, IP, cost, support, production
  boundaries, and exit design, read
  [references/governance-and-design.md](references/governance-and-design.md).
- For repository work, sandbox deployment, contract tests, scans, evidence, GitHub,
  handoff, and cleanup, read
  [references/build-acceptance-handoff.md](references/build-acceptance-handoff.md).

Read only the references needed for the current phase.

## Engagement model

Use four phases:

1. **Discover** the customer problem, decision chain, present baseline, failure history,
   constraints, and evidence required for investment.
2. **Frame** the minimum viable proof, explicit boundaries, measurable criteria,
   architecture decisions, risk ownership, and exit conditions.
3. **Build** a working non-production prototype using synthetic or explicitly approved
   data, infrastructure as code, tests, observability, and least privilege.
4. **Prove and hand off** through live deployment, exact acceptance tests, security and
   quality evidence, cleanup instructions, ownership transfer, and a production path.

Do not jump from a broad idea directly to cloud services or implementation.

## Non-negotiable decisions

### Business evidence

- Do not invent a conversion, retention, quality, latency, or cost target.
- Separate business outcomes from what the PoC can prove. A prototype can normally
  prove feasibility, quality, latency, reliability, safety, and cost direction; it
  rarely proves long-term revenue impact.
- Record missing baseline, target, denominator, segment, and measurement method as
  discovery items.
- Treat competitor figures as directional unless datasets and metric definitions are
  comparable.

### Scope

Classify requests as **Accept**, **Decline**, **Defer**, or **Separate**.

- Keep work needed to prove the central hypothesis.
- Decline unrelated work without dismissing its value.
- Defer work blocked by data, legal, security, procurement, or owner approval.
- Separate production, scaling, live integration, frontend redesign, and additional
  workloads when they require another phase or owner.
- Preserve flexibility through a lightweight change log; do not replace scope with
  vague phrases such as "technical support."

### Data and security

- A test label, masked field, starred identifier, or pseudonym is not proof of
  anonymization.
- Use synthetic data first. Before real data, require classification, purpose,
  minimization, region, access, retention, deletion, and owner approval.
- Keep data in the approved account and Region. Do not copy data into an agent context,
  personal machine, or external environment for convenience.
- Use short-lived workload identities and dedicated project roles. Reject shared
  administrators, old supplier roles, long-term credentials, and unreviewed wildcard
  permissions.
- Verify model-specific data use, logging, retention, and provider terms from current
  official sources. Do not generalize one service's behavior to another.

### Commitments and authority

- Do not confirm unreleased roadmap information or build a PoC around a rumored feature.
- Do not promise SLA, exclusivity, continuing support, legal compliance, patent
  ownership, production readiness, or business uplift without an authorized written
  agreement.
- Distinguish customer content, customer-specific deliverables, reference code,
  third-party components, provider models, and possible joint inventions.
- Route formal risk acceptance, legal interpretation, exclusivity, and IP terms to the
  authorized customer and provider representatives.

### Contract-first implementation

- Treat the interface specification and automated tests as an executable contract.
- Verify the exact base URL, path prefix, authentication exception, status code,
  response schema, test ordering, and required state.
- Build each success-path test with its own valid setup. Do not depend on test execution
  order or state created by another test.
- When the written contract and evaluator tests disagree, document the conflict rather
  than silently weakening correct behavior.

### Deployment evidence

- IaC synthesis is not live deployment evidence.
- Before mutation, verify account, Region, principal, branch, remote, and environment
  classification.
- Show the infrastructure diff, deploy to an approved non-production environment, run
  the exact acceptance suite, and record outputs from the submitted commit.
- Never present historical results, a different commit, local fixture latency, or an
  internal load balancer as the current external acceptance result.
- Destroy or transfer the environment according to the agreed retention and handoff
  plan.

## Expected deliverables

Scale deliverables to the engagement, but normally include:

- engagement charter and outcome chain;
- requirements memo with assumptions and open questions;
- architecture and decision records;
- source code and stable input/output contracts;
- infrastructure as code and environment safety checks;
- synthetic or approved test data;
- automated unit, boundary, integration, and acceptance tests;
- quality, latency, reliability, safety, and cost evidence;
- security findings and dispositions when required;
- runbook, integration guide, cost model, and production-gap assessment;
- IP, support, data, and ownership boundaries;
- exit, cleanup, migration, and customer continuation instructions.

## Interaction style

- Lead with the customer's result and risk, not service names.
- Reflect what was learned before asking the next focused question.
- Give direct answers to executives; provide detailed evidence to engineering,
  platform, security, content, and finance owners.
- Maintain one decision ledger so every stakeholder receives the same scope, metric,
  data, cost, and production-readiness wording.
- Be concise in conversation and precise in artifacts.

## Completion standard

The CDE is complete only when:

- the working prototype matches the agreed scope;
- acceptance criteria can be independently evaluated;
- required deployment, scan, and risk evidence corresponds to the delivered version;
- the customer can locate, run, extend, replace, and remove the solution;
- remaining production work, owners, risks, and decision gates are explicit.

Passing a PoC does not make it production-ready.
