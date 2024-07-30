import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/navbar.dart';
import '/controllers/home_page_controller.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/models/reservation_model.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  AdminHomePageState createState() => AdminHomePageState();
}

class AdminHomePageState extends State<AdminHomePage> with TickerProviderStateMixin {
  late HomePageController _controller;
  Reservation? _currentReservation;
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = HomePageController();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    _currentReservation = await ReservationService().getCurrentReservation();
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
                            Form(
                              key: GlobalKey<FormState>(),
                              child: Column(
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
                                    itemCount: filteredLockers.length,
                                    itemBuilder: (BuildContext context, int index) {
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
                    onPressed: () async {
                      await _controller.terminateReservation(context);
                      await _initializeControllers();
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
}
