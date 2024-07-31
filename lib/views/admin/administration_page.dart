import 'package:flutter/material.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/views/shared/administration_item.dart';
import '../../models/reservation_model.dart';
import '../shared/navbar.dart';

class AdministrationPage extends StatefulWidget {
  const AdministrationPage({super.key});

  @override
  AdministrationPageState createState() => AdministrationPageState();
}

class AdministrationPageState extends State<AdministrationPage> {
  List<Reservation> reservations = [];

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  Future<void> _initializeValues() async {
    final getReservations = await ReservationService().getReservation();
    setState(() {
      reservations = getReservations;
    });
  }

  void _removeReservation(String reservationId) {
    setState(() {
      reservations.removeWhere((reservation) => reservation.id == reservationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liste des réservations en attente',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                reservations.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            'Aucune réservation en attente',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: reservations.length,
                          itemBuilder: (context, index) {
                            return AdministrationItem(
                              key: ValueKey(reservations[index].id),
                              reservation: reservations[index],
                              onRemove: () => _removeReservation(reservations[index].id),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
