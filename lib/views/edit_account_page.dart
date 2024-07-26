import 'package:flutter/material.dart';
import 'package:lockerz/views/login_view.dart';
import 'package:lockerz/views/shared/navbar.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import '../controllers/edit_account_controller.dart';

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
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildEditForm(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _formKeyName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTextField(
                controller: _editAccountController.firstNameController,
                label: 'Prénom',
                hint: 'Veuillez entrer votre prénom',
                icon: Icons.person,
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: _editAccountController.lastNameController,
                label: 'Nom',
                hint: 'Veuillez entrer votre nom',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              buildSaveChangesButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const Divider(),
        Form(
          key: _formKeyPassword,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildPasswordField(
                controller: _editAccountController.oldPasswordController,
                label: 'Ancien mot de passe',
                hint: 'Veuillez entrer votre ancien mot de passe',
                icon: Icons.lock,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre ancien mot de passe';
                  }
                }
              ),
              const SizedBox(height: 10),
              buildPasswordField(
                controller: _editAccountController.newPasswordController,
                label: 'Nouveau mot de passe',
                hint: 'Veuillez entrer un nouveau mot de passe',
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
              const SizedBox(height: 10),
              buildPasswordField(
                controller: _editAccountController.samePasswordController,
                label: 'Confirmer le nouveau mot de passe',
                hint: 'Veuillez confirmer votre nouveau mot de passe',
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
              const SizedBox(height: 20),
              buildSavePasswordButton(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const Divider(),
        buildDeleteAccountButton(context),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              suffixIcon: Icon(icon),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              suffixIcon: Icon(icon),
            ),
            obscureText: true,
            validator: validator,
          ),
        ),
      ],
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
