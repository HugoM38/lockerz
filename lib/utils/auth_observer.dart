import 'package:flutter/material.dart';
import 'package:lockerz/controllers/auth_controller.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import 'package:lockerz/models/user_model.dart';

class AuthObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkAuthentication(route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _checkAuthentication(newRoute?.settings.name);
  }

  Future<void> _checkAuthentication(String? routeName) async {
    if (routeName == null) return;

    bool isUserLogged = await AuthController().isLoggedIn();

    if (isUserLogged) {
      User user = await SharedPrefs.getUser();
      if (routeName == '/login' || routeName == '/signup') {
        navigator!
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } else if (routeName == '/home' && user.role == 'admin') {
        navigator!.pushNamedAndRemoveUntil(
            '/admin-home', (Route<dynamic> route) => false);
      } else if (routeName == '/admin-home' && user.role == 'user') {
        navigator!.pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false);
      }
    } else if (routeName != '/login' && routeName != '/signup') {
      navigator!
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
  }
}
