import 'package:flutter/material.dart';

enum CardSize { small, medium, large }

class SettingsProvider with ChangeNotifier {
  CardSize _cardSize = CardSize.medium;
  ThemeMode _themeMode = ThemeMode.system;

  CardSize get cardSize => _cardSize;
  ThemeMode get themeMode => _themeMode;

  void setCardSize(CardSize newSize) {
    _cardSize = newSize;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  int get crossAxisCount {
    switch (_cardSize) {
      case CardSize.small:
        return 3;
      case CardSize.medium:
        return 2;
      case CardSize.large:
        return 1;
    }
  }

  double get childAspectRatio {
    switch (_cardSize) {
      case CardSize.small:
        return 0.8;
      case CardSize.medium:
        return 0.85;
      case CardSize.large:
        return 1.3;
    }
  }

  double get titleFontSize {
    switch (_cardSize) {
      case CardSize.small:
        return 14.0;
      case CardSize.medium:
        return 18.0;
      case CardSize.large:
        return 22.0;
    }
  }

  double get subtitleFontSize {
    switch (_cardSize) {
      case CardSize.small:
        return 12.0;
      case CardSize.medium:
        return 14.0;
      case CardSize.large:
        return 16.0;
    }
  }

  double get iconSize {
    switch (_cardSize) {
      case CardSize.small:
        return 24.0;
      case CardSize.medium:
        return 32.0;
      case CardSize.large:
        return 40.0;
    }
  }

  double get avatarRadius {
    switch (_cardSize) {
      case CardSize.small:
        return 28.0;
      case CardSize.medium:
        return 36.0;
      case CardSize.large:
        return 44.0;
    }
  }

  EdgeInsets get cardPadding {
    switch (_cardSize) {
      case CardSize.small:
        return const EdgeInsets.all(4.0);
      case CardSize.medium:
        return const EdgeInsets.all(12.0);
      case CardSize.large:
        return const EdgeInsets.all(16.0);
    }
  }
}