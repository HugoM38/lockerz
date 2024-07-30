import 'package:flutter/material.dart';

class AuthObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation(newRoute?.settings.name);
  }

  void _logNavigation(String? routeName) {
    if (routeName == null) return;
    print('Navigated to $routeName');
  }
}