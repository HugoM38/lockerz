import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/controllers/admin_home_controller.dart';
import 'package:lockerz/views/shared/navbar.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/models/reservation_model.dart';
import 'package:lockerz/services/locker_service.dart'; 

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> with TickerProviderStateMixin {
  late AdminHomePageController _controller;
  bool _isLoading = true;
  late TabController _tabController;
  final LockerService _lockerService = LockerService(); // Instance du service LockerService

  @override
  void initState() {
    super.initState();
    _controller = AdminHomePageController();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    await _controller.initialize();
    _tabController = TabController(length: _controller.localisations.length, vsync: this);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            child: _buildLockerManagement(),
          ),
        ),
      ),
    );
  }

  void _showAddLockerPopup(BuildContext context, String localisationId) {
    TextEditingController _numberController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un nouveau casier'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Numéro du casier',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _createLocker(context, _numberController.text, localisationId);
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _createLocker(BuildContext context, String number, String localisationId) async {
    final int lockerNumber = int.tryParse(number) ?? -1;
    if (lockerNumber == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un numéro de casier valide')),
      );
      return;
    }

    final Map<String, dynamic> lockerData = {
      'number': lockerNumber,
      'localisation': localisationId,
    };

    print('Données envoyées : $lockerData'); // Afficher les données dans la console

    final success = await _lockerService.createLocker(lockerData);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Casier ajouté avec succès')),
      );
      Navigator.of(context).pop();
      await _initializeControllers(); // Rafraîchir les données après ajout
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du casier')),
      );
    }
  }

  Widget _buildLockerManagement() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 500,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
            filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Gestion des casiers',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: _controller.localisations.map((localisation) {
                      return Tab(
                        text: localisation.name,
                        icon: localisation.accessibility
                            ? const Icon(Icons.wheelchair_pickup)
                            : const Icon(Icons.accessibility),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _controller.localisations.map((localisation) {
                        final filteredLockers = _controller.lockers
                            .where((locker) => locker.localisation.name == localisation.name)
                            .toList();
                        return ListView(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 10,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  itemCount: filteredLockers.length + 1, // Add one more item for the "+" button
                                  itemBuilder: (BuildContext context, int index) {
                                    if (index == filteredLockers.length) {
                                      return GestureDetector(
                                        onTap: () {
                                          _showAddLockerPopup(context, localisation.id);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,

                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final locker = filteredLockers[index];
                                    final isAvailable = locker.status == 'available';

                                    return GestureDetector(
                                      onTap: () {
                                        _showLockerHistory(context, locker.id, isAvailable);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isAvailable ? Colors.green : Colors.grey,
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Colors.black,
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
                                ],
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

  void _showLockerHistory(BuildContext context, String lockerId, bool isAvailable) async {
    List<Reservation> history = await ReservationService().getLockerHistory(lockerId);
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
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          'Réservations du casier',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: history.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final reservation = history[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).colorScheme.primary),
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    ),
                                    child: ExpansionTile(
                                      title: Text('${reservation.owner.firstname} ${reservation.owner.lastname} (${reservation.owner.email})'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(_translateStatus(reservation.status)),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                      children: reservation.members.map((member) {
                                        return ListTile(
                                          title: Text('${member.firstname} ${member.lastname} (${member.email})'),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isAvailable)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                await _controller.terminateReservation(context, history.last.id);
                                await _initializeControllers();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Annuler la réservation'),
                            ),
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

  String _translateStatus(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'accepted':
        return 'Acceptée';
      case 'refused':
        return 'Rejetée';
      case 'terminated':
        return 'Terminée';
      default:
        return status;
    }
  }
}
