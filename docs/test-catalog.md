# GUIDO Test Type Catalog

Complete reference of all test types organized by the GUIDO SDD Engineering Stack layers.

---

## Functional Tests

| Type | Layer | What It Verifies | Tool | When It Runs |
|------|-------|-----------------|------|-------------|
| **Unit** | Execution | A single function or method in isolation | xUnit | On every push |
| **Integration** | Execution | Two or more modules interacting | xUnit + mocks | On every push |
| **Component** | Execution | A UI component in isolation | Selenium + PageObject | On PR |
| **E2E (End-to-End)** | Execution | A complete user journey | Selenium + SpecFlow | On PR + nightly |
| **Contract** | Execution | API response matches its declared contract | RestAssured / Pact | On PR |
| **Acceptance (UAT)** | Intent + Execution | Business criteria are met | SpecFlow + Gherkin | Pre-release |
| **Regression** | Governance | No previously working feature has broken | Full suite | Nightly |
| **Smoke** | Governance | Critical paths are operational | @smoke subset | Every push |
| **Sanity** | Governance | A specific fix has not broken adjacent behavior | @sanity subset | Post-hotfix |

---

## Non-Functional Tests

| Type | Layer | What It Verifies | Tool | Threshold |
|------|-------|-----------------|------|-----------|
| **Performance / Load** | Platform | Response time under expected load | K6 | p95 < 500ms |
| **Stress** | Platform | Behavior at capacity limits | K6 | System recovers gracefully |
| **Spike** | Platform | Behavior under sudden traffic surge | K6 | No data loss |
| **Soak / Endurance** | Platform | Stability over extended time periods | K6 | No memory leaks |
| **Security / DAST** | Platform | Runtime vulnerabilities | OWASP ZAP | 0 critical findings |
| **Accessibility** | Execution | WCAG 2.1 AA compliance | Axe + Selenium | 0 critical violations |
| **Compatibility** | Execution | Cross-browser and cross-device behavior | Selenium Grid / BrowserStack | Defined matrix passes |
| **Usability** | Knowledge | UX quality — measurable heuristics | Heuristic reviews + metrics | Defined rubric |

---

## Specialized Tests

| Type | What It Verifies | Tool | When to Use |
|------|-----------------|------|-------------|
| **Visual Regression** | Unexpected UI changes between versions | Applitools / Percy | On UI-heavy features |
| **Mutation** | Quality of the unit tests themselves | Stryker.NET | Quarterly audits |
| **Chaos / Resilience** | System behavior when dependencies fail | Chaos patterns | Pre-major releases |
| **A/B** | Behavioral differences between two versions | Feature flags | Active experiments |
| **Shadow** | New system matches old system output | Parallel execution | System migrations |
| **Canary** | Gradual rollout is behaving correctly | DevOps pipelines | Phased releases |

---

## AI-Agentic Tests (New Category)

These test types emerge in the GUIDO Agentic extension of the framework:

| Type | What It Verifies | Layer | Why It Matters |
|------|-----------------|-------|----------------|
| **Spec Coverage** | Every spec has a corresponding implementation | Governance | Core GUIDO metric |
| **Intent Drift** | Code has not diverged from the spec's declared intent | Governance | Detects silent regressions |
| **Agent Output Validation** | AI-generated code meets the spec contract | Execution | Human gate on agent work |
| **Hallucination Detection** | Agent has not invented behavior not in spec | Intent | Prevents silent contract violations |
| **Prompt Regression** | A prompt change has not broken agent outputs | Platform | LLMOps quality gate |

---

## GUIDO Scale — Test Requirements by Level

| Level | Required Test Types |
|-------|-------------------|
| **1 — Initial** | Smoke |
| **2 — Defined** | Smoke, Regression |
| **3 — Managed** | Smoke, Regression, Integration, Contract |
| **4 — Optimized** | All of Level 3 + Performance, Security/DAST |
| **5 — Autonomous** | All of Level 4 + Agent-generated, Self-healing, Spec Coverage |

---

## Test Type Selection Guide

When deciding which test types to implement, use this decision tree:

```
Does it test a single function in isolation?
  → Yes → Unit Test

Does it test interaction between internal modules?
  → Yes → Integration Test

Does it test a full user journey through the UI?
  → Yes → E2E Test (Selenium + SpecFlow)

Does it test an API endpoint's contract?
  → Yes → Contract Test (RestAssured)

Does it validate business language criteria?
  → Yes → Acceptance Test (Gherkin)

Does it measure response time under load?
  → Yes → Performance Test (K6)

Does it check for security vulnerabilities at runtime?
  → Yes → Security/DAST Test (OWASP ZAP)

Does it check that nothing has broken?
  → Yes → Regression (full suite tag)

Does it verify the fastest possible health check?
  → Yes → Smoke Test (@smoke tag)
```
