import 'dart:math';
import 'dart:ui';

class ColorUtils {
  static Color reversColor(Color color) {
    return Color(0x00ffffff ^ color.value);
  }

  static Color reversColorWithAlpha(Color color) {
    return Color(0x00ffffff ^ color.value).withAlpha(color.alpha);
  }

  static Color getRandomLightColor() {
    Random random = Random(DateTime.now().microsecond);
    int red = 150 + random.nextInt(106); // 150-255
    int green = 150 + random.nextInt(106); // 150-255
    int blue = 150 + random.nextInt(106); // 150-255
    return Color.fromARGB(255, red, green, blue);
  }

  static Color getRandomDarkColor() {
    Random random = Random(DateTime.now().microsecond);
    int red = random.nextInt(106); // 0-105
    int green = random.nextInt(106); // 0-105
    int blue = random.nextInt(106); // 0-105
    return Color.fromARGB(255, red, green, blue);
  }

  static Color getRandomModerateColor() {
    Random random = Random(DateTime.now().microsecond);
    int red = 100 + random.nextInt(156); // 100-255
    int green = 100 + random.nextInt(156); // 100-255
    int blue = 100 + random.nextInt(156); // 100-255
    return Color.fromARGB(255, red, green, blue);
  }

  static Color getLightColor(Color darkColor) {
    int red = (255 - darkColor.red) ~/ 1.5;
    int green = (255 - darkColor.green) ~/ 1.5;
    int blue = (255 - darkColor.blue) ~/ 1.5;
    return Color.fromARGB(darkColor.alpha, red, green, blue);
  }

  static Color getDarkColor(Color lightColor) {
    int red = (255 - lightColor.red) ~/ 1.5;
    int green = (255 - lightColor.green) ~/ 1.5;
    int blue = (255 - lightColor.blue) ~/ 1.5;
    return Color.fromARGB(lightColor.alpha, red, green, blue);
  }
}
