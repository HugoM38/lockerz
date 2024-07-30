import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/navbar.dart';
import '../../controllers/signup_controller.dart';
import 'login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignupController _signupController = SignupController();

  @override
  void dispose() {
    _signupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double maxWidth = constraints.maxWidth < 400 ? constraints.maxWidth : 400;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: maxWidth,
                        child: buildSignupForm(context),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignupForm(BuildContext context) {
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
                    "Inscription",
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
                const Text("Prénom"),
                buildFirstNameField(context),
                const SizedBox(height: 20),
                const Text("Nom"),
                buildLastNameField(context),
                const SizedBox(height: 20),
                const Text("Email"),
                buildEmailField(context),
                const SizedBox(height: 20),
                const Text("Mot de passe"),
                buildPasswordField(context),
                const SizedBox(height: 20),
                buildSignupButton(context),
                const SizedBox(height: 20),
                buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFirstNameField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _signupController.firstnameController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.person,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildLastNameField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _signupController.lastnameController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.person,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
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
        controller: _signupController.emailController,
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
        controller: _signupController.passwordController,
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

  Widget buildSignupButton(BuildContext context) {
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
          _signupController.signUp(context);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "S'inscrire",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            "/login",
          );
        },
        child: Text(
          "Vous avez déjà un compte ? Connectez-vous !",
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
}
