# Phase 7 / 8: Detailed User Stories Backlog

---

## User Story US-01: Country Discovery & Default Selection

- **Epic**: EPIC-01: Country & Subdivision Discovery
- **Feature**: FEAT-1.1: Country Catalog & Search
- **Priority**: High (P0)
- **Story Points**: 3

### User Story Statement
**As a** global user  
**I want** the application to automatically load supported countries and select a relevant default country on startup  
**So that** I immediately see holiday information without needing manual setup  

### Description
On initial app launch, the app contacts `GET /Countries`, parses available countries with localized English titles and flag emojis, selects Germany (`DE`), United States (`US`), or the first available country in alphabetical order, and triggers holiday retrieval for that selection.

### Acceptance Criteria
1. Given the app launches, when `GET /Countries` returns successfully, the countries list is sorted alphabetically by name.
2. Given country list contains `DE`, Germany is selected by default; if missing and `US` exists, US is selected; otherwise the first country is selected.
3. Country flag emoji is dynamically generated from the 2-letter ISO code using Unicode regional indicator symbols.
4. Top App Bar displays the selected country's flag emoji and name.

### Business Rules
- BR-01 (Default Country Strategy)
- BR-02 (Flag Emoji Generator)
- BR-03 (Localization Fallback)

### Flows
- **Preconditions**: Network connection available.
- **Postconditions**: Active country established in UI state; subdivisions and holidays requested.
- **Happy Path**: App launches -> retrieves countries -> selects default -> loads holidays.
- **Alternate Flows**: User has offline connectivity -> displays cached/fallback state or ErrorView with Retry.
- **Exception Flows**: API returns 500 error -> displays ErrorView.

---

## User Story US-02: Search & Switch Country via Bottom Sheet

- **Epic**: EPIC-01: Country & Subdivision Discovery
- **Feature**: FEAT-1.1: Country Catalog & Search
- **Priority**: High (P1)
- **Story Points**: 5

### User Story Statement
**As a** cross-border worker or traveler  
**I want** to search and select another country from a modal list  
**So that** I can explore holidays for any jurisdiction worldwide  

### Description
Clicking the country indicator in the header opens a modal bottom sheet with a search bar and scrollable country list. Typing filters the list by country name or ISO code. Tapping a country updates the active country, closes the sheet, and initiates subdivision and holiday re-fetching.

### Acceptance Criteria
1. Tapping the Country Badge in the Top Bar opens the `CountryPickerSheet`.
2. Typing in the search field filters countries in real-time by country name or ISO code (case-insensitive).
3. Tapping a country dismisses the sheet, updates selected country in state, and resets active subdivision.
4. If the tapped country is already selected, no unnecessary network re-fetch occurs.

### Business Rules
- BR-01, BR-02, BR-03

### Flows
- **Preconditions**: Countries have been fetched.
- **Postconditions**: New country selected; holidays reloaded for current year.
- **Happy Path**: Tap badge -> type "France" -> tap "France (FR)" -> sheet closes -> France holidays display.
- **Alternate Flows**: User taps outside or close button -> modal closes without selection change.
- **Exception Flows**: No countries match search -> display empty indicator.

---

## User Story US-03: Filter by State / Subdivision

- **Epic**: EPIC-01: Country & Subdivision Discovery
- **Feature**: FEAT-1.2: Regional Subdivision Loading
- **Priority**: Medium (P1)
- **Story Points**: 5

### User Story Statement
**As a** resident or planner in a specific state/province  
**I want** to filter holidays by administrative subdivision  
**So that** I only see holidays relevant to my specific region  

### Description
When a country is selected, its subdivisions are fetched via `GET /Subdivisions`. If subdivisions exist, a horizontal scrollable row of chips is rendered ("All States / Regions" + individual subdivision names). Selecting a subdivision queries holidays specific to that territory.

### Acceptance Criteria
1. When a country is chosen, its subdivisions are fetched asynchronously.
2. If subdivisions exist, a horizontal chip row appears with "All States / Regions" selected by default.
3. Tapping a subdivision chip sets `selectedSubdivision` and fetches holidays with `subdivisionCode`.
4. Tapping "All States / Regions" removes the subdivision code filter and queries all nationwide holidays.

### Business Rules
- BR-11 (Subdivision Filter)

### Flows
- **Preconditions**: Active country is selected.
- **Postconditions**: Holiday list updated to reflect region-specific holidays.
- **Happy Path**: Select country "DE" -> Subdivision chips load (Bavaria, Berlin, etc.) -> tap "Bavaria" -> holiday list filters to Bavarian holidays.
- **Alternate Flows**: Selected country has no subdivisions (e.g. Monaco) -> subdivision chip row is hidden.
- **Exception Flows**: Subdivisions request fails -> defaults to empty subdivision list without blocking main holiday flow.

---

## User Story US-04: Next Upcoming Holiday Hero Card & Countdown

- **Epic**: EPIC-02: Holiday Intelligence & Exploration
- **Feature**: FEAT-2.2: Hero Countdown & Status Highlight
- **Priority**: High (P1)
- **Story Points**: 5

### User Story Statement
**As an** everyday user  
**I want** to see an eye-catching hero card highlighting the very next upcoming holiday with a countdown  
**So that** I instantly know how many days remain until the next break  

### Description
At the top of the holiday feed, if the search query is empty and at least one upcoming or current holiday exists, display a gradient hero card showing the holiday name, dates, "NEXT UPCOMING" pill, and countdown ("in X days" or "🎉 TODAY").

### Acceptance Criteria
1. Displays the first holiday in the sorted list where status is `UPCOMING` or `TODAY`.
2. If status is `TODAY` (or days remaining == 0), renders a prominent "🎉 TODAY" indicator in emerald green.
3. If status is `UPCOMING`, displays "in X days" badge.
4. When user enters text in the search bar, the Hero Card is hidden.
5. Tapping the Hero Card opens the detailed inspection modal for that holiday.

### Business Rules
- BR-05 (Duration), BR-06 (Status), BR-07 (Days Remaining), BR-10 (Hero Visibility)

### Flows
- **Preconditions**: Holidays are loaded for the active country/year.
- **Postconditions**: Hero card renders with live calculated countdown.
- **Happy Path**: User opens app -> sees "New Year's Day - in 12 days" in gradient card -> taps card -> sees details.
- **Alternate Flows**: All holidays in the year have passed -> Hero Card is omitted.

---

## User Story US-05: Multi-Category Aggregation & Tab Filtering

- **Epic**: EPIC-03: Multi-Dimensional Filtering & Search
- **Feature**: FEAT-3.2: Holiday Classification Tabs
- **Priority**: High (P1)
- **Story Points**: 5

### User Story Statement
**As a** parent or professional  
**I want** to switch between "All", "Public", and "School" holidays using a segmented control  
**So that** I can focus specifically on statutory non-working days or school breaks  

### Description
The app concurrently fetches and combines Public and School holidays, tagging each domain item with `HolidayType.PUBLIC` or `HolidayType.SCHOOL`. A segmented tab bar allows instant client-side switching between `All`, `Public`, and `School`.

### Acceptance Criteria
1. Segmented button bar provides options: "All", "Public", "School".
2. Switching tabs immediately filters the rendered holiday cards without a new network request.
3. Public holidays display a blue icon/badge; School holidays display an amber icon/badge.
4. Total count of filtered items reflects active tab selection.

### Business Rules
- BR-08 (Deduplication), BR-09 (Chronological Sort), BR-11 (Facet Filtering)

### Flows
- **Preconditions**: Holidays loaded into state.
- **Postconditions**: UI updates list to display items matching active tab.
- **Happy Path**: User taps "School" -> only school holidays (summer break, winter break, etc.) appear.

---

## User Story US-06: Calendar Year Switcher

- **Epic**: EPIC-03: Multi-Dimensional Filtering & Search
- **Feature**: FEAT-3.1: Temporal Year Switcher
- **Priority**: Medium (P2)
- **Story Points**: 3

### User Story Statement
**As a** long-term planner  
**I want** to select different calendar years (2024, 2025, 2026, 2027)  
**So that** I can plan trips and project schedules across multiple years  

### Description
A row of year filter chips allows selecting 2024, 2025, 2026, or 2027. Selecting a year queries the API with `validFrom = "$year-01-01"` and `validTo = "$year-12-31"`.

### Acceptance Criteria
1. Year chips for 2024, 2025, 2026, 2027 are displayed.
2. Current calendar year is selected by default on startup.
3. Tapping a different year updates `selectedYear` and triggers network retrieval for that year's date range.
4. Section header updates to "All {Year} Holidays ({Count})".

### Business Rules
- BR-04 (Date Formatting & Year Default)

---

## User Story US-07: Real-Time Holiday Keyword Search

- **Epic**: EPIC-03: Multi-Dimensional Filtering & Search
- **Feature**: FEAT-3.3: Live Keyword Search
- **Priority**: Medium (P2)
- **Story Points**: 3

### User Story Statement
**As a** user looking for a specific celebration  
**I want** to search for holidays by keyword  
**So that** I can immediately find when a specific event occurs  

### Description
An outlined search bar allows typing text. As the user types, the list filters client-side to match the query against `holiday.name` and `holiday.comment`. A clear button (X) allows one-tap reset.

### Acceptance Criteria
1. Search input filters holiday list instantaneously without debouncing lag.
2. Search matches against both `name` and `comment` fields (case-insensitive).
3. Trailing clear button appears when text is present; tapping it clears the search.
4. If no holidays match, a helpful "No holidays found matching '{query}'" view is displayed.

### Business Rules
- BR-10, BR-11

---

## User Story US-08: Holiday Details Inspection Modal

- **Epic**: EPIC-02: Holiday Intelligence & Exploration
- **Feature**: FEAT-2.3: Holiday Detail Inspection
- **Priority**: Medium (P2)
- **Story Points**: 3

### User Story Statement
**As a** user  
**I want** to tap on any holiday to view comprehensive details in a modal sheet  
**So that** I can inspect exact start/end dates, total duration, scope of coverage, and descriptive comments  

### Description
Tapping any holiday card opens a modal bottom sheet displaying full holiday metadata, icon badge, date span with duration in days, nationwide vs regional coverage list, and explanatory commentary.

### Acceptance Criteria
1. Tapping a holiday card opens `HolidayDetailSheet`.
2. Sheet displays holiday type, formatted date range (e.g. `2026-12-24 to 2026-12-26 (3 days)`).
3. Coverage row indicates "Nationwide Holiday" or "Regional Holiday" listing affected states/regions.
4. Comments row displays explanatory context if available.
5. Dismissible by dragging down or tapping scrim.

### Business Rules
- BR-05, BR-11
