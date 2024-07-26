import 'package:lockerz/services/reservation_service.dart';
import '../models/reservation_model.dart';

class AdministrationController {
  late Reservation reservation;

  final ReservationService _reservationService = ReservationService();

  Future<bool> validate() async {
    final success = await _reservationService.valideToRefuseReservation(reservation.id, "accepted");
    return success;
  }

  Future<bool> refuse() async {
    final success = await _reservationService.valideToRefuseReservation(reservation.id, "refused");
    return success;
  }
}
