import 'dart:ui';
import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'signup_view.dart'; // Assurez-vous que le chemin est correct
import '../utils/text_utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = LoginController();
  bool showOption = false; // Ajout de la variable showOption

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: showOption ? const SizedBox() : const SizedBox(),
            ),
            const SizedBox(width: 20),
            showOption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = false;
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.white, size: 30),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = true;
                      });
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/sample_image.png'), // Remplacez par une image par défaut si nécessaire
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
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
          height: 400,
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
                    Center(child: TextUtil(text: "Login", weight: true, size: 30)),
                    const Spacer(),
                    TextUtil(text: "Email"),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: TextFormField(
                        controller: _loginController.emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.mail, color: Colors.white),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextUtil(text: "Password"),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.white)),
                      ),
                      child: TextFormField(
                        controller: _loginController.passwordController,
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
                    Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextUtil(
                            text: "Remember Me , FORGET PASSWORD",
                            size: 12,
                            weight: true,
                          ),
                        ),
                      ],
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
                          _loginController.login(context);
                        },
                        child: TextUtil(
                          text: "Log In",
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
                            MaterialPageRoute(builder: (context) => SignupView()),
                          );
                        },
                        child: TextUtil(
                          text: "Don't have an account? REGISTER",
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
