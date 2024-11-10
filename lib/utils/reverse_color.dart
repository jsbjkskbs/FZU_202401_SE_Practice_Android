import 'dart:ui';

class ColorUtils {
  static Color reversColor(Color color) {
    return Color(0x00ffffff ^ color.value);
  }

  static Color reversColorWithAlpha(Color color) {
    return Color(0x00ffffff ^ color.value).withAlpha(color.alpha);
  }
}
