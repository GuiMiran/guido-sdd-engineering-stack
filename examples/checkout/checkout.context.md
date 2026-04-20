# Checkout — Context File

> Consumed by: QA Engineers writing step definitions, AI agents generating code.
> Authority: This file is the single source of truth for the full checkout flow
> (cart review → step 1 → step 2 → confirmation).
> A locator or rule not listed here MUST NOT appear in generated code.

---

## Stack

Inherited from `examples/_global.context.md`. No overrides for this module.

---

## URLs (all 4 pages in the flow)

| Page              | URL                              | Arrives from                  |
|-------------------|----------------------------------|-------------------------------|
| Cart              | `/cart.html`                     | Cart icon or inventory        |
| Checkout Step 1   | `/checkout-step-one.html`        | "Checkout" button in cart     |
| Checkout Step 2   | `/checkout-step-two.html`        | "Continue" on step 1          |
| Checkout Complete | `/checkout-complete.html`        | "Finish" on step 2            |

---

## Verified Locators

All selectors verified against the live SauceDemo DOM on 2026-04-20.

### Cart page (`/cart.html`)

| Element             | Selector                     | Type  | Notes                        |
|---------------------|------------------------------|-------|------------------------------|
| Cart item container | `.cart_item`                 | class | Repeated per item            |
| Item name           | `.inventory_item_name`       | class | Inside `.cart_item`          |
| Item price          | `.inventory_item_price`      | class | Inside `.cart_item`          |
| Item quantity       | `.cart_quantity`             | class | Inside `.cart_item`          |
| Remove button       | `[data-test="remove-{slug}"]`| attr  | Per-product slug             |
| Continue Shopping   | `[data-test="continue-shopping"]` | attr | Returns to inventory    |
| Checkout button     | `[data-test="checkout"]`     | attr  | Advances to step 1           |
| Cart badge          | `.shopping_cart_badge`       | class | Absent from DOM when 0       |

### Checkout Step 1 (`/checkout-step-one.html`)

| Element         | Selector                   | Type | Notes                          |
|-----------------|----------------------------|------|--------------------------------|
| First name      | `#first-name`              | id   | Required                       |
| Last name       | `#last-name`               | id   | Required                       |
| Zip/Postal code | `#postal-code`             | id   | Required                       |
| Continue button | `#continue`                | id   | Submits form                   |
| Cancel button   | `#cancel`                  | id   | Returns to `/cart.html`        |
| Error banner    | `[data-test="error"]`      | attr | Conditional — on failed submit |

### Checkout Step 2 (`/checkout-step-two.html`)

| Element          | Selector                       | Type  | Notes                        |
|------------------|--------------------------------|-------|------------------------------|
| Summary item     | `.cart_item`                   | class | Repeated per item            |
| Item name        | `.inventory_item_name`         | class | Inside `.cart_item`          |
| Item price       | `.inventory_item_price`        | class | Inside `.cart_item`          |
| Subtotal label   | `.summary_subtotal_label`      | class | Text: "Item total: $X.XX"    |
| Tax label        | `.summary_tax_label`           | class | Text: "Tax: $X.XX"           |
| Total label      | `.summary_total_label`         | class | Text: "Total: $X.XX"         |
| Finish button    | `#finish`                      | id    | Completes the order          |
| Cancel button    | `#cancel`                      | id    | Returns to step 1            |

### Checkout Complete (`/checkout-complete.html`)

| Element              | Selector            | Type  | Notes                              |
|----------------------|---------------------|-------|------------------------------------|
| Confirmation header  | `.complete-header`  | class | Text: "Thank you for your order!"  |
| Confirmation body    | `.complete-text`    | class | Delivery estimate text             |
| Back Home button     | `[data-test="back-to-products"]` | attr | Returns to `/inventory.html` |

---

## Page Objects

| Class                 | Location                                                             |
|-----------------------|----------------------------------------------------------------------|
| `CartPage`            | `/src/[Project].Tests/Pages/Cart/CartPage.cs`                        |
| `CheckoutStep1Page`   | `/src/[Project].Tests/Pages/Checkout/CheckoutStep1Page.cs`           |
| `CheckoutStep2Page`   | `/src/[Project].Tests/Pages/Checkout/CheckoutStep2Page.cs`           |
| `CheckoutCompletePage`| `/src/[Project].Tests/Pages/Checkout/CheckoutCompletePage.cs`        |

### CartPage — Required Methods

```csharp
int GetCartItemCount()
CartItemComponent GetCartItemByName(string name)    // returns name, price, quantity
void RemoveItemByName(string name)
bool IsCartEmpty()
bool IsCartBadgeVisible()
int GetCartBadgeCount()
void ClickContinueShopping()
void ClickCheckout()
```

### CheckoutStep1Page — Required Methods

```csharp
void EnterFirstName(string value)
void EnterLastName(string value)
void EnterZipCode(string value)
void FillFormWithProfile(CustomerProfile profile)   // orchestrates the three above
void ClickContinue()
void ClickCancel()
string GetErrorMessage()
bool IsErrorVisible()
```

### CheckoutStep2Page — Required Methods

```csharp
IList<CartItemComponent> GetSummaryItems()
decimal GetSubtotal()                               // parse "$X.XX" → decimal
decimal GetTax()
decimal GetTotal()
bool TotalEqualsSubtotalPlusTax()                   // arithmetic verification
void ClickFinish()
void ClickCancel()
```

### CheckoutCompletePage — Required Methods

```csharp
string GetConfirmationHeader()
string GetConfirmationText()
void ClickBackHome()
```

---

## Step Definition Location

```
/src/[Project].Tests/StepDefinitions/Checkout/CheckoutSteps.cs
```

---

## Generation Rules for AI Agents

1. Each checkout page → separate PageObject class (do not merge into one)
2. Price parsing → always `decimal.Parse(text.Replace("$","").Replace("Item total: ","").Trim())`
3. Total verification → `GetSubtotal() + GetTax() == GetTotal()` using `decimal` — never `double` (floating point errors)
4. Error banner → wait for visibility before reading text; it is conditionally injected
5. Cart badge → `IsCartBadgeVisible()` before `.Text` — badge is absent from DOM at 0
6. `FluentAssertions` exclusively
7. If a locator is not in this file → **DO NOT invent it**

---

## Price Calculation Rules

SauceDemo applies a fixed tax rate. Use these values as the acceptance contract:

| Tax Rate | Applied to   | Rounding  |
|----------|-------------|-----------|
| ~8.0%    | Item subtotal | Round to 2 decimal places |

Exact values per scenario are declared in `checkout.data.json` — do not calculate dynamically in test assertions. Assert against the declared expected values.

---

## Known Constraints

- "Cancel" on step 1 → returns to `/cart.html` (not inventory)
- "Cancel" on step 2 → returns to `/checkout-step-one.html` (not cart)
- After "Finish" the cart is cleared server-side — badge disappears
- Price labels include prefix text (`"Item total: $29.99"`) — strip before parsing

---

## Coverage Map

| Scenario                            | Page Object Method              | Data Key             |
|-------------------------------------|---------------------------------|----------------------|
| Cart shows correct items            | `GetCartItemByName()`           | `checkout_single`    |
| Remove item from cart               | `RemoveItemByName()`            | —                    |
| Continue Shopping preserves cart    | `ClickContinueShopping()`       | —                    |
| Step 1 valid submission             | `FillFormWithProfile()`         | `valid_customer`     |
| Step 1 missing first name           | `FillFormWithProfile()`         | `missing_first_name` |
| Step 1 missing last name            | `FillFormWithProfile()`         | `missing_last_name`  |
| Step 1 missing zip                  | `FillFormWithProfile()`         | `missing_zip`        |
| Cancel from step 1                  | `ClickCancel()`                 | —                    |
| Step 2 price summary                | `GetSubtotal/Tax/Total()`       | `checkout_single`    |
| Step 2 multi-item totals            | `TotalEqualsSubtotalPlusTax()`  | `checkout_multi`     |
| Cancel from step 2                  | `ClickCancel()`                 | —                    |
| Complete purchase                   | `ClickFinish()`                 | `valid_customer`     |
| Back Home after confirmation        | `ClickBackHome()`               | —                    |
