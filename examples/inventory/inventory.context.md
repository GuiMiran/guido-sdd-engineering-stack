# Inventory — Context File

> Consumed by: QA Engineers writing step definitions, AI agents generating code.
> Authority: This file is the single source of truth for the inventory module.
> A locator or rule not listed here MUST NOT appear in generated code.

---

## Stack

Inherited from `examples/_global.context.md`. No overrides for this module.

---

## URLs

| Environment | URL                                        |
|-------------|--------------------------------------------|
| Reference   | https://www.saucedemo.com/inventory.html   |
| Staging     | `ConfigManager.Get("BaseUrl")` + `/inventory.html` |

---

## Verified Locators

All selectors verified against the live SauceDemo DOM on 2026-04-20.

### Page-level

| Element               | Selector                        | Type  | Notes                          |
|-----------------------|---------------------------------|-------|--------------------------------|
| Page title            | `.title`                        | class | Text: "Products"               |
| Sort dropdown         | `.product_sort_container`       | class | `<select>` element             |
| Sidebar burger btn    | `#react-burger-menu-btn`        | id    | Opens nav panel                |
| Logout link           | `#logout_sidebar_link`          | id    | Inside sidebar, visible after open |
| Cart icon             | `.shopping_cart_link`           | class | Top-right, always visible      |
| Cart badge            | `.shopping_cart_badge`          | class | Only visible when count > 0    |

### Product card (repeated per item)

| Element               | Selector                              | Type  | Notes                      |
|-----------------------|---------------------------------------|-------|----------------------------|
| Card container        | `.inventory_item`                     | class | 6 instances on full load   |
| Product name link     | `.inventory_item_name`                | class | Clickable → detail page    |
| Product description   | `.inventory_item_desc`                | class |                            |
| Product price         | `.inventory_item_price`               | class | Format: `$X.XX`            |
| Product image         | `.inventory_item_img img`             | class | src varies per product     |
| Add to cart button    | `[data-test="add-to-cart-{slug}"]`    | attr  | See slug table below       |
| Remove button         | `[data-test="remove-{slug}"]`         | attr  | Replaces Add after click   |

### Product slugs (data-test attribute values)

| Product Name                      | Slug                                   |
|-----------------------------------|----------------------------------------|
| Sauce Labs Backpack               | `sauce-labs-backpack`                  |
| Sauce Labs Bike Light             | `sauce-labs-bike-light`                |
| Sauce Labs Bolt T-Shirt           | `sauce-labs-bolt-t-shirt`              |
| Sauce Labs Fleece Jacket          | `sauce-labs-fleece-jacket`             |
| Sauce Labs Onesie                 | `sauce-labs-onesie`                    |
| Test.allTheThings() T-Shirt (Red) | `test.allthethings()-t-shirt-(red)`    |

---

## Sort Option Values

Values passed to the `<select>` element via `.SelectByValue()`.

| Label                  | Value  | Expected Order          |
|------------------------|--------|-------------------------|
| Name (A to Z)          | `az`   | Alphabetical ascending  |
| Name (Z to A)          | `za`   | Alphabetical descending |
| Price (low to high)    | `lohi` | Price ascending         |
| Price (high to low)    | `hilo` | Price descending        |

---

## Page Objects

| Class               | Location                                                        |
|---------------------|-----------------------------------------------------------------|
| `InventoryPage`     | `/src/[Project].Tests/Pages/Inventory/InventoryPage.cs`         |
| `NavBarComponent`   | `/src/[Project].Tests/Pages/Components/NavBarComponent.cs`      |
| `CartIconComponent` | `/src/[Project].Tests/Pages/Components/CartIconComponent.cs`    |
| `ProductCardComponent` | `/src/[Project].Tests/Pages/Components/ProductCardComponent.cs` |

### InventoryPage — Required Methods

```csharp
int GetProductCount()
IList<ProductCardComponent> GetAllProductCards()
void SelectSortOption(string value)                  // value = "az" | "za" | "lohi" | "hilo"
IList<string> GetProductNamesInOrder()
IList<decimal> GetProductPricesInOrder()
void ClickProductByName(string name)
void AddToCartByName(string name)
void RemoveFromCartByName(string name)
string GetButtonTextForProduct(string name)          // "Add to cart" or "Remove"
int GetCartBadgeCount()                              // returns 0 if badge not visible
bool IsCartBadgeVisible()
void OpenSidebarMenu()
void ClickLogout()
```

---

## Step Definition Location

```
/src/[Project].Tests/StepDefinitions/Inventory/InventorySteps.cs
```

---

## Generation Rules for AI Agents

1. PageObject target → `/src/[Project].Tests/Pages/Inventory/InventoryPage.cs`
2. Steps target → `/src/[Project].Tests/StepDefinitions/Inventory/InventorySteps.cs`
3. Product cards → use `ProductCardComponent` per card, not raw selectors inline
4. Sort verification → compare full ordered list, not just first/last element
5. Cart badge → check `IsCartBadgeVisible()` before reading count — badge is absent at 0
6. `FluentAssertions` exclusively — never raw `Assert`
7. If a locator is not in this file → **DO NOT invent it**

---

## Known Constraints

- `problem_user` renders broken `<img>` tags — do not assert image `src` content in generic inventory tests
- Sort order for `lohi`/`hilo` must compare `decimal` values, not string — `$10.00 < $9.99` is a string-sort bug
- Cart badge disappears from DOM (not just hidden) when count reaches 0 — use `IsCartBadgeVisible()` before `.Text`

---

## Coverage Map

| Scenario                              | Page Object Method          | Data Key         |
|---------------------------------------|-----------------------------|------------------|
| Inventory loads with 6 products       | `GetProductCount()`         | —                |
| Prices in correct format              | `GetProductPricesInOrder()` | —                |
| Sort by A→Z / Z→A / lohi / hilo       | `SelectSortOption()`        | sort options     |
| Navigate to product detail            | `ClickProductByName()`      | `product_detail` |
| Add single product to cart            | `AddToCartByName()`         | —                |
| Add multiple products                 | `AddToCartByName()` ×N      | `multi_add_3`    |
| Remove product from cart              | `RemoveFromCartByName()`    | —                |
| Logout from inventory                 | `ClickLogout()`             | —                |
