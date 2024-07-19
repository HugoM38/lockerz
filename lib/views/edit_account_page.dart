import 'package:flutter/material.dart';

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le compte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Prénom'),
                initialValue: _firstName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _firstName = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nom'),
                initialValue: _lastName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _lastName = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _password = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Logique pour sauvegarder les modifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Informations mises à jour')),
                    );
                  }
                },
                child: Text('Enregistrer les modifications'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logique pour supprimer le compte
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Supprimer le compte'),
                        content: Text('Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Logique pour confirmer la suppression du compte
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Compte supprimé')),
                              );
                              // Redirection après suppression
                              Navigator.of(context).pop();
                            },
                            child: Text('Supprimer'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('Supprimer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditAccountPage(),
  ));
}
