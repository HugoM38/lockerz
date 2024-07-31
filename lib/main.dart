import 'package:flutter/material.dart';
import 'package:lockerz/controllers/auth_controller.dart';
import 'package:lockerz/models/user_model.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import 'package:lockerz/views/admin/admin_home_page.dart';
import 'package:lockerz/views/admin/administration_page.dart';
import 'package:lockerz/views/auth/edit_account_page.dart';
import 'package:lockerz/views/user/home_page.dart';
import 'utils/auth_observer.dart';
import 'views/auth/login_view.dart';
import 'views/auth/signup_view.dart';

void main() {
  runApp(const Lockerz());
}

class Lockerz extends StatelessWidget {
  const Lockerz({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lockerz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF406E8E),
          primaryContainer: Color(0xFF406E8E),
          secondary: Color(0xFF42113C),
          secondaryContainer: Color(0xFF42113C),
          surface: Color(0xFF1C0118),
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      navigatorObservers: [AuthObserver()],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return FutureBuilder<bool>(
              future: _checkAuthentication(context, settings.name!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!) {
                  return const LoginView();
                }

                switch (settings.name) {
                  case '/':
                    return const LoginView();
                  case '/login':
                    return const LoginView();
                  case '/signup':
                    return const SignupView();
                  case '/account':
                    return const EditAccountPage();
                  case '/home':
                    return const HomePage();
                  case '/admin-home':
                    return const AdminHomePage();
                  case '/admin':
                    return const AdministrationPage();
                  default:
                    return const LoginView();
                }
              },
            );
          },
        );
      },
    );
  }

  Future<bool> _checkAuthentication(
      BuildContext context, String routeName) async {
    bool isUserLogged = await AuthController().isLoggedIn();

    if (isUserLogged) {
      User user = await SharedPrefs.getUser();
      if (routeName == '/' || routeName == '/login' || routeName == '/signup') {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
          return false;
        }
      } else if (routeName == '/home' && user.role == 'admin') {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/admin-home', (Route<dynamic> route) => false);
          return false;
        }
      } else if (routeName == '/admin-home' && user.role == 'user') {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', (Route<dynamic> route) => false);
          return false;
        }
      }
    } else if (routeName != '/' && routeName != '/login' && routeName != '/signup') {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/', (Route<dynamic> route) => false);
        return false;
      }
    }

    return true;
  }
}