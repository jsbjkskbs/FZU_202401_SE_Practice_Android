import 'dart:ui';

class AppLocale {
  Locale locale;
  Null Function(Locale) changeLocale;

  AppLocale(this.locale, this.changeLocale);
}
