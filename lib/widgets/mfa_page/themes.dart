import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class MFATheme {
  static PinTheme getDefaultPinTheme(BuildContext context) {
    return PinTheme(
      width: MediaQuery.of(context).size.width / 12,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 80),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 80),
      textStyle: TextStyle(
        fontSize: MediaQuery.of(context).size.width / 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
            width: 3.0,
          ),
        ),
      ),
    );
  }

  static PinTheme getFocusedPinTheme(BuildContext context) {
    return getDefaultPinTheme(context).copyWith(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 3.0,
          ),
        ),
      ),
    );
  }

  static PinTheme getSubmittedPinTheme(BuildContext context) {
    return getDefaultPinTheme(context).copyWith(
      textStyle: TextStyle(
        fontSize: MediaQuery.of(context).size.width / 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 3.0,
          ),
        ),
      ),
    );
  }

  static PinTheme getErrorPinTheme(BuildContext context) {
    return getDefaultPinTheme(context).copyWith(
      textStyle: TextStyle(
        fontSize: MediaQuery.of(context).size.width / 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFE40000),
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE40000),
            width: 3.0,
          ),
        ),
      ),
    );
  }

  static TextStyle getErrorTextStyle(BuildContext context) {
    return TextStyle(
      color: const Color(0xFFE40000),
      fontSize: MediaQuery.of(context).size.width / 20,
    );
  }
}
