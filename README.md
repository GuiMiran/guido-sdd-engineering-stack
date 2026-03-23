# GUIDO SDD Engineering Stack

> **G**overned · **U**nified · **I**ntent-Driven · **D**efinition-first · **O**utcomes

A software quality engineering framework that defines how quality knowledge is **declared, executed, governed, deployed, and preserved** in modern software systems — including AI-agentic environments.

---

## What is GUIDO?

GUIDO is not just a testing framework. It is an **epistemologically grounded engineering stack** — a structured answer to the question:

> *How do we know a system works correctly?*

The answer: **Only when a verifiable spec declares it before execution.**

This positions GUIDO within the tradition of **verificationism** — a belief or requirement only holds meaning if it can be empirically verified. In software: a behavior only exists as valid knowledge if there is a spec that defines it and a test that confirms it.

---

## The Acronym

| Letter | Word | Meaning |
|--------|------|---------|
| **G** | Governed | Quality knowledge has rules, layers, and governance |
| **U** | Unified | One source of truth: the spec |
| **I** | Intent-Driven | Knowledge starts from intent, not implementation |
| **D** | Definition-first | If it is not defined, it does not exist |
| **O** | Outcomes | Knowledge is validated through observable, measurable results |

---

## The 5 Layers

```
┌─────────────────────────────────────────────────────┐
│                LAYER 5: KNOWLEDGE                   │
│         Specs · Context Files · Living Docs         │
├─────────────────────────────────────────────────────┤
│                LAYER 4: PLATFORM                    │
│         CI/CD · Containers · Cloud Infra            │
├─────────────────────────────────────────────────────┤
│               LAYER 3: GOVERNANCE                   │
│       GUIDO Scale · Coverage Rules · Gates          │
├─────────────────────────────────────────────────────┤
│               LAYER 2: EXECUTION                    │
│     Selenium · SpecFlow · K6 · OWASP ZAP            │
├─────────────────────────────────────────────────────┤
│                LAYER 1: INTENT                      │
│         Gherkin · Context.md · Data.json            │
└─────────────────────────────────────────────────────┘
```

Each layer has a clear responsibility:

- **Intent** — Why does this test exist? What behavior does it protect?
- **Execution** — How is the behavior verified? What tools run the verification?
- **Governance** — Who decides what quality means? What are the thresholds?
- **Platform** — Where and when does everything run?
- **Knowledge** — How is quality knowledge stored, updated, and shared?

Full layer documentation → [docs/layers/](docs/layers/)

---

## Technology Stack

| Layer | Tools |
|-------|-------|
| **Intent** | Gherkin, `.feature` files, `.context.md`, `.data.json` |
| **Execution** | Selenium WebDriver, SpecFlow, xUnit, RestAssured, K6, OWASP ZAP |
| **Governance** | GUIDO Scale, Coverage Gates, Quality Thresholds |
| **Platform** | Azure DevOps, GitHub Actions, Docker |
| **Knowledge** | Allure Reports, Living Documentation, Context Files |

---

## Philosophical Foundation

GUIDO draws from three epistemological pillars:

**1. Verificationism** (Vienna Circle)
A requirement only has engineering value if it can be transformed into an executable test.

**2. Fallibilism** (Karl Popper)
Tests do not prove a system works — they demonstrate it has not failed under defined conditions. This is why coverage gaps matter.

**3. Distributed Epistemology**
Quality knowledge does not live in one person. It lives in the shared spec system. An AI agent can execute it precisely because it is externalized in a verifiable format.

> *"In the GUIDO Framework, quality knowledge is not assumed — it is declared, verified, and governed."*

---

## Relationship to Other Frameworks

| Framework | Focus | Relationship to GUIDO |
|-----------|-------|----------------------|
| **TMMi** | Process maturity | Complementary — GUIDO adds spec-driven knowledge governance |
| **CMMI** | Organizational capability | Complementary — GUIDO operates at the engineering layer |
| **ISTQB** | Testing vocabulary | Compatible — GUIDO implements ISTQB concepts in a structured stack |
| **BDD/TDD** | Development practices | GUIDO extends BDD with governance, context, and agentic execution |

---

## GUIDO Scale

The companion framework for measuring migration effort and maturity:

→ [guido-sdd-migration-effort-scale](https://github.com/GuiMiran/guido-sdd-migration-effort-scale)

### Maturity Levels and Required Test Types

| Level | Name | Required Tests | Gate |
|-------|------|---------------|------|
| **1** | Initial | Smoke | ≥1 suite executes |
| **2** | Defined | Smoke + Regression | ≥80% pass rate |
| **3** | Managed | + Integration + Contract | ≥90% + coverage gap <20% |
| **4** | Optimized | + Performance + Security | SLA defined + 0 critical vulns |
| **5** | Autonomous | + Agent-generated + Self-healing | Pipeline runs without human intervention |

---

## Test Type Catalog

GUIDO organizes all test types across its layers:

### Functional
`Unit` · `Integration` · `Component` · `E2E` · `Contract` · `Acceptance (UAT)` · `Regression` · `Smoke` · `Sanity`

### Non-Functional
`Performance/Load` · `Stress` · `Spike` · `Soak/Endurance` · `Security/DAST` · `Accessibility` · `Compatibility`

### Specialized
`Visual Regression` · `Mutation` · `Chaos/Resilience` · `A/B` · `Shadow` · `Canary`

### AI-Agentic (new layer)
`Spec Coverage` · `Intent Drift` · `Agent Output Validation` · `Hallucination Detection` · `Prompt Regression`

Full catalog → [docs/test-catalog.md](docs/test-catalog.md)

---

## Agentic Extension

GUIDO is designed for the AI-agentic era. The spec-first philosophy makes it uniquely compatible with AI agents:

- A spec that a human can follow, an agent can execute
- A `.context.md` file gives the agent the domain knowledge it needs
- A `.data.json` file gives it the test data
- Governance rules prevent the agent from inventing behavior

→ Implementation: [guido-agentic-pipeline](https://github.com/GuiMiran/guido-agentic-pipeline)

---

## Spec Quality Levels

| Level | Name | Description | AI-Ready |
|-------|------|-------------|----------|
| 0 | Vibe Spec | "Login works" | ❌ |
| 1 | POM Spec | Steps without technical anchors | ⚠️ |
| 2 | SDD Spec | Verified locators, explicit data, exact expected state | ✅ |
| 3 | GUIDO SDD Spec | Level 2 + intent comments, context file, tagged | ✅✅ |

---

## Getting Started

1. Read the [Architecture Overview](docs/ARCHITECTURE.md)
2. Understand the [5 Layers](docs/layers/)
3. Review the [Spec Quality Guide](docs/spec-quality.md)
4. See a working implementation: [guido-agentic-pipeline](https://github.com/GuiMiran/guido-agentic-pipeline)

---

## Author

**Guido Miranda Mercado**
Senior QA Engineering Leader · AI-Driven Software Quality Strategist

Creator of:
- [GUIDO Scale](https://github.com/GuiMiran/guido-sdd-migration-effort-scale) — Migration effort and maturity model
- [GUIDO SDD Engineering Stack](https://github.com/GuiMiran/guido-sdd-engineering-stack) — This framework
- [GUIDO Agentic Pipeline](https://github.com/GuiMiran/guido-agentic-pipeline) — Reference implementation

[Blog](https://guidomiranda.wordpress.com) · [LinkedIn](https://www.linkedin.com/in/guido-miranda/) · [Dev.to](https://dev.to/guimiran)

---

## License

MIT © Guido Miranda Mercado
