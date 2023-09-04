import 'package:flutter/material.dart';


// FIXME: App language provider wrong!?
class AppLanguage extends ChangeNotifier {
  Locale? _locale;

  void setLanguage(Locale locale) {
    _locale = locale;
    ChangeNotifier();
  }

  Locale getLanguage() {
    return _locale ?? const Locale('en');
  }
}
