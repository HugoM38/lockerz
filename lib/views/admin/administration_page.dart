import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/administration_item.dart';

import '../shared/navbar.dart';

class AdministrationPage extends StatefulWidget {
  @override
  _AdministrationPageState createState() => _AdministrationPageState();
}

class _AdministrationPageState extends State<AdministrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      body: ListView(
        children: const [
          AdministrationItem(
            title: 'Item 1',
            details: 'More details about item 1.',
          ),
          AdministrationItem(
            title: 'Item 2',
            details: 'More details about item 2.',
          ),
          // Add more items here
        ],
      ),
    );
  }
}
