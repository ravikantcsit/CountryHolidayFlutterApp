# Phase 9: Flutter Target Architecture

## 1. Architectural Blueprint & Layering

The Flutter codebase follows **Clean Architecture** with **Feature-First Modularization**.

```mermaid
graph TD
    subgraph Core_Layer [Core Layer /lib/core]
        Theme[Theme & Color Tokens]
        Network[Dio Network Client & Interceptors]
        Utils[DateUtils & FlagEmojiUtils]
        Error[AppFailure & Exception Handling]
    end

    subgraph Feature_Holidays [/lib/features/holidays]
        subgraph Domain [Domain Layer]
            Entities[Entities: Country, Subdivision, Holiday]
            Enums[Enums: HolidayType, HolidayStatus]
            RepoContract[HolidayRepository Contract]
            UseCases[GetCountries, GetSubdivisions, GetHolidays]
        end

        subgraph Data [Data Layer]
            DTOs[DTOs: CountryDto, SubdivisionDto, HolidayDto]
            RemoteDS[OpenHolidaysRemoteDataSource]
            RepoImpl[HolidayRepositoryImpl]
            Mappers[Entity-DTO Mappers]
        end

        subgraph Presentation [Presentation Layer]
            Controller[HolidayNotifier & HolidayUiState]
            Screens[HomeScreen]
            Widgets[TopAppBarHeader, NextHolidayHeroCard, FilterBar, HolidayCard, CountryPickerSheet, HolidayDetailSheet]
        end
    end

    Presentation --> Domain
    Data --> Domain
    Presentation --> Core_Layer
    Data --> Core_Layer
```

---

## 2. Directory Structure

```text
lib/
├── app.dart                                # MaterialApp.router & global theme setup
├── main.dart                               # App entry point with ProviderScope
├── routes/
│   └── app_router.dart                     # GoRouter configuration
├── core/
│   ├── constants/
│   │   └── api_constants.dart              # Base URLs, endpoints, timeouts
│   ├── network/
│   │   ├── dio_client.dart                 # Dio instance with headers & logging
│   │   └── api_exceptions.dart             # Typed network exception handling
│   ├── theme/
│   │   ├── app_colors.dart                 # Material 3 color palette & gradients
│   │   └── app_theme.dart                  # Light & Dark ThemeData definitions
│   └── utils/
│       ├── date_utils.dart                 # Date formatting, duration, remaining days
│       └── flag_utils.dart                 # ISO to Unicode flag emoji generator
└── features/
    └── holidays/
        ├── data/
        │   ├── datasources/
        │   │   └── open_holidays_remote_data_source.dart
        │   ├── models/
        │   │   ├── country_dto.dart
        │   │   ├── subdivision_dto.dart
        │   │   └── holiday_dto.dart
        │   └── repositories/
        │       └── holiday_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   ├── country.dart
        │   │   ├── subdivision.dart
        │   │   └── holiday.dart
        │   ├── repositories/
        │   │   └── holiday_repository.dart
        │   └── usecases/
        │       ├── get_countries_usecase.dart
        │       ├── get_subdivisions_usecase.dart
        │       └── get_holidays_usecase.dart
        └── presentation/
            ├── controllers/
            │   ├── holiday_controller.dart
            │   └── holiday_ui_state.dart
            ├── screens/
            │   └── home_screen.dart
            └── widgets/
                ├── country_picker_sheet.dart
                ├── error_view.dart
                ├── filter_bar_section.dart
                ├── holiday_card.dart
                ├── holiday_detail_sheet.dart
                ├── loading_view.dart
                ├── next_holiday_hero_card.dart
                ├── search_bar_widget.dart
                └── top_app_bar_header.dart
```

---

## 3. Technology Stack Decisions

| Need | Choice | Rationale |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.44+ (Dart 3.12+) | Latest stable version with modern records, switch expressions, and pattern matching. |
| **State Management** | `flutter_riverpod` 2.6+ | Compile-safe, testable, no BuildContext dependency for business logic. |
| **Networking** | `dio` 5.8+ | Powerful interceptors, timeouts, cross-platform HTTP support (Mobile & Web). |
| **Navigation** | `go_router` 14.8+ | Declarative routing with web URL synchronization and deep linking. |
| **Design Tokens** | Material 3 (`ThemeData.useMaterial3`) | Cohesive UI with responsive design across phone, tablet, and web viewports. |

---

## 4. Multi-Platform Support Strategy (Android, iOS, Web)

1. **Android**: Material 3 edge-to-edge support with dynamic navigation bar colors.
2. **iOS**: Cupertino physics, smooth sheet modals, and safe area insets.
3. **Web**: Responsive layout wrapping content in a centered max-width container (`kMaxContentWidth = 840.dp`) for desktop/tablet displays, canvas kit rendering, and SEO meta tags.
