import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/navbar.dart';
import '../../controllers/login_controller.dart';
import 'forgot_password_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = LoginController();
  bool showOption = false;
  bool _showCookiePopup = true;

  @override
  void initState() {
    super.initState();
    _checkIfAcceptedCookies();
  }

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  Future<void> _checkIfAcceptedCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? accepted = prefs.getBool('cookies_accepted');
    if (accepted != null && accepted) {
      setState(() {
        _showCookiePopup = false;
      });
    }
  }

  Future<void> _acceptCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cookies_accepted', true);
    setState(() {
      _showCookiePopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    kToolbarHeight,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      double maxWidth = constraints.maxWidth < 400
                          ? constraints.maxWidth
                          : 400;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: maxWidth,
                            child: buildLoginForm(context),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_showCookiePopup)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          if (_showCookiePopup) _buildCookiePopup(context),
        ],
      ),
    );
  }

  Widget buildLoginForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Connexion",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      shadows: [
                        const Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Email"),
                buildEmailField(context),
                const SizedBox(height: 20),
                const Text("Mot de passe"),
                buildPasswordField(context),
                const SizedBox(height: 20),
                buildLoginButton(context),
                const SizedBox(height: 10),
                buildForgotPasswordButton(context),
                const SizedBox(height: 20),
                buildSignupButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEmailField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _loginController.emailController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.mail,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _loginController.passwordController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        obscureText: true,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.lock,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          _loginController.login(context);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Se connecter",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildForgotPasswordButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordView()));
        },
        child: Text(
          "Mot de passe oublié ?",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            shadows: [
              const Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignupButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            "/signup",
          );
        },
        child: Text(
          "Pas de compte ? Inscrivez-vous !",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            shadows: [
              const Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCookiePopup(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            child: SizedBox(
              width: 300,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cookie,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ce site utilise des cookies essentiels pour garantir son bon fonctionnement et améliorer votre expérience. Nous respectons votre vie privée et ne partageons aucune donnée personnelle.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _acceptCookies,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Accepter'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
