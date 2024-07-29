import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/navbar.dart';
import '/controllers/home_page_controller.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/models/reservation_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late HomePageController _controller;
  Reservation? _currentReservation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    _currentReservation = await ReservationService().getCurrentReservation();
    await _controller.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const NavBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: _controller.localisations.length,
      child: Scaffold(
        appBar: const NavBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _currentReservation != null ? _buildReservationDetails() : _buildReservationForm(),
        ),
      ),
    );
  }

  Widget _buildReservationDetails() {
    final isOwner = _controller.currentUser?.id == _currentReservation!.owner.id;
    final isPending = _currentReservation!.status == 'pending';
    final isMember = _currentReservation!.members.any((member) => member.id == _controller.currentUser?.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Réservation actuelle', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text('Casier : ${_currentReservation!.locker.number}'),
        Text('Localisation : ${_currentReservation!.locker.localisation.name}'),
        Text('Propriétaire : ${_currentReservation!.owner.firstname} ${_currentReservation!.owner.lastname}'),
        const SizedBox(height: 10),
        Text('Membres :'),
        for (var member in _currentReservation!.members)
          Text('${member.firstname} ${member.lastname} (${member.email})'),
        const SizedBox(height: 20),
        Text('Statut : ${_currentReservation!.status}'),
        const SizedBox(height: 20),
        if (isMember) ...[
          ElevatedButton(
            onPressed: () => _controller.retireFromLocker(context),
            child: const Text('Se retirer du casier'),
          ),
        ] else if (isOwner) ...[
          if (isPending) ...[
            ElevatedButton(
              onPressed: () => _controller.cancelReservation(context),
              child: const Text('Annuler la réservation'),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () => _controller.terminateReservation(context),
              child: const Text('Terminer la réservation'),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildReservationForm() {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          tabs: _controller.localisations.map((localisation) {
            return Tab(text: localisation);
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            children: _controller.localisations.map((localisation) {
              final filteredLockers = _controller.lockers
                  .where((locker) => locker.localisation.name == localisation)
                  .toList();
              return ListView(
                children: <Widget>[
                  Form(
                    key: _controller.formKey,
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
                            final isSelected = _controller.selectedLockerId == locker.id;

                            return GestureDetector(
                              onTap: isAvailable
                                  ? () {
                                setState(() {
                                  _controller.selectedLockerId = locker.id;
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
                          onChanged: (query) {
                            setState(() {
                              _controller.updateSearchQuery(query);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200, // Adjust height as needed
                          child: ListView(
                            children: _controller.filteredUsers.map((user) {
                              final isSelected = _controller.selectedUsers.contains(user);
                              return CheckboxListTile(
                                title: Text('${user.firstname} ${user.lastname} (${user.email})'),
                                value: isSelected,
                                onChanged: _controller.selectedUsers.length < 4 || isSelected
                                    ? (value) {
                                  setState(() {
                                    _controller.onUserSelected(user, value!);
                                  });
                                }
                                    : null,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _controller.termsAccepted,
                              onChanged: (bool? value) {
                                setState(() {
                                  _controller.termsAccepted = value ?? false;
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
                          onPressed: () {
                            _controller.submitForm(context);
                          },
                          child: const Text('Valider'),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Règles associées aux cadenas:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Cadenas à clés : Obligation de déposer un double de la clé à l\'accueil.\n'
                              'Cadenas à code : Obligation de déposer le code à l\'accueil.',
                          style: TextStyle(fontSize: 16),
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
    );
  }
}
