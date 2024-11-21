import 'package:flutter/material.dart';

class ContextProvider {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Rex');

  static final ContextProvider _instance = ContextProvider._();

  ContextProvider._();

  static GlobalKey<NavigatorState> get navigatorKey => _instance._navigatorKey;

  static BuildContext? get navigatorContext => _instance._navigatorKey.currentState?.context;
}
