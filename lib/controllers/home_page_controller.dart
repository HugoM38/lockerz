import 'package:flutter/material.dart';
import 'package:lockerz/models/user_model.dart';
import 'package:lockerz/services/locker_service.dart';
import 'package:lockerz/services/user_service.dart';
import 'package:lockerz/services/reservation_service.dart';
import 'package:lockerz/utils/shared_prefs.dart';
import '../../models/locker_model.dart';

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
}
