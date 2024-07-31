import 'dart:ui';
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

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late HomePageController _controller;
  Reservation? _currentReservation;
  bool _isLoading = true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    _currentReservation = await ReservationService().getCurrentReservation();
    await _controller.initialize();
    if (mounted) {
      setState(() {
        _tabController = TabController(
            length: _controller.localisations.length, vsync: this);
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: NavBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: _controller.localisations.length,
      child: Scaffold(
        appBar: const NavBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _currentReservation != null
                ? _buildReservationDetails(context)
                : _buildReservationForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationDetails(BuildContext context) {
    final isOwner =
        _controller.currentUser?.id == _currentReservation!.owner.id;
    final isPending = _currentReservation!.status == 'pending';
    final isMember = _currentReservation!.members
        .any((member) => member.id == _controller.currentUser?.id);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaY: 4, sigmaX: 4),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Réservation actuelle',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          shadows: [
                            const Shadow(
                              blurRadius: 8.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCard('Casier', Icons.lock,
                        '${_currentReservation!.locker.number}'),
                    _buildCard('Localisation', Icons.location_on,
                        _currentReservation!.locker.localisation.name),
                    _buildCard('Propriétaire', Icons.person,
                        '${_currentReservation!.owner.firstname} ${_currentReservation!.owner.lastname}'),
                    const SizedBox(height: 8),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Icon(Icons.group,
                            color: Theme.of(context).colorScheme.primary),
                        title: const Text('Membres',
                            style: TextStyle(fontSize: 16)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _currentReservation!.members.map((member) {
                            return Text(
                                '${member.firstname} ${member.lastname} (${member.email})',
                                style: const TextStyle(
                                    fontSize: 14));
                          }).toList(),
                        ),
                      ),
                    ),
                    _buildCard('Statut', Icons.info,
                        _translateStatus(_currentReservation!.status)),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          if (isMember) ...[
                            ElevatedButton(
                              onPressed: () async {
                                await _controller.retireFromLocker(context);
                                if (mounted) {
                                  await _initializeControllers();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Colors.red,
                              ),
                              child: const Text('Se retirer du casier'),
                            ),
                          ] else if (isOwner) ...[
                            ...[
                              ElevatedButton(
                                onPressed: () async {
                                  await _controller
                                      .terminateReservation(context);
                                  if (mounted) {
                                    await _initializeControllers();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(isPending
                                    ? 'Annuler la réservation'
                                    : 'Terminer la réservation'),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title,
            style: const TextStyle(fontSize: 16)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'accepted':
        return 'Acceptée';
      default:
        return status;
    }
  }

  Widget _buildReservationForm() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 500,
        maxHeight: MediaQuery.of(context).size.height *
            0.9,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaY: 4, sigmaX: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Réserver un casier',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _tabController == null
                      ? Container()
                      : TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabs: _controller.localisations.map((localisation) {
                            return Tab(
                              text: localisation.name,
                              icon: localisation.accessibility
                                  ? const Icon(Icons
                                      .wheelchair_pickup)
                                  : const Icon(Icons.accessibility),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _tabController == null
                        ? Container()
                        : TabBarView(
                            controller: _tabController,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            children:
                                _controller.localisations.map((localisation) {
                              final filteredLockers = _controller.lockers
                                  .where((locker) =>
                                      locker.localisation.name ==
                                      localisation.name)
                                  .toList();
                              return ListView(
                                children: <Widget>[
                                  Form(
                                    key: _controller.formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Wrap(
                                          spacing: 8.0,
                                          runSpacing:
                                              8.0,
                                          children:
                                              filteredLockers.map((locker) {
                                            final isAvailable =
                                                locker.status == 'available';
                                            final isSelected =
                                                _controller.selectedLockerId ==
                                                    locker.id;

                                            return GestureDetector(
                                              onTap: isAvailable
                                                  ? () {
                                                      setState(() {
                                                        _controller
                                                                .selectedLockerId =
                                                            locker.id;
                                                      });
                                                    }
                                                  : null,
                                              child: Container(
                                                width: 48.0,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: isAvailable
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Colors.red
                                                        : Colors.black,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${locker.number}',
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Choisir les utilisateurs',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        TextField(
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Rechercher un utilisateur',
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (query) {
                                            setState(() {
                                              _controller
                                                  .updateSearchQuery(query);
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 200,
                                          child: ListView(
                                            children: _controller.filteredUsers
                                                .map((user) {
                                              final isSelected = _controller
                                                  .selectedUsers
                                                  .contains(user);
                                              return CheckboxListTile(
                                                key: Key(user
                                                    .id),
                                                title: Text(
                                                    '${user.firstname} ${user.lastname} (${user.email})'),
                                                value: isSelected,
                                                onChanged: _controller
                                                                .selectedUsers
                                                                .length <
                                                            4 ||
                                                        isSelected
                                                    ? (value) async {
                                                        setState(() {
                                                          _controller
                                                              .onUserSelected(
                                                                  user, value!);
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
                                                  _controller.termsAccepted =
                                                      value!;
                                                });
                                              },
                                            ),
                                            Flexible(
                                              child: GestureDetector(
                                                onTap: () =>
                                                    _showTermsDialog(context),
                                                child: const Text(
                                                  'J\'accepte les termes et les conditions d\'utilisation',
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Colors
                                                        .blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: _controller.termsAccepted
                                              ? () async {
                                                  final result =
                                                      await _controller
                                                          .submitForm(context);
                                                  if (result) {
                                                    await _initializeControllers();
                                                  }
                                                }
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors
                                                .green,
                                          ),
                                          child: const Text('Réserver'),
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
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Règles pour le cadenas',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Cadenas à clés : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                          "Obligation de déposer un double de la clé à l'accueil.",
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text(
                        "Cadenas à code : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                          "Le code doit être partagé avec les membres de l'équipe et l'accueil.",
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          child: const Text('OK'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
