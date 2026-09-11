# Build, Acceptance, and Handoff

Use this reference when implementing, deploying, validating, submitting, or handing off
the CDE prototype.

## Read before editing

Inspect:

- repository instructions and current worktree state;
- README, entry points, existing architecture, tests, and IaC;
- language and framework conventions;
- available deployment scripts and reports;
- user changes that must not be reverted.

Use the repository's existing patterns. Keep unrelated refactors out of the delivery.

## Build around explicit contracts

Before implementation, turn the specification into a table:

```text
case | setup | request | authentication | expected status |
required fields | required state | cleanup
```

Check:

- root URL versus versioned base path;
- public versus authenticated health route;
- integer, string, empty, null, and range validation;
- synchronous versus asynchronous status codes;
- success-path setup and persistence;
- whether tests are independent and order-agnostic;
- exact error and response schemas.

Create a local suite mirroring evaluator paths and payloads. Run the same suite against
the deployed endpoint before submission.

If the evaluator creates a random nonexistent resource but expects success while the
contract specifies `404`, record the mismatch as a test defect. Do not silently make
invalid identifiers succeed merely to raise a score.

## Repository shape

A common portable layout:

```text
src/ or service/       application and domain logic
tests/                 unit, boundary, contract, and acceptance tests
infra/                 IaC and infrastructure assertions
data/                  synthetic or approved fixtures
scripts/               validate, deploy, smoke, package, cleanup
docs/                  charter, architecture, ADRs, security, runbook, handoff
reports/                generated evidence, normally ignored except approved artifacts
```

Do not force this layout when the repository already has a coherent structure.

## Engineering expectations

- validate input and fail explicitly;
- keep domain logic testable outside cloud handlers;
- use configuration for model, Region, limits, and thresholds;
- set bounded retries, concurrency, payload, output, and timeout limits;
- do not log credentials, PII, raw video, prompts, or customer payloads by default;
- use structured reason codes and correlation IDs;
- make fallbacks and kill conditions observable;
- include negative authorization and forbidden-resource tests;
- keep credentials out of code, git, reports, and chat.

## Sandbox and identity

Before deployment:

1. obtain explicit authorization for mutation;
2. verify the active account, Region, principal, and environment classification;
3. prefer federated, SSO, or other short-lived credentials;
4. show the IaC diff;
5. confirm no unintended production references, public ingress, destructive retention,
   or broad IAM;
6. establish budget tags and cleanup ownership.

If an existing UAT or development account contains real or poorly masked data, do not
reuse it merely because setup is faster.

## Validation layers

Use evidence layers:

1. unit and boundary tests;
2. local end-to-end execution;
3. infrastructure assertions and synthesis;
4. static analysis and dependency/security checks;
5. live sandbox deployment;
6. exact external acceptance suite;
7. customer quality or red-team review;
8. production readiness, which remains a separate phase.

Do not use a deterministic fixture result as a live managed-service quality or latency
claim.

## Live deployment evidence

Record:

- account and Region with sensitive identifiers redacted in presentations;
- commit and artifact/image digest;
- infrastructure diff and stack status;
- model/service/version configuration;
- endpoint, authentication method, and validity window;
- acceptance command and pass/fail count;
- logs, metrics, persisted results, latency, and cost evidence;
- security-group, IAM, and data-boundary verification;
- cleanup or ownership-transfer status.

Expose only the approved public endpoint. Do not submit an internal load balancer,
temporary tunnel, stale token, or path missing the contract's base prefix.

## Scans and finding disposition

When the engagement or certification requires external scans:

- run the named security scanner against the final commit;
- run the named quality rubric, not a generic profile;
- preserve original outputs;
- write one disposition per finding: fixed, accepted, or false positive;
- include rationale, owner, and evidence;
- rerun after fixes so reports match the delivered commit.

Local lint and unit tests do not replace mandatory scans.

## Git and GitHub delivery

Before push or PR:

- verify branch, remote URL, authenticated account, and clean/understood worktree;
- pull or fetch the target branch and inspect divergence;
- use a task branch, not direct edits on the default branch;
- run relevant tests and validation on the delivery host;
- inspect the final diff for credentials, generated files, unrelated changes, and
  customer data;
- commit a coherent change with a clear message;
- push the branch and create a PR with scope, validation, boundaries, and residual
  risks.

Prefer an existing authenticated GitHub CLI or credential helper. Do not paste or
persist tokens from chat.

## Handoff

The customer should be able to:

- locate entry points and configuration;
- run local tests and the sample;
- deploy and destroy the sandbox;
- integrate through documented contracts;
- add a scenario, language, model, or adapter;
- repeat quality and safety evaluation;
- replace provider-specific components;
- understand cost and operational limits;
- identify who owns productionization and incidents.

Provide a continuation table:

```text
change | customer owner | code entry point | test evidence |
approval | risk | rollback
```

## Cleanup and closure

At acceptance or termination:

- disable or rotate temporary endpoint credentials;
- export approved evidence;
- delete synthetic/test data, caches, indexes, and temporary logs as agreed;
- revoke project roles, trust, and network rules;
- destroy or transfer cloud resources;
- confirm no residual cost, public endpoint, or credential;
- preserve a cleanup record.

Do not state that token revocation automatically deleted historical data or logs.

## Final report

Report:

- what was built and why;
- actual tests and results;
- measured quality, latency, safety, and cost;
- deviations, failures, and accepted risk;
- scope not delivered;
- production gaps and owners;
- handoff and cleanup status;
- the customer's next decision.

Use precise language: "PoC evidence supports proceeding" is not "production-ready" or
"business outcome achieved."
