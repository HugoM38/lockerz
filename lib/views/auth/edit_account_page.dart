import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/views/auth/login_view.dart';
import 'package:lockerz/views/shared/navbar.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import '../../controllers/edit_account_controller.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  EditAccountPageState createState() => EditAccountPageState();
}

class EditAccountPageState extends State<EditAccountPage> {
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d).{8,}$');
  final EditAccountController _editAccountController = EditAccountController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    final user = await SharedPrefs.getUser();
    final firstName = user.firstname;
    final lastName = user.lastname;
    setState(() {
      _editAccountController.firstNameController.text = firstName;
      _editAccountController.lastNameController.text = lastName;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _editAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const NavBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight, // Adjust height to account for the AppBar
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double maxWidth = constraints.maxWidth < 600 ? constraints.maxWidth : 600;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: maxWidth,
                        child: buildEditForm(context, maxWidth),
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

  Widget buildEditForm(BuildContext context, double maxWidth) {
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
                    "Modifier le Compte",
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
                Form(
                  key: _formKeyName,
                  child: maxWidth > 400
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Prénom"),
                                  buildTextField(
                                    controller: _editAccountController.firstNameController,
                                    label: 'Prénom',
                                    icon: Icons.person,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Nom"),
                                  buildTextField(
                                    controller: _editAccountController.lastNameController,
                                    label: 'Nom',
                                    icon: Icons.person,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Prénom"),
                            buildTextField(
                              controller: _editAccountController.firstNameController,
                              label: 'Prénom',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 20),
                            const Text("Nom"),
                            buildTextField(
                              controller: _editAccountController.lastNameController,
                              label: 'Nom',
                              icon: Icons.person,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 20),
                buildSaveChangesButton(context),
                const Divider(),
                Form(
                  key: _formKeyPassword,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text("Ancien mot de passe"),
                      buildPasswordField(
                        controller: _editAccountController.oldPasswordController,
                        label: 'Ancien mot de passe',
                        icon: Icons.lock,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre ancien mot de passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      maxWidth > 400
                          ? Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Nouveau mot de passe"),
                                      buildPasswordField(
                                        controller: _editAccountController.newPasswordController,
                                        label: 'Nouveau mot de passe',
                                        icon: Icons.lock,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez entrer un nouveau mot de passe';
                                          } else if (!_passwordRegExp.hasMatch(value)) {
                                            return 'Le mot de passe doit faire 8 caractères et contenir au moins une majuscule et un chiffre';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Confirmer le nouveau mot de passe"),
                                      buildPasswordField(
                                        controller: _editAccountController.samePasswordController,
                                        label: 'Confirmer le nouveau mot de passe',
                                        icon: Icons.lock,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Veuillez confirmer votre nouveau mot de passe';
                                          } else if (value != _editAccountController.newPasswordController.text) {
                                            return 'Les mots de passe ne correspondent pas';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Nouveau mot de passe"),
                                buildPasswordField(
                                  controller: _editAccountController.newPasswordController,
                                  label: 'Nouveau mot de passe',
                                  icon: Icons.lock,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer un nouveau mot de passe';
                                    } else if (!_passwordRegExp.hasMatch(value)) {
                                      return 'Le mot de passe doit faire 8 caractères et contenir au moins une majuscule et un chiffre';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                const Text("Confirmer le nouveau mot de passe"),
                                buildPasswordField(
                                  controller: _editAccountController.samePasswordController,
                                  label: 'Confirmer le nouveau mot de passe',
                                  icon: Icons.lock,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez confirmer votre nouveau mot de passe';
                                    } else if (value != _editAccountController.newPasswordController.text) {
                                      return 'Les mots de passe ne correspondent pas';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      buildSavePasswordButton(context),
                    ],
                  ),
                ),
                const Divider(),
                buildDeleteAccountButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          suffixIcon: Icon(icon, color: Theme.of(context).textTheme.bodyLarge!.color),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        obscureText: true,
        decoration: InputDecoration(
          suffixIcon: Icon(icon, color: Theme.of(context).textTheme.bodyLarge!.color),
          border: InputBorder.none,
        ),
        validator: validator,
      ),
    );
  }

  Widget buildSaveChangesButton(BuildContext context) {
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
          if (_formKeyName.currentState!.validate()) {
            _editAccountController.userInformation(context);
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Sauvegarder les modifications',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildSavePasswordButton(BuildContext context) {
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
          if (_formKeyPassword.currentState!.validate()) {
            _editAccountController.userPassword(context);
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Enregistrer le nouveau mot de passe',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildDeleteAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Supprimer le compte'),
                content: const Text(
                    'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (await _editAccountController.deleteAccount(context)) {
                        SharedPrefs.removeAuthToken();
                        SharedPrefs.removeUserInformation();
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()));
                        }
                      }
                    },
                    child: const Text('Supprimer'),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Supprimer le compte',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
