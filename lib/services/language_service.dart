import 'package:flutter/material.dart';

class AppLanguage extends ChangeNotifier {
  bool _isAmharic = false;

  bool get isAmharic => _isAmharic;

  void toggle() {
    _isAmharic = !_isAmharic;
    notifyListeners();
  }

  String t(String english, String amharic) {
    return _isAmharic ? amharic : english;
  }
}

// Global instance
final appLanguage = AppLanguage();
