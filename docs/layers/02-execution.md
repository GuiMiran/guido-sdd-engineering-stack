# Layer 2: Execution

> *The spec is the input. The test is the proof.*

---

## Purpose

The Execution Layer converts intent into automated verification. Every tool in this layer operates under one constraint: **it must be traceable back to a spec in the Intent Layer.**

Code that exists without a spec is technical debt. A step definition without a scenario is a ghost.

---

## Technology Stack

### UI Automation — Selenium + SpecFlow + C#

**Framework pattern:** Page Component Model

```
BasePage (abstract)
    └── LoginPage : BasePage
    └── InventoryPage : BasePage
            └── NavBarComponent : BasePage
            └── CartIconComponent : BasePage
```

**Hard rules:**
- `NEVER` use `Thread.Sleep` — only `WebDriverWait` / `FluentWait`
- `NEVER` hardcode URLs or credentials — use `ConfigManager`
- `NEVER` write a Step Definition without a `.feature` backing it
- `ALWAYS` use `FluentAssertions` for assertions
- `ALWAYS` take a screenshot on test failure

**NuGet stack:**
```
Selenium.WebDriver
Selenium.Support
WebDriverManager
SpecFlow
SpecFlow.xUnit
xunit
FluentAssertions
Allure.SpecFlow
Microsoft.Extensions.Configuration.Json
```

---

### API Testing — RestAssured.Net

For contract testing and API-layer validation below the UI.

```csharp
var response = await RestAssured
    .Given()
        .BaseUri("https://api.example.com")
        .Header("Authorization", $"Bearer {token}")
    .When()
        .Get("/users/1")
    .Then()
        .StatusCode(200)
        .Body("$.name", NHamcrest.Is.EqualTo("John"))
    .Extract()
        .Response();
```

---

### Performance Testing — K6

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '1m', target: 50 },   // ramp up
    { duration: '3m', target: 50 },   // sustained load
    { duration: '1m', target: 0  },   // ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // 95% of requests under 500ms
    http_req_failed:   ['rate<0.01'],  // less than 1% errors
  },
};
```

---

### Security Testing — OWASP ZAP

Integrated as a pipeline step for DAST (Dynamic Application Security Testing):

```yaml
- name: OWASP ZAP Baseline Scan
  uses: zaproxy/action-baseline@v0.10.0
  with:
    target: ${{ env.STAGING_URL }}
    fail_action: true
    rules_file_name: '.zap/rules.tsv'
```

---

## Project Structure

```
src/[Project].Tests/
├── Core/
│   ├── BrowserFactory.cs      ← WebDriver creation
│   ├── BasePage.cs            ← shared page methods
│   ├── ConfigManager.cs       ← reads appsettings.json
│   └── Hooks.cs               ← SpecFlow setup/teardown
├── Pages/
│   ├── Components/            ← reusable UI components
│   └── [Module]Page.cs
├── StepDefinitions/
│   └── [Module]Steps.cs
├── Features/                  ← symlink or copy from /specs
├── Helpers/
│   ├── WaitHelper.cs
│   └── ScreenshotHelper.cs
├── Models/
│   └── [Entity]Model.cs
└── TestData/
    └── [feature].data.json
```
