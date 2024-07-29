import 'package:flutter/material.dart';
import 'package:lockerz/models/user_model.dart';
import 'package:lockerz/services/locker_service.dart';
import 'package:lockerz/services/user_service.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import '../../models/locker_model.dart';
import '../../models/reservation_model.dart';

class HomePageController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedLockerId;
  List<User> users = [];
  List<User> filteredUsers = [];
  List<User> selectedUsers = [];
  String searchQuery = '';
  bool termsAccepted = false;
  List<Locker> lockers = [];
  List<String> localisations = [];
  User? currentUser;
  Reservation? currentReservation;

  Future<void> initialize() async {
    // Récupérer l'utilisateur connecté
    currentUser = await SharedPrefs.getUser();

    // Récupérer les utilisateurs et casiers
    List<User> fetchedUsers = await UserService().getUsers();
    List<Locker> fetchedLockers = await LockerService().getLockers();

    users = fetchedUsers.where((user) => user.id != currentUser?.id).toList();
    filteredUsers = users;
    lockers = fetchedLockers;
    localisations = lockers.map((locker) => locker.localisation.name).toSet().toList();

    // Récupérer la réservation actuelle
    currentReservation = await ReservationService().getCurrentReservation();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    filteredUsers = users
        .where((user) =>
    user.firstname.toLowerCase().contains(query.toLowerCase()) ||
        user.lastname.toLowerCase().contains(query.toLowerCase()) ||
        user.email.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void onUserSelected(User user, bool isSelected) {
    if (isSelected) {
      if (selectedUsers.length < 4) {
        selectedUsers.add(user);
      }
    } else {
      selectedUsers.remove(user);
    }
  }

  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      if (selectedLockerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un casier.')),
        );
        return;
      }
      if (!termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez accepter les termes d\'utilisation.')),
        );
        return;
      }

      final result = await ReservationService().createReservation(
        selectedLockerId!,
        selectedUsers.map((u) => u.id).toList(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Formulaire soumis avec succès!' : 'Erreur de création de réservation'),
        ),
      );
    }
  }

  Future<void> terminateReservation(BuildContext context) async {
    if (currentReservation != null) {
      final result = await ReservationService().terminateReservation(currentReservation!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Réservation terminée avec succès!' : 'Erreur de terminaison de réservation'),
        ),
      );
    }
  }

  Future<void> cancelReservation(BuildContext context) async {
    if (currentReservation != null) {
      final result = await ReservationService().terminateReservation(currentReservation!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Réservation annulée avec succès!' : 'Erreur d\'annulation de réservation'),
        ),
      );
    }
  }

  Future<void> retireFromLocker(BuildContext context) async {
    if (currentReservation != null) {
      final result = await ReservationService().leaveReservation(currentReservation!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result ? 'Vous vous êtes retiré du casier avec succès!' : 'Erreur de retrait du casier'),
        ),
      );
    }
  }
}
