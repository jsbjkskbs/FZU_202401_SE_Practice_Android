import 'package:fulifuli_app/global.dart';

class NumberConverter {
  static String convertNumber(int number) {
    if (Global.appPersistentData.languageCode == 'zh') {
      return _convertNumberAsZH(number);
    } else {
      return _convertNumberAsEN(number);
    }
  }

  static String _convertNumberAsZH(int number) {
    if (number < 10000) {
      return number.toString();
    } else if (number < 100000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    } else if (number < 1000000000) {
      return '${(number / 100000000).toStringAsFixed(1)}亿';
    } else if (number < 1000000000000) {
      return '${(number / 100000000000).toStringAsFixed(1)}万亿';
    }
    return number.toString();
  }

  static String _convertNumberAsEN(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number < 1000000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    }
    return number.toString();
  }
}
