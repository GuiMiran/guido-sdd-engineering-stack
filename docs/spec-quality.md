# GUIDO Spec Quality Guide

How to write specs that are verifiable by humans and executable by AI agents.

---

## The 4 Levels

### Level 0 — Vibe Spec ❌
```gherkin
Scenario: Login works
  Given the user logs in
  Then it works
```
No locators. No data. No expected state. An agent cannot execute this. A human cannot verify it.

---

### Level 1 — POM Spec ⚠️
```gherkin
Scenario: Successful login
  Given the user is on the login page
  When the user enters valid credentials
  Then the user sees the dashboard
```
Better. But "valid credentials" and "sees the dashboard" are ambiguous. An agent will guess. A human will interpret inconsistently.

---

### Level 2 — SDD Spec ✅
```gherkin
Scenario: Standard user logs in successfully
  Given the browser is at "https://www.saucedemo.com"
  When the user types "standard_user" in "#user-name"
  And the user types "secret_sauce" in "#password"
  And the user clicks "#login-button"
  Then the current URL contains "/inventory.html"
  And the element ".title" displays "Products"
```
All locators specified. All data explicit. Expected state is exact and verifiable.

---

### Level 3 — GUIDO SDD Spec ✅✅
```gherkin
@smoke @auth @p1
Scenario: Standard user accesses inventory after login

  # === INTENT ===
  # Validates the primary authentication happy path.
  # Protects the decision: authenticated users can reach inventory.

  # === CONTEXT ===
  # URL: https://www.saucedemo.com
  # Auth: standard_user profile (see login.data.json)
  # Pre-state: no active session

  # === LOCATORS ===
  # username: #user-name (id)
  # password: #password (id)
  # submit:   #login-button (id)
  # title:    .title (class)

  # === ACCEPTANCE ===
  # URL = /inventory.html AND .title = "Products"

  Given the application is loaded at "{BaseUrl}"
  When the user authenticates with profile "standard_user"
  Then the current URL contains "/inventory.html"
  And the element ".title" displays "Products"
  And the element ".inventory_list" is visible
```

This is the target format for all GUIDO specs.

---

## Spec Checklist

Before passing a spec to an agent or submitting to review:

```
□ URL or BaseUrl is referenced
□ All locators are in the .context.md file
□ Test data references a .data.json key, not inline values
□ Expected state is exact and verifiable (selector + value or URL)
□ Tags are present: priority, module, test type
□ Intent comment explains the business decision being protected
□ No ambiguous words: "correct", "valid", "works", "appropriate"
```

If any item is unchecked → the spec is not ready for agent execution.

---

## Ambiguity Patterns to Avoid

| Ambiguous | Replace With |
|-----------|-------------|
| "valid credentials" | `profile "standard_user"` |
| "the page loads" | `the element ".inventory_list" is visible` |
| "it works" | `the URL contains "/inventory.html"` |
| "error appears" | `the element "h3[data-test='error']" contains "locked out"` |
| "user is logged in" | `the current URL contains "/inventory.html"` |
| "after a moment" | Remove — use explicit waits in step code |

---

## Scenario Naming Convention

```
[verb] [subject] [condition] [outcome]

✅ Standard user logs in with valid credentials and reaches inventory
✅ Locked user is denied access and sees error message
✅ Empty username field triggers field-specific validation error

❌ Login test
❌ Check that login works
❌ Scenario 1
```

The scenario name should be readable as a sentence in a test report. If it reads like a title, it needs more specificity.

---

## Tag Strategy

```
@smoke      → Runs on every push. Must be fast (<2 min total).
@regression → Runs nightly. Full behavioral coverage.
@negative   → Error paths, boundary conditions, invalid inputs.
@p1         → Business-critical. Blocks release if failing.
@p2         → Important but not blocking. Warning on failure.
@wip        → Excluded from gates. Visible in report as skipped.
@manual     → Cannot be automated. Counted in coverage gap metric.
```

Every scenario needs: one priority tag + one module tag + one type tag.

```gherkin
@p1 @auth @smoke    ← priority + module + type
@p2 @cart @negative ← priority + module + type
```
