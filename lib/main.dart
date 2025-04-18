import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notes_app/l10n/app_localizations.dart';
import 'package:notes_app/screens/splash_screen.dart';
import 'package:notes_app/services/theme_service.dart';
import 'package:notes_app/services/language_service.dart';
import 'package:provider/provider.dart';

/// Entry point of the application
void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Run the app with the theme and language service providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Root widget of the application
/// 
/// Configures the theme, localization, and initial route
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeService, LanguageService>(
      builder: (context, themeService, languageService, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: themeService.currentTheme,
        home: const SplashScreen(),
        locale: Locale(languageService.currentLanguage),
        
        // Configure localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ar'), // Arabic
        ],
      ),
    );
  }
}
