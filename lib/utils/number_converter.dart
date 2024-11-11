class NumberConverter {
  static String convertNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 10000) {
      return '${(number / 1000).toStringAsFixed(1)}千';
    } else if (number < 100000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    } else if (number < 1000000) {
      return '${(number / 100000).toStringAsFixed(1)}十万';
    } else if (number < 10000000) {
      return '${(number / 1000000).toStringAsFixed(1)}百万';
    } else if (number < 100000000) {
      return '${(number / 10000000).toStringAsFixed(1)}千万';
    } else if (number < 1000000000) {
      return '${(number / 100000000).toStringAsFixed(1)}亿';
    } else if (number < 1000000000) {
      return '${(number / 100000000).toStringAsFixed(1)}亿';
    } else if (number < 10000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}十亿';
    } else if (number < 10000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}十亿';
    } else if (number < 100000000000) {
      return '${(number / 10000000000).toStringAsFixed(1)}百亿';
    } else if (number < 100000000000) {
      return '${(number / 10000000000).toStringAsFixed(1)}百亿';
    } else if (number < 1000000000000) {
      return '${(number / 100000000000).toStringAsFixed(1)}千亿';
    } else if (number < 1000000000000) {
      return '${(number / 100000000000).toStringAsFixed(1)}千亿';
    }
    return number.toString();
  }
}
