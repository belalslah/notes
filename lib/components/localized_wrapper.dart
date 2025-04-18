import 'package:flutter/material.dart';

/// A widget that wraps content with proper text direction based on the current locale
class LocalizedWrapper extends StatelessWidget {
  final Widget child;

  const LocalizedWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Localizations.localeOf(context).languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: child,
    );
  }
} 