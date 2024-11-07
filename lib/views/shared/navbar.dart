import 'package:flutter/material.dart';
import 'package:lockerz/controllers/auth_controller.dart';
import 'package:lockerz/models/user_model.dart';
import 'package:lockerz/utils/shared_prefs.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({
    super.key,
  });

  Future<User?> _getUser() async {
    try {
      return await SharedPrefs.getUser();
    } catch (e) {
      return null;
    }
  }

  Future<bool> _isLoggedIn() async {
    return await AuthController().isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        children: [
          TextButton(
            onPressed: () => {
              Navigator.pushReplacementNamed(
                context,
                "/home",
              )
            },
            child: Image.asset('assets/images/eductive_logo.png',
              width: 100,
              height: 50,
              fit: BoxFit.cover
            )
          ),
          const Spacer(),
          FutureBuilder<bool>(
            future: _isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (snapshot.hasData && snapshot.data == true) {
                return FutureBuilder<User?>(
                  future: _getUser(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    } else if (userSnapshot.hasData) {
                      final user = userSnapshot.data;
                      return Row(
                        children: [
                          if (user?.role == 'admin') ...[
                            TextButton(
                              onPressed: () => {
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/admin",
                                )
                              },
                              child: const Text(
                                'Administration',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          TextButton(
                            onPressed: () => {
                              Navigator.pushReplacementNamed(
                                context,
                                "/account",
                              )
                            },
                            child: const Text(
                              'Mon Compte',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                await AuthController().logout(context);
                              },
                              icon: const Icon(Icons.logout, color: Colors.white)),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
