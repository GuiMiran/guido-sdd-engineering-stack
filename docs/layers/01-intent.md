# Layer 1: Intent

> *The spec is the contract. Everything else is implementation.*

---

## Purpose

The Intent Layer is where quality knowledge originates. It answers two questions before a single line of code is written:

- **What** behavior does the system need to exhibit?
- **Why** does this behavior matter to the business?

If a behavior is not declared in the Intent Layer, it does not exist as verifiable quality.

---

## Artifacts

### 1. Feature File (`.feature`)

The Gherkin spec. Written in business language. Owned by QA Engineering.

```gherkin
@smoke @auth @p1
Feature: User Authentication
  # INTENT: Validate all entry-point behaviors of the authentication system
  # CONTEXT: specs/auth/login.context.md
  # DATA: specs/auth/login.data.json

  Background:
    Given the application is loaded at "{BaseUrl}"

  @happy-path
  Scenario: Standard user accesses inventory after login
    When the user authenticates with profile "standard_user"
    Then the current URL contains "/inventory.html"
    And the element ".title" displays "Products"

  @negative
  Scenario: Locked user is denied access
    When the user authenticates with profile "locked_out_user"
    Then the error banner contains "locked out"
```

#### Spec Quality Levels

| Level | Description | AI-Executable |
|-------|-------------|---------------|
| **0 — Vibe** | "Login works" — no verifiable contract | ❌ |
| **1 — POM** | Steps without technical anchors | ⚠️ |
| **2 — SDD** | Verified locators, explicit data, exact expected state | ✅ |
| **3 — GUIDO SDD** | Level 2 + intent comments + context reference + tags | ✅✅ |

**Always write Level 3 specs.** They are the only format that supports agentic execution without hallucination risk.

---

### 2. Context File (`.context.md`)

The domain knowledge file. Consumed by humans writing step definitions and by AI agents generating code.

```markdown
# [Feature] — Context File

## Stack
- Framework: SpecFlow 3.9 + xUnit + C#
- Pattern: Page Component Model
- Driver Management: WebDriverManager

## URLs
- Staging: https://staging.app.com
- Production: Variable BaseUrl (from ConfigManager)

## Verified Locators
| Element        | Selector              | Type  | Notes          |
|----------------|-----------------------|-------|----------------|
| Username field | #user-name            | id    | Always visible |
| Password field | #password             | id    | Always visible |
| Login button   | #login-button         | id    | Submit trigger |
| Error banner   | .error-message-container | class | Conditional  |

## Test Profiles
| Key              | Username           | Password     | Expected Behavior |
|------------------|--------------------|--------------|-------------------|
| standard_user    | standard_user      | secret_sauce | Normal login      |
| locked_out_user  | locked_out_user    | secret_sauce | Denied — error    |

## Generation Rules (for AI agents)
1. PageObject → /Pages/Auth/LoginPage.cs
2. Steps → /StepDefinitions/Auth/LoginSteps.cs
3. Assertions → FluentAssertions only
4. If locator not listed above → DO NOT INVENT — ask for verification
```

**The context file is the contract between QA Engineer and AI Agent.** A locator not in this file must not appear in generated code.

---

### 3. Data File (`.data.json`)

Typed, structured test data. No hardcoded values in specs or code.

```json
{
  "profiles": {
    "standard_user": {
      "username": "standard_user",
      "password": "secret_sauce",
      "expectedLandingUrl": "/inventory.html",
      "expectedPageTitle": "Products"
    },
    "locked_out_user": {
      "username": "locked_out_user",
      "password": "secret_sauce",
      "expectedError": "locked out"
    }
  },
  "urls": {
    "base": "https://www.saucedemo.com",
    "login": "/",
    "inventory": "/inventory.html",
    "cart": "/cart.html"
  }
}
```

---

## The Intent Comment Block

Every scenario should include an intent block in comments:

```gherkin
Scenario: [verb] [subject] [condition] [outcome]

  # === INTENT ===
  # What business behavior this protects
  # Why it exists — what decision it safeguards

  # === CONTEXT ===
  # URL / auth / pre-existing state

  # === LOCATORS ===
  # Element: selector (type)

  # === DATA ===
  # Source: data file key or inline

  # === ACCEPTANCE ===
  # Exact verifiable success condition
```

---

## Tag Taxonomy

Tags enable filtering, pipeline gates, and governance reporting.

```
@smoke        → Critical happy paths. Run on every push.
@regression   → Full suite. Run nightly.
@negative     → Error paths and boundary conditions.
@p1           → Priority 1 — business-critical.
@p2           → Priority 2 — important but not blocking.
@wip          → Work in progress — excluded from pipeline gates.
@manual       → Cannot be automated — tracked for coverage.
@[module]     → Feature area: @auth, @inventory, @cart, @checkout
```

---

## Ownership

The Intent Layer is **always owned by the QA Engineer**, never by AI.

An AI agent may suggest scenario completions or flag coverage gaps, but the business intent — the *why* — requires human judgment. This is what the GUIDO framework means by Governed quality knowledge.
