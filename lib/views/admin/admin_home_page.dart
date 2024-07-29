import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/navbar.dart';
import '/controllers/home_page_controller.dart';
import 'package:lockerz/models/reservation_model.dart';
import 'package:lockerz/services/reservation_service.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> {
  late HomePageController _controller;
  Reservation? _userReservation;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
    _initializeControllers();
    _loadUserReservation();
  }

  Future<void> _initializeControllers() async {
    await _controller.initialize();
    setState(() {});
  }

  Future<void> _loadUserReservation() async {
    final reservation = await ReservationService().getCurrentReservation();
    setState(() {
      _userReservation = reservation;
    });
  }

  void _showLockerHistory(BuildContext context, String lockerId, bool isAvailable) async {
    List<String> history = await ReservationService().getLockerHistory(lockerId);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Historique du casier'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(history[index]),
                      );
                    },
                  ),
                ),
                if (!isAvailable)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _cancelReservation(lockerId);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Annuler la réservation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
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

  Future<void> _cancelReservation(String lockerId) async {
    bool success = await ReservationService().valideToRefuseReservation(lockerId, 'available');
    if (success) {
      setState(() {
        // Update the state to reflect the changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _controller.localisations.length,
      child: Scaffold(
        appBar: const NavBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _userReservation != null ? _buildReservationInfo() : _buildReservationForm(),
        ),
      ),
    );
  }

  Widget _buildReservationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Locker Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Locker Number: ${_userReservation!.locker.number}'),
        Text('Locker Status: ${_userReservation!.locker.status}'),
        Text('Locker Localisation: ${_userReservation!.locker.localisation.name}'),
        const SizedBox(height: 20),
        const Text(
          'Reservation Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text('Reservation Status: ${_userReservation!.status}'),
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
                            crossAxisCount: 10,
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
                              onTap: () {
                                _showLockerHistory(context, locker.id, isAvailable);
                              },
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
