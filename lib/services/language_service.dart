import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for managing the app's language state
class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  static const String _languageKey = 'language_code';
  
  String _currentLanguage = 'en';
  
  // Singleton factory
  factory LanguageService() => _instance;
  
  LanguageService._internal() {
    _loadLanguage();
  }

  /// The current language code
  String get currentLanguage => _currentLanguage;

  /// Whether the current language is Arabic
  bool get isArabic => _currentLanguage == 'ar';

  /// Load saved language preference
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString(_languageKey) ?? 'en';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  /// Toggle between English and Arabic
  Future<void> toggleLanguage() async {
    try {
      _currentLanguage = _currentLanguage == 'en' ? 'ar' : 'en';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, _currentLanguage);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving language: $e');
      // Revert the change if save failed
      _currentLanguage = _currentLanguage == 'en' ? 'ar' : 'en';
      notifyListeners();
    }
  }
}