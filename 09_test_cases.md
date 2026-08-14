# Phase 8: Test Case Specifications

This test suite ensures 100% test coverage across all features, user stories, business rules, and edge cases discovered during reverse engineering.

---

## 1. Functional Test Cases (FTC)

| Test Case ID | Feature | Title | Preconditions | Test Steps | Test Data | Expected Results | Priority |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **FTC-01** | FEAT-1.1 | Country Discovery & Default Selection | Network active, API returns valid countries list including "DE". | 1. Launch App.<br>2. Observe top bar country badge. | `[{"isoCode": "DE", ...}, {"isoCode": "US", ...}]` | Germany (`DE`) is automatically selected with 🇩🇪 flag emoji and holidays loaded. | P0 |
| **FTC-02** | FEAT-1.1 | Country Search Filtering | Countries list loaded in bottom sheet. | 1. Tap country badge.<br>2. Type "uni" in search box. | Query = `"uni"` | List filters to "United States", "United Kingdom", etc. Case-insensitive. | P1 |
| **FTC-03** | FEAT-1.1 | Country Selection Update | Country picker open. | 1. Tap "France".<br>2. Observe dashboard reload. | Country = `FR` | Sheet closes. Active country updates to France 🇫🇷. Subdivisions and holidays reload. | P0 |
| **FTC-04** | FEAT-1.2 | Subdivision Loading & Filtering | Country selected with multiple subdivisions (e.g. Germany). | 1. Observe subdivision chips row.<br>2. Tap "Bavaria" chip. | Sub = `DE-BY` | Holidays re-fetched with `subdivisionCode=DE-BY`. List updates to Bavarian holidays. | P1 |
| **FTC-05** | FEAT-2.1 | Public & School Holiday Merge | Backend returns both Public & School holidays. | 1. Inspect raw holiday list.<br>2. Verify deduplication. | 10 Public, 5 School | Both holiday types are present, duplicates removed by composite key, sorted by date. | P0 |
| **FTC-06** | FEAT-2.2 | Hero Card Display & Countdown | Holidays loaded; upcoming holiday exists. | 1. Ensure search bar is empty.<br>2. Observe hero card at top. | Start date = 10 days in future | Hero card displays next holiday name, date range, and "in 10 days" countdown pill. | P1 |
| **FTC-07** | FEAT-2.2 | Today Holiday Status Highlight | Holiday starts today. | 1. Mock holiday with `startDate = today`. | Today's date | Hero card shows "🎉 TODAY" badge with emerald green highlight. | P1 |
| **FTC-08** | FEAT-3.1 | Year Switching | App on Home Screen. | 1. Tap chip "2025".<br>2. Observe feed reload. | Year = `2025` | Queries `validFrom=2025-01-01` & `validTo=2025-12-31`. Header shows "All 2025 Holidays". | P1 |
| **FTC-09** | FEAT-3.2 | Holiday Classification Tab Switch | Holidays loaded for active year. | 1. Tap "School" in segmented bar.<br>2. Tap "Public". | Tabs: Public, School | "School" tab shows only school holidays with amber icons; "Public" shows blue statutory days. | P1 |
| **FTC-10** | FEAT-2.3 | Holiday Details Sheet Inspection | Holiday cards visible on screen. | 1. Tap on "Christmas Day" card. | Selected Holiday | Modal bottom sheet opens displaying exact dates, duration ("1 day"), and nationwide scope. | P2 |

---

## 2. Regression Test Cases (RTC)

| Test Case ID | Feature | Title | Preconditions | Test Steps | Expected Results | Priority |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **RTC-01** | FEAT-1.1 | Repeated Country Tap Guard | Germany selected. | Tap country badge -> tap "Germany" again in sheet. | No duplicate network request sent; sheet simply dismisses. | P2 |
| **RTC-02** | FEAT-3.3 | Search Clear Button Restoration | Active search query in box. | 1. Type "Easter".<br>2. Tap (X) clear button. | Search box is cleared; full unfiltered holiday feed and Hero Card are restored. | P1 |
| **RTC-03** | FEAT-3.1 | Subdivisions Preserved on Year Switch | Subdivision "Bavaria" active. | 1. Switch year from 2026 to 2027. | Bavaria remains selected; 2027 holidays for Bavaria are fetched. | P2 |

---

## 3. Integration Test Cases (ITC)

| Test Case ID | Feature | Title | Description | Expected Results | Priority |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ITC-01** | Architecture | Repository to Retrofit/Dio Serialization | End-to-end network request parsing `CountryDto` list to `List<Country>`. | HTTP 200 response JSON maps accurately into domain entities without null crashes. | P0 |
| **ITC-02** | Architecture | Parallel API Aggregation Resilience | `PublicHolidays` succeeds (200) while `SchoolHolidays` returns 404/500. | Repository recovers gracefully via `runCatching`, returning Public holidays without error. | P0 |
| **ITC-03** | Presentation | ViewModel State Flow Propagation | User selects country -> ViewModel emits loading -> emits success. | UI smoothly transitions from loading spinner to populated list. | P0 |

---

## 4. Boundary & Negative Test Cases (BTC / NTC)

| Test Case ID | Category | Title | Test Data / Condition | Expected Results | Priority |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **NTC-01** | Negative | Network Timeout / Offline | Device in Airplane mode / No internet. | Displays `ErrorView` with informative message and functional "Retry" button. | P0 |
| **NTC-02** | Negative | Unknown Country ISO Code | Country code = `"XYZ"` | Flag emoji returns `"🌐"`; error handled cleanly. | P2 |
| **BTC-01** | Boundary | Single-Day Holiday Duration | `startDate = 2026-05-01`, `endDate = 2026-05-01` | Duration calculated as `1 day` (not 0 days). | P1 |
| **BTC-02** | Boundary | Multi-Week Holiday Duration | `startDate = 2026-07-01`, `endDate = 2026-07-31` | Duration calculated as `31 days`. | P1 |
| **BTC-03** | Boundary | Year-End Boundary Holiday | `startDate = 2026-12-31`, `endDate = 2027-01-01` | Handled properly across midnight boundary. | P1 |

---

## 5. User Acceptance Testing (UAT) Scenarios

### UAT-01: Vacation Planner Flow
- **Persona**: International traveler booking flights.
- **Scenario**: User opens app, switches country to Japan (JP), selects year 2027, filters by "Public" holidays, and finds Golden Week dates to plan travel.

### UAT-02: Parent School Holiday Inspection
- **Persona**: Working parent planning childcare.
- **Scenario**: User selects Germany -> State of Bavaria -> taps "School" tab -> locates Autumn & Christmas school break dates with exact day counts.
