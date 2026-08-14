# Phase 4: Business Rule Extraction

This document captures all domain logic, validation rules, calculation formulas, workflows, and constraints discovered in the Android codebase.

---

## 1. Catalog of Extracted Business Rules

### BR-01: Default Country Selection Strategy
- **Source**: [`HolidayViewModel.kt#L35-L38`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/viewmodel/HolidayViewModel.kt#L35-L38)
- **Logic**:
  1. Check if Germany (`isoCode == "DE"`) exists in the country list.
  2. If not found, check if United States (`isoCode == "US"`) exists.
  3. If neither exists, select the first available country in the list (`countryList.firstOrNull()`).
- **Rationale**: Prioritizes countries with extensive subdivision coverage in OpenHolidays API.

---

### BR-02: Country Flag Emoji Generation
- **Source**: [`Models.kt#L43-L49`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/domain/model/Models.kt#L43-L49)
- **Formula / Algorithm**:
  ```kotlin
  if (countryCode.length != 2) return "🌐"
  val code = countryCode.uppercase()
  val firstLetter = Character.codePointAt(code, 0) - 0x41 + 0x1F1E6
  val secondLetter = Character.codePointAt(code, 1) - 0x41 + 0x1F1E6
  return String(Character.toChars(firstLetter)) + String(Character.toChars(secondLetter))
  ```
- **Rule**: Transforms 2-character ISO 3166-1 alpha-2 codes into Unicode Regional Indicator Symbol pairs. Returns fallback globe `🌐` if code length != 2.

---

### BR-03: Localization & Language Fallback Hierarchy
- **Source**: [`HolidayRepository.kt#L128-L133`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/repository/HolidayRepository.kt#L128-L133)
- **Hierarchy Order**:
  1. Match requested `targetLanguage` (case-insensitive) in `List<LocalizedStringDto>`.
  2. If missing, match English (`"EN"`, case-insensitive).
  3. If missing, return the first available translation in the list.
  4. If list is null or empty, fallback to ISO code or default title.

---

### BR-04: Date Formatting & Default Calendar Year
- **Source**: [`DateUtils.kt#L11-L17`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/domain/model/DateUtils.kt#L11-L17)
- **Rule**:
  - All date strings conform to ISO standard format `yyyy-MM-dd` using `Locale.US`.
  - On launch, the default selected year is set to `Calendar.getInstance().get(Calendar.YEAR)`.
  - Date queries send `validFrom = "$year-01-01"` and `validTo = "$year-12-31"`.

---

### BR-05: Holiday Duration Calculation
- **Source**: [`DateUtils.kt#L27-L33`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/domain/model/DateUtils.kt#L27-L33)
- **Formula**:
  $$\text{Duration in Days} = \left\lfloor\frac{\text{EndDate}_{\text{millis}} - \text{StartDate}_{\text{millis}}}{86,400,000}\right\rfloor + 1$$
- **Constraint**: Minimum duration is always 1 day. If date parsing fails, duration defaults to 1 day.

---

### BR-06: Real-Time Holiday Status Determination
- **Source**: [`DateUtils.kt#L58-L94`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/domain/model/DateUtils.kt#L58-L94)
- **Status Classification**:
  - `HolidayStatus.TODAY`: If current date (at midnight `00:00:00.000`) falls between `startDate` (at `00:00:00.000`) and `endDate` (at `23:59:59.999`).
  - `HolidayStatus.UPCOMING`: If current date (at midnight) is strictly before `startDate`.
  - `HolidayStatus.PAST`: If current date (at midnight) is strictly after `endDate`.

---

### BR-07: Days Remaining Countdown Calculation
- **Source**: [`DateUtils.kt#L35-L56`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/domain/model/DateUtils.kt#L35-L56)
- **Formula**:
  $$\text{Days Remaining} = \left\lfloor\frac{\text{StartDate}_{\text{midnight}} - \text{Today}_{\text{midnight}}}{86,400,000}\right\rfloor$$
- **Constraint**: Returns `null` if holiday is in the past ($\text{Days} < 0$). Returns `0` if holiday starts today.

---

### BR-08: Holiday Deduplication Composite Key
- **Source**: [`HolidayRepository.kt#L92-L94`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/repository/HolidayRepository.kt#L92-L94)
- **Deduplication Key**: `"${holiday.name}_${holiday.startDate}_${holiday.type}"`
- **Rule**: Distinct by composite key to prevent duplicates when merging overlapping Public and School holiday feeds.

---

### BR-09: Holiday Chronological Ordering
- **Source**: [`HolidayRepository.kt#L94`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/repository/HolidayRepository.kt#L94)
- **Rule**: All holidays are sorted strictly in ascending order by `startDate` (`yyyy-MM-dd`).

---

### BR-10: Next Upcoming Holiday Hero Selection & Visibility
- **Source**: [`HolidayViewModel.kt#L168-L170`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/viewmodel/HolidayViewModel.kt#L168-L170), [`HomeScreen.kt#L87-L99`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/screens/HomeScreen.kt#L87-L99)
- **Rules**:
  - The hero card selects the first holiday in the raw chronological list where status is `UPCOMING` or `TODAY`.
  - The hero card is only rendered when the user search query is blank. If a search query is active, hero card is hidden to avoid visual confusion.

---

### BR-11: Multi-Facet Filtering Logic
- **Source**: [`HolidayViewModel.kt#L146-L166`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/viewmodel/HolidayViewModel.kt#L146-L166)
- **Filter Facets**:
  1. **Tab Filter**:
     - `HolidayType.ALL`: Includes both `PUBLIC` and `SCHOOL`.
     - `HolidayType.PUBLIC`: Strictly matches `holiday.type == HolidayType.PUBLIC`.
     - `HolidayType.SCHOOL`: Strictly matches `holiday.type == HolidayType.SCHOOL`.
  2. **Search Filter**:
     - Case-insensitive substring matching against `holiday.name` OR `holiday.comment`.
  3. **Subdivision Filter**:
     - When a subdivision is selected, remote query appends `&subdivisionCode={code}`. When "All States / Regions" (`null`) is selected, query param is omitted to fetch nationwide + all regional items.

---

### BR-12: Network Aggregation & Error Resilience Strategy
- **Source**: [`HolidayRepository.kt#L76-L83`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/repository/HolidayRepository.kt#L76-L83)
- **Rule**: Public and School holidays are requested independently wrapped in `runCatching { ... }.getOrDefault(emptyList())`. If the School Holidays endpoint returns 404/500/empty (common for certain countries), the Public Holidays result still renders successfully without breaking the application.
