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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.8,
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
                        child: buildEditForm(context),
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

  Widget buildEditForm(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKeyName,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _editAccountController.firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                  hintText: 'Veuillez entrer votre prénom',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _editAccountController.lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  hintText: 'Veuillez entrer votre nom',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
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
              TextFormField(
                controller: _editAccountController.oldPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Ancien mot de passe',
                  hintText: 'Veuillez entrer votre ancien mot de passe',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre ancien mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _editAccountController.newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  hintText: 'Veuillez entrer un nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nouveau mot de passe';
                  } else if (!_passwordRegExp.hasMatch(value)) {
                    return 'Le mot de passe doit faire 8 caractères et doit contenir au moins une majuscule';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _editAccountController.samePasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le nouveau mot de passe',
                  hintText: 'Veuillez confirmer votre nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
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
