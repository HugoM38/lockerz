// views/signup_view.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../controllers/signup_controller.dart';
import '../utils/text_utils.dart';
import 'login_view.dart'; // Assurez-vous que le chemin est correct

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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF1a1919),
              Color(0xFF191818),
              Color(0xFF191818),
              Color(0xFF181818),
              Color(0xFF181717),
              Color(0xFF191817),
              Color(0xFF191817),
              Color(0xFF191918),
              Color(0xFF1a1b1a),
              Color(0xFF1b1c1b),
              Color(0xFF1d1e1d),
              Color(0xFF1e1f1f),
            ],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 500,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const Center(child: TextUtil(text: "Sign Up", weight: true, size: 30)),
                    const Spacer(),
                    const TextUtil(text: "First Name"),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: TextFormField(
                        controller: _signupController.firstnameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person, color: Colors.white),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const TextUtil(text: "Last Name"),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: TextFormField(
                        controller: _signupController.lastnameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person, color: Colors.white),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const TextUtil(text: "Email"),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: TextFormField(
                        controller: _signupController.emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.mail, color: Colors.white),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const TextUtil(text: "Password"),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: TextFormField(
                        controller: _signupController.passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.lock, color: Colors.white),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          _signupController.signUp(context);
                        },
                        child: const TextUtil(
                          text: "Sign Up",
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginView()),
                          );
                        },
                        child: const TextUtil(
                          text: "Already have an account? Sign In",
                          size: 12,
                          weight: true,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
