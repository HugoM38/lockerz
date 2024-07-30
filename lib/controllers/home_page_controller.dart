import 'package:flutter/material.dart';
import 'package:lockerz/models/localisation_model.dart';
import 'package:lockerz/models/user_model.dart';
import 'package:lockerz/services/localisation_service.dart';
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
  List<Localisation> localisations = [];
  User? currentUser;
  Reservation? currentReservation;
  bool get isAnyUserSelected => selectedUsers.isNotEmpty;

  Future<void> initialize() async {
    currentUser = await SharedPrefs.getUser();

    List<User> fetchedUsers = await UserService().getUsers();
    List<Locker> fetchedLockers = await LockerService().getLockers();

    users = fetchedUsers.where((user) => user.id != currentUser?.id).toList();
    filteredUsers = users;
    lockers = fetchedLockers;
    localisations = await LocalisationService().getLocalisation();

    currentReservation = await ReservationService().getCurrentReservation();

    updateSearchQuery('');
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

  Future<bool> submitForm(BuildContext context) async {
  if (formKey.currentState?.validate() ?? false) {
    if (selectedLockerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un casier.')),
      );
      return false;
    }
    if (!termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez accepter les termes d\'utilisation.')),
      );
      return false;
    }
    if (!isAnyUserSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez sélectionner au moins un utilisateur.')),
      );
      return false;
    }

    final result = await ReservationService().createReservation(
      selectedLockerId!,
      selectedUsers.map((u) => u.id).toList(),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result
              ? 'Formulaire soumis avec succès!'
              : 'Erreur de création de réservation'),
        ),
      );
    }
    return result;
  }
  return false;
}

  Future<void> terminateReservation(BuildContext context) async {
  if (currentReservation != null) {
    final result = await ReservationService()
        .terminateReservation(currentReservation!.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result
            ? 'Réservation terminée avec succès!'
            : 'Erreur de terminaison de réservation'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aucune réservation en cours.'),
      ),
    );
  }
}


  Future<void> cancelReservation(BuildContext context) async {
    if (currentReservation != null) {
      final result = await ReservationService()
          .terminateReservation(currentReservation!.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result
                ? 'Réservation annulée avec succès!'
                : 'Erreur d\'annulation de réservation'),
          ),
        );
      }
    }
  }

  Future<void> retireFromLocker(BuildContext context) async {
    if (currentReservation != null) {
      final result =
          await ReservationService().leaveReservation(currentReservation!.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result
                ? 'Vous vous êtes retiré du casier avec succès!'
                : 'Erreur de retrait du casier'),
          ),
        );
      }
    }
  }
}
