/// Utility to generate Unicode country flag emoji from 2-letter ISO alpha-2 code
class FlagUtils {
  FlagUtils._();

  static String getCountryFlagEmoji(String countryCode) {
    if (countryCode.length != 2) return '🌐';
    final code = countryCode.toUpperCase();
    final firstChar = code.codeUnitAt(0);
    final secondChar = code.codeUnitAt(1);

    // ASCII 'A' is 0x41, 'Z' is 0x5A
    if (firstChar < 0x41 || firstChar > 0x5A || secondChar < 0x41 || secondChar > 0x5A) {
      return '🌐';
    }

    final first = firstChar - 0x41 + 0x1F1E6;
    final second = secondChar - 0x41 + 0x1F1E6;
    return String.fromCharCode(first) + String.fromCharCode(second);
  }
}
