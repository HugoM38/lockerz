import 'package:flutter/material.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import '../services/user_service.dart';

class EditAccountController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController samePasswordController = TextEditingController();

  final UserService _userService = UserService();

  void userInformation(BuildContext context) async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;

    final success = await _userService.editUserInformations(firstName, lastName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Modification réussie' : 'Échec de la modification')),
    );
    if (success){
      SharedPrefs.saveUserInformation(firstName, lastName);
    }
  }

  void userPassword(BuildContext context) async {
    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final RegExp _passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!_passwordRegExp.hasMatch(newPassword)){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nouveau mot de passe invalide")),
      );
    } else {
      final success = await _userService.editUserPassword(oldPassword, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Modification réussie' : 'Échec de la modification')),
      );
    }
  }
}
