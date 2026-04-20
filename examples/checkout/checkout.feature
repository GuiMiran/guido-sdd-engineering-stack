@regression @checkout @p1
Feature: Checkout Flow
  # INTENT: Validate the complete purchase journey from cart review to order confirmation.
  # This is the highest-value flow in the application — any failure here
  # means zero revenue. Every step, validation, and price calculation must
  # be explicitly verified against declared data.
  # CONTEXT: examples/checkout/checkout.context.md
  # DATA: examples/checkout/checkout.data.json

  Background:
    Given the user is authenticated with profile "standard_user"
    And the user has added products from list "checkout_single" to the cart
    And the user navigates to "/cart.html"

  # ─── CART REVIEW (pre-checkout) ───────────────────────────────────────────

  @smoke @p1
  Scenario: Cart displays correct items before checkout
    # === INTENT ===
    # The cart is the last chance to verify the order before payment.
    # Items, quantities, and prices must exactly match what was added.

    # === LOCATORS ===
    # Cart item: .cart_item
    # Item name: .inventory_item_name
    # Item price: .inventory_item_price
    # Quantity:   .cart_quantity

    # === ACCEPTANCE ===
    # 1 cart item visible
    # Name: "Sauce Labs Backpack", Quantity: 1, Price: "$29.99"

    Then the cart contains exactly 1 item
    And the cart item "Sauce Labs Backpack" has quantity 1 and price "$29.99"

  @regression @p2
  Scenario: User removes an item from the cart
    # === INTENT ===
    # Removing from cart must update the item list and the cart badge.
    # An empty cart must show the empty state — not a broken layout.

    # === ACCEPTANCE ===
    # After remove: cart is empty, cart badge not visible

    When the user removes "Sauce Labs Backpack" from the cart
    Then the cart is empty
    And the cart badge is not visible

  @regression @p2
  Scenario: User returns to inventory from cart
    # === INTENT ===
    # "Continue Shopping" must preserve cart state.
    # Items already in cart must not be lost on navigation.

    # === ACCEPTANCE ===
    # URL returns to "/inventory.html"
    # Cart badge still shows "1"

    When the user clicks "Continue Shopping"
    Then the current URL contains "/inventory.html"
    And the cart badge displays "1"

  # ─── CHECKOUT STEP 1: PERSONAL INFO ───────────────────────────────────────

  @smoke @p1
  Scenario: User completes checkout step 1 with valid data
    # === INTENT ===
    # Personal info is required to process the order.
    # Valid submission must advance to the order summary page.

    # === LOCATORS ===
    # First name: #first-name
    # Last name:  #last-name
    # Zip/Postal: #postal-code
    # Continue:   #continue

    # === DATA ===
    # Profile: valid_customer → see checkout.data.json

    # === ACCEPTANCE ===
    # After Continue: URL contains "/checkout-step-two.html"

    When the user clicks "Checkout"
    And the user fills in checkout info with profile "valid_customer"
    And the user clicks "Continue"
    Then the current URL contains "/checkout-step-two.html"

  @negative @p1
  Scenario Outline: Step 1 form validation blocks submission when <field> is missing
    # === INTENT ===
    # All three fields are required. Missing any one must show a specific
    # error and block navigation. No partial submissions reach the backend.

    # === ACCEPTANCE ===
    # Error banner visible with message matching <expected_error>
    # URL stays at "/checkout-step-one.html"

    When the user clicks "Checkout"
    And the user fills in checkout info with profile "<profile>"
    And the user clicks "Continue"
    Then the error banner "[data-test='error']" contains "<expected_error>"
    And the current URL contains "/checkout-step-one.html"

    Examples:
      | field      | profile              | expected_error          |
      | first name | missing_first_name   | First Name is required  |
      | last name  | missing_last_name    | Last Name is required   |
      | zip code   | missing_zip          | Postal Code is required |

  @regression @p2
  Scenario: User cancels from step 1 and returns to cart
    # === INTENT ===
    # Cancel on step 1 must return to cart with items intact.
    # No data loss, no navigation trap.

    # === ACCEPTANCE ===
    # URL returns to "/cart.html"
    # Cart still contains "Sauce Labs Backpack"

    When the user clicks "Checkout"
    And the user clicks "Cancel"
    Then the current URL contains "/cart.html"
    And the cart contains exactly 1 item

  # ─── CHECKOUT STEP 2: ORDER SUMMARY ───────────────────────────────────────

  @smoke @p1
  Scenario: Order summary shows correct items and prices
    # === INTENT ===
    # Step 2 is the financial contract. Item price, tax, and total must
    # be arithmetically correct and match declared data exactly.
    # A wrong total is a legal and trust defect.

    # === LOCATORS ===
    # Summary item:   .cart_item
    # Subtotal label: .summary_subtotal_label  → "Item total: $X.XX"
    # Tax label:      .summary_tax_label       → "Tax: $X.XX"
    # Total label:    .summary_total_label     → "Total: $X.XX"

    # === DATA ===
    # Profile: checkout_single → item $29.99, tax $2.40, total $32.39

    # === ACCEPTANCE ===
    # Item total = $29.99
    # Tax        = $2.40
    # Total      = $32.39  (must equal subtotal + tax)

    When the user clicks "Checkout"
    And the user fills in checkout info with profile "valid_customer"
    And the user clicks "Continue"
    Then the order summary contains item "Sauce Labs Backpack" at "$29.99"
    And the summary subtotal is "$29.99"
    And the summary tax is "$2.40"
    And the summary total is "$32.39"
    And the summary total equals subtotal plus tax

  @regression @p1
  Scenario: Order summary with multiple items calculates totals correctly
    # === INTENT ===
    # Multi-item totals must aggregate correctly.
    # Rounding errors on tax are a common and silent defect.

    # === DATA ===
    # Profile: checkout_multi → 3 items, see checkout.data.json for expected totals

    Given the user has added products from list "checkout_multi" to the cart
    And the user navigates to "/cart.html"
    When the user clicks "Checkout"
    And the user fills in checkout info with profile "valid_customer"
    And the user clicks "Continue"
    Then the summary total equals subtotal plus tax
    And the summary total is "$58.29"

  @regression @p2
  Scenario: User cancels from step 2 and returns to step 1
    # === INTENT ===
    # Cancel on step 2 must return to step 1 — not to cart.
    # The user may need to correct their shipping info.

    # === ACCEPTANCE ===
    # URL contains "/checkout-step-one.html" after Cancel on step 2

    When the user clicks "Checkout"
    And the user fills in checkout info with profile "valid_customer"
    And the user clicks "Continue"
    And the user clicks "Cancel"
    Then the current URL contains "/checkout-step-one.html"

  # ─── CHECKOUT COMPLETE ────────────────────────────────────────────────────

  @smoke @p1
  Scenario: User completes purchase and sees confirmation
    # === INTENT ===
    # Order completion is the final state of the purchase contract.
    # Confirmation must be explicit, unambiguous, and clear the cart.

    # === LOCATORS ===
    # Finish button:      #finish
    # Confirmation title: .complete-header  → "Thank you for your order!"
    # Confirmation text:  .complete-text

    # === ACCEPTANCE ===
    # URL contains "/checkout-complete.html"
    # Header: "Thank you for your order!"
    # Cart badge: not visible (cart cleared)

    When the user clicks "Checkout"
    And the user fills in checkout info with profile "valid_customer"
    And the user clicks "Continue"
    And the user clicks "Finish"
    Then the current URL contains "/checkout-complete.html"
    And the element ".complete-header" displays "Thank you for your order!"
    And the cart badge is not visible

  @regression @p2
  Scenario: User returns to inventory after completing an order
    # === INTENT ===
    # After confirmation, "Back Home" must return to a clean inventory.
    # No residual cart state from the completed order.

    # === ACCEPTANCE ===
    # URL contains "/inventory.html"
    # Cart badge not visible

    When the user clicks "Checkout"
    And the user fills in checkout info with profile "valid_customer"
    And the user clicks "Continue"
    And the user clicks "Finish"
    And the user clicks "Back Home"
    Then the current URL contains "/inventory.html"
    And the cart badge is not visible
