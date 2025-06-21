import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CardSize { small, medium }

class SettingsProvider with ChangeNotifier {
  CardSize _cardSize = CardSize.medium;
  ThemeMode _themeMode = ThemeMode.light;
  late SharedPreferences _prefs;

  CardSize get cardSize => _cardSize;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadPreferences(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();

    final savedSize = _prefs.getString('cardSize');
    if (savedSize != null) {
      _cardSize = CardSize.values.firstWhere(
        (e) => e.toString() == savedSize,
        orElse: () => CardSize.medium,
      );
    } else {
      _cardSize = getAdaptiveCardSize(context);
    }

    final savedTheme = _prefs.getString('themeMode');
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }

    notifyListeners();
  }

  void setCardSize(CardSize newSize) {
    _cardSize = newSize;
    _prefs.setString('cardSize', newSize.toString());
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs.setString('themeMode', mode.toString());
    notifyListeners();
  }

  CardSize getAdaptiveCardSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) {
      return CardSize.small;
    } else {
      return CardSize.medium;
    }
  }

  int get crossAxisCount {
    switch (_cardSize) {
      case CardSize.small:
        return 3;
      case CardSize.medium:
        return 2;
    }
  }

  double get childAspectRatio {
    switch (_cardSize) {
      case CardSize.small:
        return 0.8;
      case CardSize.medium:
        return 0.9;
    }
  }

  double get titleFontSize {
    switch (_cardSize) {
      case CardSize.small:
        return 14.0;
      case CardSize.medium:
        return 18.0;
    }
  }

  double get subtitleFontSize {
    switch (_cardSize) {
      case CardSize.small:
        return 12.0;
      case CardSize.medium:
        return 14.0;
    }
  }

  double get iconSize {
    switch (_cardSize) {
      case CardSize.small:
        return 24.0;
      case CardSize.medium:
        return 32.0;
    }
  }

  double get avatarRadius {
    switch (_cardSize) {
      case CardSize.small:
        return 28.0;
      case CardSize.medium:
        return 36.0;
    }
  }

  EdgeInsets get cardPadding {
    switch (_cardSize) {
      case CardSize.small:
        return const EdgeInsets.all(4.0);
      case CardSize.medium:
        return const EdgeInsets.all(12.0);
    }
  }
}