import 'package:flutter/material.dart';
import 'package:lockerz/views/edit_account_page.dart';
import '../admin/administration_page.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Lockerz", style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: () => {
            debugPrint("Administration"),
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AdministrationPage()),
            )
          },
          child: const Text(
            'Administration',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () => {
            debugPrint("Mon Compte"),
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => const EditAccountPage()),
            )
          },
          child: const Text(
            'Mon Compte',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

