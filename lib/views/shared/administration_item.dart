import 'package:flutter/material.dart';
import 'package:lockerz/models/reservation_model.dart';
import '../../controllers/administration_controller.dart';

class AdministrationItem extends StatefulWidget {
  final Reservation reservation;
  final VoidCallback onRemove;

  const AdministrationItem({
    super.key,
    required this.reservation,
    required this.onRemove,
  });

  @override
  AdministrationItemState createState() => AdministrationItemState();
}

class AdministrationItemState extends State<AdministrationItem> {
  final AdministrationController _administrationController = AdministrationController();

  @override
  void initState() {
    super.initState();
    _administrationController.reservation = widget.reservation;
  }

  bool _isExpanded = false;

  Future<void> _showConfirmationDialog(String action) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text('Êtes-vous sûr de vouloir $action cette réservation ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop();
                if (action == 'valider') {
                  _administrationController.validate().then((success) {
                    if (success) {
                      widget.onRemove();
                    }
                  });
                } else {
                  _administrationController.refuse().then((success) {
                    if (success) {
                      widget.onRemove();
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${_administrationController.reservation.owner.firstname} ${_administrationController.reservation.owner.lastname} : Casier ${_administrationController.reservation.locker.number}",
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _showConfirmationDialog('valider');
                            },
                            child: const Text('Valider', style: TextStyle(color: Colors.green)),
                          ),
                          TextButton(
                            onPressed: () {
                              _showConfirmationDialog('refuser');
                            },
                            child: const Text('Refuser', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              body: ListTile(
                title: Text(
                  _administrationController.reservation.members.isEmpty
                      ? "Aucun membre en plus du propriétaire."
                      : "Membres: ${_administrationController.reservation.members.map((member) => "${member.firstname} ${member.lastname}").join(', ')}",
                  overflow: TextOverflow.clip,
                ),
              ),
              isExpanded: _isExpanded,
            ),
          ],
        ),
        const Divider(height: 1),
      ],
    );
  }
}
