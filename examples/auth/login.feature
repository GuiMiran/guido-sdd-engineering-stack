@smoke @auth @p1
Feature: User Authentication
  # INTENT: Validate all entry-point behaviors of the authentication system.
  # Every access to the application passes through this gate.
  # A failure here blocks the entire user journey.
  # CONTEXT: examples/auth/login.context.md
  # DATA: examples/auth/login.data.json

  Background:
    Given the browser is at "{BaseUrl}"

  # ─── HAPPY PATH ───────────────────────────────────────────────────────────

  @happy-path
  Scenario: Standard user authenticates and lands on inventory
    # === INTENT ===
    # Verify that a valid user can log in and reach the expected landing page.
    # This is the baseline contract for all authenticated flows.

    # === CONTEXT ===
    # URL: https://www.saucedemo.com (login form is the root page)
    # Pre-state: no active session

    # === LOCATORS ===
    # Username: #user-name (input, always visible)
    # Password: #password (input, always visible)
    # Button:   #login-button (submit)

    # === DATA ===
    # Profile: standard_user → see login.data.json

    # === ACCEPTANCE ===
    # URL contains "/inventory.html"
    # Element ".title" displays exactly "Products"

    When the user authenticates with profile "standard_user"
    Then the current URL contains "/inventory.html"
    And the element ".title" displays "Products"

  # ─── NEGATIVE PATHS ───────────────────────────────────────────────────────

  @negative @p1
  Scenario: Locked-out user is denied access
    # === INTENT ===
    # Verify that a blocked account receives an explicit denial message.
    # Silent failures here create a security and UX risk.

    # === ACCEPTANCE ===
    # Error banner visible, contains "locked out"

    When the user authenticates with profile "locked_out_user"
    Then the error banner ".error-message-container" contains "locked out"

  @negative @p2
  Scenario: User with wrong password sees error
    # === INTENT ===
    # Verify that an invalid credential attempt does not leak information
    # and displays the standard error message.

    # === ACCEPTANCE ===
    # Error banner visible, contains "Username and password do not match"

    When the user authenticates with profile "wrong_password_user"
    Then the error banner ".error-message-container" contains "Username and password do not match"

  @negative @p2
  Scenario: User submits empty credentials
    # === INTENT ===
    # Verify client-side validation fires before any server call.
    # Empty submissions must never reach the auth backend.

    # === ACCEPTANCE ===
    # Error banner visible, contains "Username is required"

    When the user submits the login form without credentials
    Then the error banner ".error-message-container" contains "Username is required"

  # ─── EDGE CASES ───────────────────────────────────────────────────────────

  @negative @p2
  Scenario: Problem user can log in but session state is flagged
    # === INTENT ===
    # problem_user reaches inventory but the application exhibits known
    # visual defects. This scenario verifies access is granted —
    # defect detection is handled by dedicated @visual tests.

    When the user authenticates with profile "problem_user"
    Then the current URL contains "/inventory.html"

  @regression @p1
  Scenario: Performance glitch user experiences slow login but succeeds
    # === INTENT ===
    # performance_glitch_user has an artificial delay injected server-side.
    # Login must still complete within the SLA defined in login.data.json.

    When the user authenticates with profile "performance_glitch_user"
    Then the current URL contains "/inventory.html"
