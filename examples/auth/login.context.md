# Auth / Login — Context File

> Consumed by: QA Engineers writing step definitions, AI agents generating code.
> Authority: This file is the single source of truth for the login module.
> A locator or rule not listed here MUST NOT appear in generated code.

---

## Stack

| Component         | Technology                        |
|-------------------|-----------------------------------|
| Language          | C# (.NET 8)                       |
| BDD Framework     | SpecFlow 3.9                      |
| Test Runner       | xUnit                             |
| UI Automation     | Selenium WebDriver 4.x            |
| Driver Management | WebDriverManager (no manual)      |
| Assertions        | FluentAssertions                  |
| Reporting         | Allure.SpecFlow                   |
| Pattern           | Page Component Model              |

---

## URLs

| Environment | URL                              |
|-------------|----------------------------------|
| Reference   | https://www.saucedemo.com        |
| Staging     | Variable — `ConfigManager.Get("BaseUrl")` |

---

## Verified Locators

All selectors verified against the live SauceDemo DOM on 2026-04-19.

| Element              | Selector                    | Type  | Visibility      |
|----------------------|-----------------------------|-------|-----------------|
| Username field       | `#user-name`                | id    | Always visible  |
| Password field       | `#password`                 | id    | Always visible  |
| Login button         | `#login-button`             | id    | Always visible  |
| Error banner         | `.error-message-container`  | class | Conditional     |
| Error text           | `[data-test="error"]`       | attr  | Inside banner   |
| Page title           | `.title`                    | class | Post-login only |

---

## Test Profiles

Profiles map to keys in `login.data.json`.

| Profile Key               | Expected Behavior                          | GUIDO Gate  |
|---------------------------|--------------------------------------------|-------------|
| `standard_user`           | Login succeeds → `/inventory.html`         | @smoke @p1  |
| `locked_out_user`         | Login denied → error banner shown          | @negative @p1 |
| `wrong_password_user`     | Login denied → credential mismatch error   | @negative @p2 |
| `problem_user`            | Login succeeds → defects in inventory UI   | @regression |
| `performance_glitch_user` | Login succeeds with artificial delay       | @regression @p1 |
| `error_user`              | Login succeeds → random API errors in app  | @regression |

---

## Page Objects

| Class          | Location                                              |
|----------------|-------------------------------------------------------|
| `LoginPage`    | `/src/[Project].Tests/Pages/Auth/LoginPage.cs`        |
| `InventoryPage`| `/src/[Project].Tests/Pages/Inventory/InventoryPage.cs` |

### LoginPage — Required Methods

```csharp
// All methods must use WebDriverWait, never Thread.Sleep
void EnterUsername(string username)
void EnterPassword(string password)
void ClickLoginButton()
void LoginWithProfile(UserProfile profile)     // orchestrates the three above
string GetErrorMessage()                        // returns text from [data-test="error"]
bool IsErrorBannerVisible()
```

---

## Step Definition Location

```
/src/[Project].Tests/StepDefinitions/Auth/LoginSteps.cs
```

---

## Generation Rules for AI Agents

1. PageObject target → `/src/[Project].Tests/Pages/Auth/LoginPage.cs`
2. Steps target → `/src/[Project].Tests/StepDefinitions/Auth/LoginSteps.cs`
3. Use `FluentAssertions` exclusively — never `Assert.True` / `Assert.Equal`
4. All waits → `WebDriverWait` with timeout from `ConfigManager.Get("DefaultTimeoutSeconds")`
5. On `AfterScenario` failure → call `ScreenshotHelper.TakeScreenshot(scenario.ScenarioInfo.Title)`
6. Data binding → deserialize from `login.data.json` via `TestDataHelper.Load<LoginData>()`
7. If a locator is not in this file → **DO NOT invent it**

If a locator is missing, respond with:
```
⚠ LOCATOR NOT VERIFIED: [element description]
Add the verified selector to examples/auth/login.context.md before generating code.
```

---

## Known Constraints

- `performance_glitch_user` introduces a server-side delay of 1–5 seconds — set `DefaultTimeoutSeconds` ≥ 10 for this profile
- `problem_user` renders broken images in inventory — do not fail auth tests on visual defects
- The error banner is injected into the DOM only after a failed attempt — do not assert its absence on page load

---

## Coverage Map

| Scenario Tag     | Step Definition Method     | Data Key                  |
|------------------|----------------------------|---------------------------|
| `@happy-path`    | `LoginWithProfile`         | `standard_user`           |
| `@negative @p1`  | `LoginWithProfile`         | `locked_out_user`         |
| `@negative @p2`  | `LoginWithProfile`         | `wrong_password_user`     |
| `@negative @p2`  | `SubmitEmptyForm`          | — (no data needed)        |
| `@regression`    | `LoginWithProfile`         | `problem_user`            |
| `@regression @p1`| `LoginWithProfile`         | `performance_glitch_user` |
