# GUIDO SDD Engineering Stack — Architecture Overview

## The Core Principle

```
Traditional QA:    Build → Test → Fix → Ship
GUIDO SDD:         Define → Verify → Execute → Govern → Ship
```

Quality is not a phase. It is a **knowledge system** that runs parallel to development from day one.

---

## System Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                        KNOWLEDGE LAYER                           │
│                                                                  │
│   .feature files    .context.md files    .data.json files        │
│   (the contracts)   (domain knowledge)   (test inputs)           │
└───────────────────────────┬──────────────────────────────────────┘
                            │ feeds
┌───────────────────────────▼──────────────────────────────────────┐
│                         INTENT LAYER                             │
│                                                                  │
│   Gherkin scenarios define WHAT and WHY                          │
│   Human QA Engineers own this layer                              │
│   AI Agents consume this layer                                   │
└───────────────────────────┬──────────────────────────────────────┘
                            │ generates
┌───────────────────────────▼──────────────────────────────────────┐
│                        EXECUTION LAYER                           │
│                                                                  │
│   UI Tests          API Tests         Performance    Security    │
│   Selenium+SpecFlow RestAssured       K6             OWASP ZAP  │
└───────────────────────────┬──────────────────────────────────────┘
                            │ measured by
┌───────────────────────────▼──────────────────────────────────────┐
│                       GOVERNANCE LAYER                           │
│                                                                  │
│   GUIDO Scale Score    Coverage Gates    Quality Thresholds      │
│   Spec Coverage %      Intent Drift      Pass Rate               │
└───────────────────────────┬──────────────────────────────────────┘
                            │ runs on
┌───────────────────────────▼──────────────────────────────────────┐
│                        PLATFORM LAYER                            │
│                                                                  │
│   Azure DevOps / GitHub Actions    Docker    Cloud Environments  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Standard SDD Flow

```
User Story
    │
    ▼
QA Engineer writes .feature (Gherkin)
    │
    ▼
QA Engineer writes .context.md (locators, domain rules)
    │
    ▼
QA Engineer writes .data.json (test profiles, inputs)
    │
    ▼
Developer implements the feature
    │
    ▼
Step Definitions written (manual or agent-generated)
    │
    ▼
Pipeline runs: CI/CD executes the specs
    │
    ▼
Governance Layer measures: GUIDO Scale score updated
    │
    ▼
Allure Report published: living documentation
```

### Agentic SDD Flow

```
QA Lead writes GUIDO-level 3 spec
    │
    ▼
Agent reads .feature + .context.md + .data.json
    │
    ▼
Agent generates Step Definitions + Page Objects
    │
    ▼
QA Lead reviews generated code (governance gate)
    │
    ▼
Pipeline runs: tests execute
    │
    ▼
If failure → Agent analyzes → proposes fix as PR comment
    │
    ▼
GUIDO Scale score auto-calculated
```

---

## The Role of the QA Engineer in GUIDO

GUIDO does not eliminate the QA Engineer. It **elevates** the role.

| Activity | Pre-GUIDO | In GUIDO |
|----------|-----------|---------|
| Writing test scripts | Manual, repetitive | Delegated to agent |
| Defining intent | Informal, implicit | Explicit, spec-driven |
| Governing quality | Reactive | Proactive via gates |
| Documenting behavior | Manual, often skipped | Auto-generated from specs |
| Maintaining tests | Manual, expensive | Self-healing via agent |

The QA Engineer becomes a **Quality Knowledge Architect** — owning the intent, governing the outputs, and ensuring the spec system reflects business reality.

---

## Spec File Structure

Every feature in GUIDO has three files:

```
specs/[module]/
├── [feature].feature       ← the contract (Gherkin)
├── [feature].context.md    ← domain knowledge for humans and agents
└── [feature].data.json     ← typed test data
```

Plus a global shared context:

```
specs/
└── _global.context.md      ← base URL, auth patterns, shared rules
```

---

## Integration Points

```
GitHub / Azure DevOps
        │
        ├── on: push → run-tests.yml (full suite)
        ├── on: PR   → smoke-tests.yml (fast feedback)
        └── on: schedule → regression.yml (nightly full run)
                │
                ▼
        Test Runner (SpecFlow + xUnit)
                │
                ▼
        Allure Results collected
                │
                ▼
        GUIDO Scale score calculated
                │
                ▼
        Report published as pipeline artifact
```

---

## Anti-Patterns GUIDO Prevents

| Anti-Pattern | How GUIDO Prevents It |
|---|---|
| Vibe coding tests | Spec must exist before code |
| Hardcoded waits (`Thread.Sleep`) | BasePage enforces explicit waits only |
| Tests with no business meaning | Intent comments required in spec |
| Locators invented by AI | Context files validate all locators |
| Coverage gaps undiscovered | Governance layer measures spec coverage |
| Documentation that goes stale | Living docs generated from passing specs |
