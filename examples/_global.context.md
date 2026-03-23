# _global.context.md — Shared Context

Global context consumed by all agents and step definitions in this project.

---

## Project

**Application Under Test:** SauceDemo  
**URL:** https://www.saucedemo.com  
**Purpose:** Reference E2E implementation of the GUIDO SDD Engineering Stack

---

## Stack

| Component | Technology |
|-----------|-----------|
| Language | C# (.NET 8) |
| BDD Framework | SpecFlow 3.9 |
| Test Runner | xUnit |
| UI Automation | Selenium WebDriver 4.x |
| Driver Management | WebDriverManager (no manual drivers) |
| Assertions | FluentAssertions |
| Reporting | Allure |
| Pattern | Page Component Model |

---

## Hard Rules for Code Generation

1. `NEVER` use `Thread.Sleep` — only `WebDriverWait` or `FluentWait`
2. `NEVER` hardcode URLs — use `ConfigManager.Get("BaseUrl")`
3. `NEVER` hardcode credentials — reference `.data.json` profiles
4. `NEVER` generate a step without a `.feature` backing it
5. `NEVER` use a locator not listed in the feature's `.context.md`
6. `ALWAYS` use `FluentAssertions` — never `Assert.True` / `Assert.Equal`
7. `ALWAYS` take a screenshot on `AfterScenario` when test fails
8. `ALWAYS` extend `BasePage` for all page objects

---

## File Conventions

| Artifact | Location |
|----------|---------|
| Page Objects | `/src/[Project].Tests/Pages/[Module]Page.cs` |
| Components | `/src/[Project].Tests/Pages/Components/[Name]Component.cs` |
| Step Definitions | `/src/[Project].Tests/StepDefinitions/[Module]Steps.cs` |
| Feature Files | `/specs/[module]/[feature].feature` |
| Context Files | `/specs/[module]/[feature].context.md` |
| Data Files | `/specs/[module]/[feature].data.json` |

---

## Shared Modules in Scope

| Module | URL Path | Context File |
|--------|---------|-------------|
| Auth | `/` | specs/auth/login.context.md |
| Inventory | `/inventory.html` | specs/inventory/inventory.context.md |
| Cart | `/cart.html` | specs/cart/cart.context.md |
| Checkout | `/checkout-step-one.html` | specs/checkout/checkout.context.md |

---

## If a Locator Is Not in the Context File

**DO NOT invent or guess a locator.**

Respond with:
```
⚠ LOCATOR NOT VERIFIED: [element description]
I need confirmation of the CSS/ID selector before generating code.
Please add it to [feature].context.md and re-run.
```

This is a hard constraint. Invented locators break tests silently.
