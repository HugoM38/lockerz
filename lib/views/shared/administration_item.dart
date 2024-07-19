import 'package:flutter/material.dart';

class AdministrationItem extends StatefulWidget {
  final String title;
  final String details;

  const AdministrationItem({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  _AdministrationItemState createState() => _AdministrationItemState();
}

class _AdministrationItemState extends State<AdministrationItem> {
  bool _isExpanded = false;

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
                      Text(widget.title),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              // API Accept Request
                              debugPrint("Valider Reservation");
                            },
                            child: const Text('Valider', style: TextStyle(color: Colors.green)),
                          ),
                          TextButton(
                            onPressed: () {
                              // API Refuse Request
                              debugPrint("Refuser Reservation");
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
                title: Text(widget.details),
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
