import 'dart:convert';

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
    final success =
        await _userService.editUserInformations(firstName, lastName);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                success ? 'Modification réussie' : 'Échec de la modification')),
      );
    }
    if (success) {
      await SharedPrefs.getUser().then((user) {
        user.firstname = firstName;
        user.lastname = lastName;
        SharedPrefs.saveUserInformation(jsonEncode(user.toJson()));
      });
    }
  }

  void userPassword(BuildContext context) async {
    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final success =
        await _userService.editUserPassword(oldPassword, newPassword);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                success ? 'Modification réussie' : 'Échec de la modification')),
      );
    }
  }

  Future<bool> deleteAccount(BuildContext context) async {
    final success = await _userService.deleteUser();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                success ? 'Suppression réussie' : 'Échec de la suppression')),
      );
    }
    return success;
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    samePasswordController.dispose();
  }
}
