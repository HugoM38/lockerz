import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/controllers/verification_controller.dart';
import 'package:lockerz/views/shared/navbar.dart';

class VerificationView extends StatefulWidget {
  final String email;

  const VerificationView({super.key, required this.email});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final VerificationController _verificationController =
      VerificationController();

  @override
  void dispose() {
    _verificationController.dispose();
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
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double maxWidth =
                      constraints.maxWidth < 400 ? constraints.maxWidth : 400;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: maxWidth,
                        child: buildVerificationForm(context),
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

  Widget buildVerificationForm(BuildContext context) {
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
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Vérification de votre email',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Code de vérification envoyé.',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                buildCodeField(context),
                const SizedBox(height: 20),
                buildVerifyButton(context),
                const SizedBox(height: 20),
                buildResendButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCodeField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _verificationController.codeController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          labelText: 'Code de vérification',
          suffixIcon: Icon(Icons.code,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }

  Widget buildVerifyButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _verificationController.isLoading,
      builder: (context, isLoading, child) {
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
            onPressed: isLoading
                ? null
                : () => _verificationController.verifyCode(
                    context, widget.email),
            child: isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Vérifier'),
                  ),
          ),
        );
      },
    );
  }

  Widget buildResendButton(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _verificationController.isResendDisabled,
      builder: (context, isResendDisabled, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: isResendDisabled
                ? null
                : () => _verificationController.resendCode(
                    context, widget.email),
            child: ValueListenableBuilder<int>(
              valueListenable: _verificationController.resendCooldown,
              builder: (context, resendCooldown, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    isResendDisabled
                        ? 'Renvoyer le code ($resendCooldown)'
                        : 'Renvoyer le code',
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
