import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/controllers/admin_home_controller.dart';
import 'package:lockerz/views/shared/navbar.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/models/reservation_model.dart';
import 'package:lockerz/services/locker_service.dart';

import '../shared/snackbar.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage>
    with TickerProviderStateMixin {
  late AdminHomePageController _controller;
  bool _isLoading = true;
  TabController? _tabController;
  final LockerService _lockerService = LockerService();

  @override
  void initState() {
    super.initState();
    _controller = AdminHomePageController();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
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
            child: _buildLockerManagement(),
          ),
        ),
      ),
    );
  }

  void _showAddLockerPopup(BuildContext context, String localisationId) {
    TextEditingController numberController = TextEditingController();
    double popupWidth = MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.width * 0.5
        : MediaQuery.of(context).size.width * 0.9;

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
                    maxWidth: popupWidth,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          'Ajouter un nouveau casier',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: numberController,
                        decoration: const InputDecoration(
                          labelText: 'Numéro du casier',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _createLocker(context, numberController.text,
                                  localisationId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Ajouter'),
                          ),
                          TextButton(
                            child: const Text('Fermer'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
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

  Future<void> _createLocker(
      BuildContext context, String number, String localisationId) async {
    final int lockerNumber = int.tryParse(number) ?? -1;
    if (lockerNumber == -1) {
      showCustomSnackBar(context, 'Veuillez entrer un numéro de casier valide');
      return;
    }

    final Map<String, dynamic> lockerData = {
      'number': lockerNumber,
      'localisation': localisationId,
    };

    final success = await _lockerService.createLocker(lockerData);

    if (context.mounted) {
      if (success) {
        showCustomSnackBar(context, 'Casier ajouté avec succès');
        if (mounted) {
          Navigator.of(context).pop();
          await _initializeControllers();
        }
      } else {
        showCustomSnackBar(context, 'Erreur lors de l\'ajout du casier');
      }
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
                  _tabController == null
                      ? Container()
                      : TabBar(
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
                    child: _tabController == null
                        ? Container()
                        : TabBarView(
                            controller: _tabController,
                            physics: const NeverScrollableScrollPhysics(),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Wrap(
                                          spacing: 8.0,
                                          runSpacing:
                                              8.0,
                                          children: [
                                            ...filteredLockers.map((locker) {
                                              final isAvailable =
                                                  locker.status == 'available';
                                              return GestureDetector(
                                                onTap: () {
                                                  _showLockerHistory(context,
                                                      locker.id, isAvailable);
                                                },
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
                                                      color: Colors.black,
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
                                            }),
                                            GestureDetector(
                                              onTap: () {
                                                _showAddLockerPopup(
                                                    context, localisation.id);
                                              },
                                              child: Container(
                                                width: 48.0,
                                                height: 48.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
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
                                            ),
                                          ],
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

  void _showLockerHistory(
      BuildContext context, String lockerId, bool isAvailable) async {
    List<Reservation> history =
        await ReservationService().getLockerHistory(lockerId);
    if (context.mounted) {
      double popupWidth = MediaQuery.of(context).size.width > 600
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.9;

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
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.circular(15),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: popupWidth,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(
                          child: Text(
                            'Réservations du casier',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.6,
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: history.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final reservation = history[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.1),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${reservation.owner.firstname} ${reservation.owner.lastname}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(_translateStatus(
                                                  reservation.status)),
                                            ],
                                          ),
                                          Text(reservation.owner.email),
                                          ExpansionTile(
                                            title: const SizedBox.shrink(),
                                            children: reservation.members
                                                .map((member) {
                                              return ListTile(
                                                title: Text(
                                                    '${member.firstname} ${member.lastname} (${member.email})'),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (!isAvailable &&
                            history.isNotEmpty &&
                            (history.last.status == 'accepted' ||
                                history.last.status == 'pending'))
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _controller.terminateReservation(
                                      context, history.last.id);
                                  if (mounted) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      await _initializeControllers();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Annuler la réservation'),
                              ),
                            ),
                          ),
                        if (!isAvailable &&
                            (history.isEmpty ||
                                (history.last.status == 'refused' ||
                                    history.last.status == 'terminated')))
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _controller.changeLockerStatus(
                                      context, lockerId, 'available');
                                  if (mounted) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      await _initializeControllers();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Déverouiller le casier'),
                              ),
                            ),
                          ),
                        if (isAvailable)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _controller.changeLockerStatus(
                                      context, lockerId, 'unavailable');
                                  if (mounted) {
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                      await _initializeControllers();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Verouiller le casier'),
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
