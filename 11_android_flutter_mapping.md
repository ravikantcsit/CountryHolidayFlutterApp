# Phase 10: Android to Flutter Mapping

## 1. Paradigm & Concept Mapping Table

| Android Native Concept | Android Implementation | Flutter Equivalent | Flutter Implementation |
| :--- | :--- | :--- | :--- |
| **App Entry Point** | `MainActivity : ComponentActivity` | `main()` & `MaterialApp` | `main.dart` with `runApp(ProviderScope(child: CountryHolidayApp()))` |
| **Screen / Page** | `@Composable fun HomeScreen()` | `ConsumerWidget` | `class HomeScreen extends ConsumerWidget` |
| **State Container** | `HolidayViewModel : ViewModel()` | Riverpod `Notifier` / `StateNotifier` | `class HolidayNotifier extends Notifier<HolidayUiState>` |
| **State Representation**| `StateFlow<HolidayUiState>` | `NotifierProvider<HolidayNotifier, HolidayUiState>` | `ref.watch(holidayNotifierProvider)` |
| **Concurrency / Async** | Kotlin Coroutines (`viewModelScope.launch`) | Dart `async` / `await` | `Future<T>` with `ref.read(...)` |
| **Background Threading**| `withContext(Dispatchers.IO)` | Event loop async IO / `Isolate.run` | Standard non-blocking asynchronous IO in Dart |
| **HTTP Client** | Retrofit 2 + OkHttp 3 | Dio | `Dio` with Interceptors and BaseOptions |
| **JSON Serialization** | Gson (`@SerializedName`) | Dart Factory Constructors | `factory CountryDto.fromJson(Map<String, dynamic> json)` |
| **UI Components** | Jetpack Compose Material 3 | Flutter Material 3 Widgets | `Card`, `FilterChip`, `SegmentedButton`, `ModalBottomSheet` |
| **List Views** | `LazyColumn` / `LazyRow` | `ListView.builder` / `LazyRow` | `ListView.builder(itemCount: ..., itemBuilder: ...)` |
| **Modal Sheets** | `ModalBottomSheet` composable | `showModalBottomSheet` | `showModalBottomSheet(context: context, builder: ...)` |
| **Colors & Theming** | `MaterialTheme` / `ColorScheme` | `ThemeData` / `ColorScheme` | `ThemeData(useMaterial3: true, colorScheme: ...)` |
| **Navigation** | AndroidX Navigation 3 | GoRouter | `GoRouter(routes: [GoRoute(path: '/', builder: ...)])` |
| **Unit Testing** | JUnit 4 + Kotlin Test | `package:flutter_test` | `test('...', () async { ... });` |
| **UI Testing** | Compose UI Test (`createAndroidComposeRule`)| `testWidgets` | `testWidgets('...', (tester) async { ... });` |

---

## 2. Code Conversion Examples

### Example 1: Country Flag Emoji Generator

#### Android (Kotlin)
```kotlin
fun getCountryFlagEmoji(countryCode: String): String {
    if (countryCode.length != 2) return "🌐"
    val code = countryCode.uppercase()
    val firstLetter = Character.codePointAt(code, 0) - 0x41 + 0x1F1E6
    val secondLetter = Character.codePointAt(code, 1) - 0x41 + 0x1F1E6
    return String(Character.toChars(firstLetter)) + String(Character.toChars(secondLetter))
}
```

#### Flutter (Dart)
```dart
String getCountryFlagEmoji(String countryCode) {
  if (countryCode.length != 2) return '🌐';
  final code = countryCode.toUpperCase();
  final first = code.codeUnitAt(0) - 0x41 + 0x1F1E6;
  final second = code.codeUnitAt(1) - 0x41 + 0x1F1E6;
  return String.fromCharCode(first) + String.fromCharCode(second);
}
```

---

### Example 2: Date Difference & Duration Calculation

#### Android (Kotlin)
```kotlin
fun calculateDurationDays(startDateStr: String, endDateStr: String): Long {
    val start = parseDate(startDateStr) ?: return 1
    val end = parseDate(endDateStr) ?: return 1
    val diffMillis = end.time - start.time
    val days = TimeUnit.MILLISECONDS.toDays(diffMillis) + 1
    return if (days > 0) days else 1
}
```

#### Flutter (Dart)
```dart
int calculateDurationDays(String startDateStr, String endDateStr) {
  final start = DateTime.tryParse(startDateStr);
  final end = DateTime.tryParse(endDateStr);
  if (start == null || end == null) return 1;
  final diff = end.difference(start).inDays + 1;
  return diff > 0 ? diff : 1;
}
```
