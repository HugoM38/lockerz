import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedLocker;
  final List<String> _selectedUsers = [];
  List<String> _filteredUsers = [];
  String _searchQuery = '';
  bool _termsAccepted = false;

  // Simulated list of users
  final List<String> _users = [
    'Utilisateur 1',
    'Utilisateur 2',
    'Utilisateur 3',
    'Utilisateur 4',
    'Utilisateur 5',
    'Utilisateur 6',
    'Utilisateur 7',
    'Utilisateur 8',
    'Utilisateur 9',
    'Utilisateur 10',
    'Utilisateur 11',
    'Utilisateur 12',
  ];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _users;
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = _users
          .where((user) => user.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onUserSelected(String user, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (_selectedUsers.length < 4) {
          _selectedUsers.add(user);
        }
      } else {
        _selectedUsers.remove(user);
      }
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedLocker == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un casier.')),
        );
        return;
      }
      if (_selectedUsers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner au moins un utilisateur.')),
        );
        return;
      }
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez accepter les termes d\'utilisation.')),
        );
        return;
      }

      // Print the selected values
      print('Casier sélectionné : $_selectedLocker');
      print('Utilisateurs sélectionnés : $_selectedUsers');
      print('Termes acceptés : $_termsAccepted');

      // Process the form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulaire soumis avec succès!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Réserver un casier',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Choisir un casier',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10, // Nombre de colonnes
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: 20, // Nombre de casiers
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLocker = index + 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedLocker == index + 1 ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: _selectedLocker == index + 1 ? Colors.red : Colors.black,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Choisir les utilisateurs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Rechercher un utilisateur',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _updateSearchQuery,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200, // Adjust height as needed
                    child: ListView(
                      children: _filteredUsers.map((user) {
                        final isSelected = _selectedUsers.contains(user);
                        return CheckboxListTile(
                          title: Text(user),
                          value: isSelected,
                          onChanged: _selectedUsers.length < 4 || isSelected
                              ? (value) => _onUserSelected(user, value!)
                              : null,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'J\'accepte les termes et conditions.',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Valider'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
