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

  void _removeReservation(Reservation reservation) {
    setState(() {
      reservations.remove(reservation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: ListView(
        children: <Widget>[
          for (var item in reservations)
            AdministrationItem(
              reservation: item,
              onRemove: () => _removeReservation(item),
            ),
        ],
      ),
    );
  }
}
