import 'package:flutter/material.dart';
import 'package:lockerz/models/user_model.dart';
import 'package:lockerz/services/locker_service.dart';
import 'package:lockerz/services/user_service.dart';
import 'package:lockerz/views/shared/navbar.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import '../../models/locker_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedLockerId;

  List<User> _users = [];
  List<User> _filteredUsers = [];
  List<User> _selectedUsers = [];
  String _searchQuery = '';
  bool _termsAccepted = false;

  List<Locker> _lockers = [];
  List<String> _localisations = [];

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    // Récupérer l'utilisateur connecté
    _currentUser = await SharedPrefs.getUser();

    // Récupérer les utilisateurs et casiers
    List<User> users = await UserService().getUsers();
    List<Locker> lockers = await LockerService().getLockers();

    setState(() {
      _users = users.where((user) => user.id != _currentUser?.id).toList();
      _filteredUsers = _users;
      _lockers = lockers;
      _localisations = lockers.map((locker) => locker.localisation.name).toSet().toList();
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredUsers = _users
          .where((user) =>
      user.firstname.toLowerCase().contains(query.toLowerCase()) ||
          user.lastname.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _onUserSelected(User user, bool isSelected) {
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

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedLockerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un casier.')),
        );
        return;
      }
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez accepter les termes d\'utilisation.')),
        );
        return;
      }

      final result = await ReservationService().createReservation(
        _selectedLockerId!,
        _selectedUsers.map((u) => u.id).toList(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Formulaire soumis avec succès!' : 'Erreur de création de réservation'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _localisations.length,
      child: Scaffold(
        appBar: const NavBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: _localisations.map((localisation) {
                  return Tab(text: localisation);
                }).toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: _localisations.map((localisation) {
                    final filteredLockers = _lockers.where((locker) => locker.localisation.name == localisation).toList();
                    return ListView(
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
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 10, // Nombre de colonnes
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: filteredLockers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final locker = filteredLockers[index];
                                  final isAvailable = locker.status == 'available';
                                  final isSelected = _selectedLockerId == locker.id;

                                  return GestureDetector(
                                    onTap: isAvailable
                                        ? () {
                                      setState(() {
                                        _selectedLockerId = locker.id;
                                      });
                                    }
                                        : null,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isAvailable ? Colors.green : Colors.grey,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(
                                          color: isSelected ? Colors.red : Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${locker.number}',
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
                                      title: Text('${user.firstname} ${user.lastname} (${user.email})'),
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
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
