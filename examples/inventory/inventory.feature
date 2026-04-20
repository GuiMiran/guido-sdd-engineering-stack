@regression @inventory @p1
Feature: Product Inventory
  # INTENT: Validate that the inventory page displays products correctly
  # and that all sorting, filtering, and navigation behaviors meet the contract.
  # This is the core commerce surface — every product journey starts here.
  # CONTEXT: examples/inventory/inventory.context.md
  # DATA: examples/inventory/inventory.data.json

  Background:
    Given the user is authenticated with profile "standard_user"
    And the current URL contains "/inventory.html"

  # ─── DISPLAY ──────────────────────────────────────────────────────────────

  @smoke @p1
  Scenario: Inventory page loads with all products visible
    # === INTENT ===
    # Verify the catalog renders the expected number of items.
    # A missing item means a broken product feed — blocks all purchase flows.

    # === ACCEPTANCE ===
    # Exactly 6 product cards visible
    # Each card has: image, name, description, price, "Add to cart" button

    Then the inventory contains exactly 6 product cards
    And every product card has a name, price, and "Add to cart" button

  @smoke @p1
  Scenario: Product prices are displayed in correct format
    # === INTENT ===
    # Price display is a legal and UX requirement.
    # Any malformed price ($0, empty, NaN) is a P1 defect.

    # === ACCEPTANCE ===
    # All prices match pattern "$X.XX"

    Then all product prices match the pattern "^\$\d+\.\d{2}$"

  # ─── SORTING ──────────────────────────────────────────────────────────────

  @regression @p1
  Scenario Outline: User sorts products by <sort_option>
    # === INTENT ===
    # Sorting is a discovery feature — wrong order hides products.
    # Each sort option must produce a deterministically verifiable sequence.

    # === LOCATORS ===
    # Sort dropdown: .product_sort_container (select element)

    # === ACCEPTANCE ===
    # After selecting <sort_option>, product list order matches <expected_order>

    When the user selects sort option "<sort_option>"
    Then the products are ordered by "<expected_order>"

    Examples:
      | sort_option | expected_order       |
      | az          | name ascending       |
      | za          | name descending      |
      | lohi        | price ascending      |
      | hilo        | price descending     |

  # ─── NAVIGATION ───────────────────────────────────────────────────────────

  @regression @p2
  Scenario: User navigates to product detail from inventory
    # === INTENT ===
    # Product detail is the pre-purchase decision page.
    # A broken link breaks the entire purchase funnel.

    # === ACCEPTANCE ===
    # Clicking a product name → URL changes to "/inventory-item.html?id=X"
    # Detail page shows same name and price as the card

    When the user clicks on product "Sauce Labs Backpack"
    Then the current URL contains "/inventory-item.html"
    And the detail page title is "Sauce Labs Backpack"

  # ─── CART INTERACTION ────────────────────────────────────────────────────

  @smoke @p1
  Scenario: User adds a product to cart from inventory
    # === INTENT ===
    # The "Add to cart" button is the primary conversion action.
    # Verify state changes: button label + cart badge counter.

    # === LOCATORS ===
    # Add button: [data-test="add-to-cart-sauce-labs-backpack"]
    # Cart badge: .shopping_cart_badge

    # === ACCEPTANCE ===
    # Button text changes to "Remove"
    # Cart badge shows "1"

    When the user clicks "Add to cart" on product "Sauce Labs Backpack"
    Then the button for "Sauce Labs Backpack" displays "Remove"
    And the cart badge displays "1"

  @regression @p1
  Scenario: User adds multiple products and cart badge updates
    # === INTENT ===
    # Cart badge must reflect cumulative count accurately.
    # Mismatch between badge and actual cart contents is a P1 defect.

    # === ACCEPTANCE ===
    # After adding 3 products → cart badge shows "3"

    When the user adds products from list "multi_add_3" to the cart
    Then the cart badge displays "3"

  @regression @p2
  Scenario: User removes a product from inventory after adding it
    # === INTENT ===
    # "Remove" button must decrement the cart and restore "Add to cart".
    # This is the undo path — must be symmetrical with adding.

    # === ACCEPTANCE ===
    # After Remove: button returns to "Add to cart", badge decrements to "0"

    When the user clicks "Add to cart" on product "Sauce Labs Backpack"
    And the user clicks "Remove" on product "Sauce Labs Backpack"
    Then the button for "Sauce Labs Backpack" displays "Add to cart"
    And the cart badge is not visible

  # ─── SIDEBAR / SESSION ───────────────────────────────────────────────────

  @regression @p2
  Scenario: User logs out from the inventory page
    # === INTENT ===
    # Logout must clear the session and redirect to the login page.
    # Residual session state after logout is a security defect.

    # === LOCATORS ===
    # Burger menu: #react-burger-menu-btn
    # Logout link: #logout_sidebar_link

    # === ACCEPTANCE ===
    # After logout: URL is "/" and login form is visible

    When the user opens the sidebar menu
    And the user clicks "Logout"
    Then the current URL is "/"
    And the element "#login-button" is visible
