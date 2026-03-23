# Layer 3: Governance

> *What gets measured gets governed. What gets governed gets improved.*

---

## Purpose

The Governance Layer answers: **Is our quality knowledge complete, accurate, and enforced?**

It translates execution results into decisions — whether a build can ship, whether coverage is acceptable, whether the system has regressed.

---

## GUIDO Scale Integration

Every pipeline run produces a GUIDO Scale score based on the following gates:

| Level | Gate | Criteria |
|-------|------|----------|
| **1 — Initial** | Suite executes | At least one test runs and reports |
| **2 — Defined** | Pass rate ≥ 80% | Less than 20% of tests failing |
| **3 — Managed** | Pass rate ≥ 90% + coverage gap < 20% | Spec coverage measured and gated |
| **4 — Optimized** | + SLA met + 0 critical security issues | Performance and security gates active |
| **5 — Autonomous** | + Agent generates + Self-heals | No human intervention required per sprint |

---

## Coverage Gates

A spec coverage gap occurs when a scenario exists in a `.feature` file but has no corresponding step implementation, or when a step implementation has no scenario.

**Thresholds by tag:**

```
@smoke scenarios     → 100% coverage required. Hard gate.
@p1 scenarios        → 95% coverage required. Hard gate.
@p2 scenarios        → 80% coverage required. Soft gate (warning).
@regression suite    → 90% pass rate. Hard gate before release.
```

---

## Quality Thresholds

| Metric | Threshold | Action on breach |
|--------|-----------|------------------|
| Smoke pass rate | 100% | Block merge |
| Regression pass rate | ≥ 90% | Block release |
| Coverage gap | < 20% | Warning in PR |
| Performance p95 | < 500ms | Block release |
| Critical security findings | 0 | Block release |
| High security findings | ≤ 2 | Warning |

---

# Layer 4: Platform

> *The pipeline is the delivery mechanism of quality.*

---

## Purpose

The Platform Layer defines where, when, and how verification runs. It ensures tests are not a local-only concern but a continuous, automated, and reproducible activity.

---

## GitHub Actions — Reference Pipeline

```yaml
name: GUIDO SDD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 2 * * *'   # nightly regression at 2am

jobs:
  smoke:
    name: Smoke Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.x'

      - name: Restore
        run: dotnet restore

      - name: Run Smoke Tests
        run: |
          dotnet test --filter "Category=smoke" \
            --logger "trx;LogFileName=smoke-results.trx" \
            --results-directory ./test-results
        env:
          BaseUrl: ${{ secrets.STAGING_URL }}
          Browser: chrome
          Headless: true

      - name: Generate Allure Report
        if: always()
        run: |
          npm install -g allure-commandline
          allure generate allure-results --clean -o allure-report

      - name: Publish Report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: allure-report
          path: allure-report/

  regression:
    name: Full Regression
    runs-on: ubuntu-latest
    if: github.event_name == 'schedule'
    steps:
      - uses: actions/checkout@v4
      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '8.x'
      - name: Run Full Suite
        run: dotnet test --logger "trx" --results-directory ./test-results
        env:
          BaseUrl: ${{ secrets.STAGING_URL }}
          Browser: chrome
          Headless: true
```

---

## Azure DevOps — Reference Pipeline

```yaml
trigger:
  - main
  - develop

pool:
  vmImage: 'ubuntu-latest'

variables:
  buildConfiguration: 'Release'

stages:
  - stage: Smoke
    jobs:
      - job: SmokeSuite
        steps:
          - task: UseDotNet@2
            inputs:
              version: '8.x'
          - script: dotnet restore
          - script: |
              dotnet test --filter "Category=smoke" \
                --logger "trx;LogFileName=results.trx" \
                --results-directory $(Agent.TempDirectory)
            env:
              BaseUrl: $(STAGING_URL)
              Browser: chrome
              Headless: true
          - task: PublishTestResults@2
            inputs:
              testResultsFormat: 'VSTest'
              testResultsFiles: '**/*.trx'
```

---

## Docker — Test Runner Image

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0

RUN apt-get update && apt-get install -y \
    chromium-browser \
    chromium-chromedriver \
    nodejs npm

RUN npm install -g allure-commandline

WORKDIR /app
COPY . .

RUN dotnet restore

CMD ["dotnet", "test", "--logger", "trx"]
```

---

# Layer 5: Knowledge

> *A spec that is not maintained is a liability. A spec that is updated automatically is an asset.*

---

## Purpose

The Knowledge Layer ensures quality knowledge does not become stale. It transforms test execution results into **living documentation** — specs that reflect the current actual behavior of the system.

---

## Allure Report Configuration

`allureConfig.json`:
```json
{
  "allure": {
    "directory": "allure-results",
    "title": "GUIDO SDD Test Report",
    "links": [
      "https://github.com/GuiMiran/{issue}"
    ]
  }
}
```

Enriched step definitions:
```csharp
[Then(@"the dashboard should display ""(.*)""")]
[AllureStep("Verify welcome message: {message}")]
public void ThenDashboardDisplays(string message)
{
    AllureApi.AddAttachment(
        "Screenshot",
        "image/png",
        ScreenshotHelper.TakeBytes(Driver)
    );

    _dashboardPage.GetWelcomeMessage()
        .Should().Contain(message,
            because: $"authenticated user should see personalized greeting");
}
```

---

## Living Documentation

When SpecFlow + Allure are combined, passing scenarios become **verified documentation**. A scenario marked `[Passed]` in Allure is proof that the system behaves as the spec declared.

This is the Knowledge Layer's core value: **the spec is always true because it is continuously verified.**

---

## Context File Maintenance

Context files (`.context.md`) should be updated whenever:
- A locator changes in the application under test
- A new test profile is added
- A URL changes
- A new module is added to scope

In the agentic model, the self-healing pipeline detects locator failures and proposes context file updates as part of its repair output.

---

## GUIDO Scale Score Report

Every pipeline run produces a score card:

```
═══════════════════════════════════════
  GUIDO SDD SCORE CARD
═══════════════════════════════════════
  Run date:     2025-03-23 02:14 UTC
  Branch:       main
  Environment:  staging

  Smoke pass rate:      100% ✅
  Regression pass rate:  94% ✅
  Spec coverage gap:     12% ✅
  Performance p95:      312ms ✅
  Critical security:      0  ✅

  ─────────────────────────────────────
  GUIDO Scale Level:  4 — OPTIMIZED ✅
═══════════════════════════════════════
```
