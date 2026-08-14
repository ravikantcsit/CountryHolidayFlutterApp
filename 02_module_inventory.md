# Phase 2: Module Inventory

## 1. Physical Module Overview

The native Android project is structured as a single-module Gradle application (`:app`) with distinct logical packages implementing clean layer boundaries.

| Module / Package | Purpose | Complexity | Business Criticality | Key Dependencies |
| :--- | :--- | :--- | :--- | :--- |
| **`:app` Root Module** | Main Android Application container, Manifest, Gradle configurations | Medium | Critical | AndroidX, Compose BOM, Retrofit, OkHttp, Coroutines |
| **`data.remote`** | HTTP network configuration, Retrofit client, OkHttp interceptors, API declarations | Medium | High | Retrofit 2, OkHttp 3, Gson |
| **`data.model`** | DTOs (Data Transfer Objects) matching OpenHolidays REST JSON schema | Low | High | Gson `@SerializedName` |
| **`data.repository`** | Data orchestration, language fallback resolution, API aggregation, model mapping | High | Critical | Coroutines, `OpenHolidaysApi`, `DateUtils` |
| **`domain.model`** | Pure domain entities, enums (`HolidayType`, `HolidayStatus`), business logic (`DateUtils`, Flag emojis) | Medium | Critical | Pure Kotlin / Java Time APIs |
| **`ui.viewmodel`** | Presentation state management, filter application, reactive UDF state flow | High | Critical | `androidx.lifecycle.ViewModel`, `StateFlow` |
| **`ui.components`** | Reusable Jetpack Compose UI components (TopBar, HeroCard, FilterBar, Cards, BottomSheets) | High | High | Compose Material 3, Foundation, UI |
| **`ui.screens`** | Screen containers and layout orchestrators (`HomeScreen`) | Medium | High | Compose Material 3, `HolidayViewModel` |
| **`ui.theme`** | Design system tokens, color palettes, dark/light themes, typography | Low | Medium | Compose Material 3 `ColorScheme` |
| **`ui.main` (Legacy)** | Template greeting screen & navigation stub (Scaffolding residue) | Low | Low (Deprecated) | Navigation 3, Template Repository |

---

## 2. Granular Module & Package Details

### 1. `com.ravikant.countryholidayapp.data.remote`
- **Purpose**: Defines HTTP communication endpoints and network client configurations.
- **Key Files**:
  - [`OpenHolidaysApi.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/remote/OpenHolidaysApi.kt): Retrofit interface declaring `getCountries()`, `getSubdivisions()`, `getPublicHolidays()`, `getSchoolHolidays()`.
  - [`RetrofitClient.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/remote/RetrofitClient.kt): Singleton creating OkHttpClient with logging interceptor, custom browser User-Agent header, custom SSL bypass, and GsonConverterFactory.
- **APIs Consumed**: `https://openholidaysapi.org/` endpoints (`/Countries`, `/Subdivisions`, `/PublicHolidays`, `/SchoolHolidays`).
- **Complexity**: Medium
- **Business Criticality**: High

### 2. `com.ravikant.countryholidayapp.data.model`
- **Purpose**: Serializable remote DTO data structures.
- **Key Files**:
  - [`ApiModels.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/model/ApiModels.kt): Defines `LocalizedStringDto`, `CountryDto`, `SubdivisionDto`, `HolidaySubdivisionDto`, `HolidayDto`.
- **Complexity**: Low
- **Business Criticality**: High

### 3. `com.ravikant.countryholidayapp.data.repository`
- **Purpose**: Fetches, parses, normalizes, combines, and maps remote DTOs into clean domain models.
- **Key Files**:
  - [`HolidayRepository.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/data/repository/HolidayRepository.kt): Declares `HolidayRepository` contract and `HolidayRepositoryImpl` implementation.
- **Key Features**:
  - Localized string extraction with language priority (`targetLanguage` -> `EN` -> first available).
  - Parallel public and school holiday querying with resilient `runCatching` fallbacks.
  - Holiday deduplication via key composite: `"${name}_${startDate}_${type}"`.
  - Chronological ordering by `startDate`.
- **Complexity**: High
- **Business Criticality**: Critical

### 4. `com.ravikant.countryholidayapp.domain.model`
- **Purpose**: Encapsulates business models and domain calculation rules completely decoupled from UI or Android SDK.
- **Key Files**:
  - [`Models.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/domain/model/Models.kt): `Country`, `Subdivision`, `Holiday`, `HolidayType` enum (`PUBLIC`, `SCHOOL`, `ALL`), `HolidayStatus` enum (`TODAY`, `UPCOMING`, `PAST`), and `getCountryFlagEmoji(countryCode)`.
  - [`DateUtils.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/domain/model/DateUtils.kt): Date parsing (`yyyy-MM-dd`), `calculateDurationDays()`, `getDaysRemaining()`, `getHolidayStatus()`.
- **Complexity**: Medium
- **Business Criticality**: Critical

### 5. `com.ravikant.countryholidayapp.ui.viewmodel`
- **Purpose**: Exposes immutable reactive state and processes UI events.
- **Key Files**:
  - [`HolidayUiState.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/viewmodel/HolidayUiState.kt): Immutable data class containing all screen state fields.
  - [`HolidayViewModel.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/viewmodel/HolidayViewModel.kt): ViewModel orchestrating country fetching, automatic default country selection (`DE` -> `US` -> first), subdivision loading, date & tab switching, query filtering, and next upcoming holiday computation.
- **Complexity**: High
- **Business Criticality**: Critical

### 6. `com.ravikant.countryholidayapp.ui.components` & `ui.screens`
- **Purpose**: Material 3 declarative UI presentation.
- **Key Files**:
  - [`Components.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/components/Components.kt): `TopAppBarHeader`, `NextHolidayHeroCard`, `FilterBarSection`, `SearchBarComponent`, `HolidayCard`, `CountryPickerSheet`, `HolidayDetailSheet`, `ErrorView`, `LoadingView`.
  - [`HomeScreen.kt`](file:///D:/Android_Workspace/CountryHolidayApp/app/src/main/java/com/ravikant/countryholidayapp/ui/screens/HomeScreen.kt): Main dashboard scaffold integrating header, search bar, filters, hero card, lazy list, and bottom sheets.
- **Complexity**: High
- **Business Criticality**: High
