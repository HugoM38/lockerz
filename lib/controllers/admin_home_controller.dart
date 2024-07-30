import 'package:flutter/material.dart';
import 'package:lockerz/models/localisation_model.dart';
import 'package:lockerz/services/localisation_service.dart';
import 'package:lockerz/services/locker_service.dart';
import 'package:lockerz/services/reservation_service.dart';
import '../../models/locker_model.dart';
import '../views/shared/snackbar.dart';

class AdminHomePageController {
  List<Locker> lockers = [];
  List<Localisation> localisations = [];

  Future<void> initialize() async {
    List<Locker> fetchedLockers = await LockerService().getLockers();

    lockers = fetchedLockers;
    localisations = await LocalisationService().getLocalisation();
  }

  Future<void> terminateReservation(
      BuildContext context, String reservationId) async {
    final result =
        await ReservationService().terminateReservation(reservationId);
    showCustomSnackBar(context, result ? 'Réservation terminée avec succès'
        : 'Erreur lors de la terminaison de la réservation');
  }
}
