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
import '../views/shared/snackbar.dart';

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
        showCustomSnackBar(context, 'Veuillez sélectionner un casier.');
        return false;
      }
      if (!termsAccepted) {
        showCustomSnackBar(
            context, 'Veuillez accepter les termes d\'utilisation.');
        return false;
      }

      final result = await ReservationService().createReservation(
        selectedLockerId!,
        selectedUsers.map((u) => u.id).toList(),
      );

      if (context.mounted) {
        showCustomSnackBar(
            context,
            result
                ? 'Formulaire soumis avec succès!'
                : 'Erreur lors de la création de la réservation');
      }
      if (result) {
        resetForm();
      }
      return result;
    }
    return false;
  }

  Future<void> terminateReservation(BuildContext context) async {
    if (currentReservation != null) {
      final result = await ReservationService()
          .terminateReservation(currentReservation!.id);
      if (context.mounted) {
        showCustomSnackBar(
            context,
            result
                ? 'Réservation terminée avec succès!'
                : 'Erreur de lors de la terminaison de votre réservation');
      }
      if (result) {
        resetForm();
      }
    } else {
      showCustomSnackBar(context, 'Aucune réservation en cours.');
    }
  }

  Future<void> cancelReservation(BuildContext context) async {
    if (currentReservation != null) {
      final result = await ReservationService()
          .terminateReservation(currentReservation!.id);
      if (context.mounted) {
        showCustomSnackBar(
            context,
            result
                ? 'Réservation annulée avec succès!'
                : 'Erreur lors de l\'annulation de votre réservation');
      }
      if (result) {
        resetForm();
      }
    }
  }

  Future<void> retireFromLocker(BuildContext context) async {
    if (currentReservation != null) {
      final result =
          await ReservationService().leaveReservation(currentReservation!.id);
      if (context.mounted) {
        showCustomSnackBar(
            context,
            result
                ? 'Vous vous êtes retiré du casier avec succès!'
                : 'Erreur de lors du votre retrait du casier');
      }
      if (result) {
        resetForm();
      }
    }
  }

  void resetForm() {
    selectedLockerId = null;
    selectedUsers.clear();
    termsAccepted = false;
    currentReservation = null;
  }
}
