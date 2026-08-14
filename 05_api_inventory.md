# Phase 5: API Inventory

## 1. API Architecture Overview

- **Base URL**: `https://openholidaysapi.org/`
- **Protocol**: HTTPS / REST
- **Authentication**: None (Public Open Data API)
- **Content Type**: `application/json`
- **Client Configuration**:
  - Request Headers:
    - `User-Agent`: Standard Mobile Browser agent string
    - `Accept`: `application/json, text/json, */*`
  - Connection / Read Timeouts: 15 Seconds
  - Logging: Full HTTP Request & Response Body logging in debug mode

---

## 2. API Endpoints Catalog

### Endpoint 1: Get Supported Countries
- **Path**: `GET /Countries`
- **Source**: [`OpenHolidaysApi.kt#L11-L12`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/remote/OpenHolidaysApi.kt#L11-L12)
- **Purpose**: Retrieves all sovereign countries supported by the OpenHolidays system.
- **Request Parameters**: None.
- **Response Model**: `List<CountryDto>`
  ```json
  [
    {
      "isoCode": "DE",
      "name": [
        { "language": "EN", "text": "Germany" },
        { "language": "DE", "text": "Deutschland" }
      ],
      "officialLanguages": ["DE"]
    }
  ]
  ```
- **Calling Screens**: App launch, Country Picker modal, Retry action.
- **Error Handling**: Wrapped in `Result.failure`; triggers `ErrorView` on UI.

---

### Endpoint 2: Get Country Subdivisions / Administrative Regions
- **Path**: `GET /Subdivisions`
- **Source**: [`OpenHolidaysApi.kt#L14-L17`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/remote/OpenHolidaysApi.kt#L14-L17)
- **Purpose**: Fetches federal states, provinces, cantons, or territories belonging to a specific country.
- **Query Parameters**:
  | Parameter | Type | Required | Description | Example |
  | :--- | :--- | :--- | :--- | :--- |
  | `countryIsoCode` | `String` | Yes | 2-letter ISO 3166-1 alpha-2 code | `DE`, `US` |
- **Response Model**: `List<SubdivisionDto>`
  ```json
  [
    {
      "code": "DE-BY",
      "isoCode": "DE-BY",
      "shortName": "BY",
      "category": [{ "language": "EN", "text": "State" }],
      "name": [{ "language": "EN", "text": "Bavaria" }],
      "officialLanguages": ["DE"]
    }
  ]
  ```
- **Calling Screens**: Triggered automatically when a country is selected.
- **Resilience**: Returns empty list if a country has no registered subdivisions.

---

### Endpoint 3: Get Public Holidays
- **Path**: `GET /PublicHolidays`
- **Source**: [`OpenHolidaysApi.kt#L19-L26`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/remote/OpenHolidaysApi.kt#L19-L26)
- **Purpose**: Fetches statutory, national, and regional public holidays for a given date range.
- **Query Parameters**:
  | Parameter | Type | Required | Default | Description |
  | :--- | :--- | :--- | :--- | :--- |
  | `countryIsoCode` | `String` | Yes | - | ISO alpha-2 country code |
  | `languageIsoCode`| `String` | No | `"EN"` | Preferred response language |
  | `validFrom` | `String` | Yes | - | Start date (`yyyy-01-01`) |
  | `validTo` | `String` | Yes | - | End date (`yyyy-12-31`) |
  | `subdivisionCode`| `String` | No | `null` | Optional subdivision filter |
- **Response Model**: `List<HolidayDto>`
  ```json
  [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "startDate": "2026-01-01",
      "endDate": "2026-01-01",
      "type": "Public",
      "name": [{ "language": "EN", "text": "New Year's Day" }],
      "comment": [{ "language": "EN", "text": "First day of the year" }],
      "nationwide": true,
      "regionalScope": "National",
      "temporalScope": "FullDay",
      "subdivisions": []
    }
  ]
  ```

---

### Endpoint 4: Get School Holidays
- **Path**: `GET /SchoolHolidays`
- **Source**: [`OpenHolidaysApi.kt#L28-L35`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/remote/OpenHolidaysApi.kt#L28-L35)
- **Purpose**: Fetches academic term breaks, summer vacations, and school holidays.
- **Query Parameters**: Same as Public Holidays (`countryIsoCode`, `languageIsoCode`, `validFrom`, `validTo`, `subdivisionCode`).
- **Response Model**: `List<HolidayDto>`
- **Resilience**: Handled via `runCatching` fallback in repository to prevent breaking app when school calendar data is absent.

---

## 3. Deprecated, Unused, or Duplicate APIs

| Entity | Location | Status | Action in Flutter Migration |
| :--- | :--- | :--- | :--- |
| `DataRepository` / `DefaultDataRepository` | [`DataRepository.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/DataRepository.kt) | Unused template interface | Exclude from Flutter project. |
| Insecure SSL Bypass | [`RetrofitClient.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/remote/RetrofitClient.kt) | Insecure practice | Replace with standard HTTPS certificates in Dio. |
