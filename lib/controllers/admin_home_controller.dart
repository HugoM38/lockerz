import 'package:lockerz/models/localisation_model.dart';
import 'package:lockerz/services/localisation_service.dart';
import 'package:lockerz/services/locker_service.dart';
import '../../models/locker_model.dart';

class AdminHomePageController {
  List<Locker> lockers = [];
  List<Localisation> localisations = [];

  Future<void> initialize() async {
    List<Locker> fetchedLockers = await LockerService().getLockers();

    lockers = fetchedLockers;
    localisations = await LocalisationService().getLocalisation();

  }
}
