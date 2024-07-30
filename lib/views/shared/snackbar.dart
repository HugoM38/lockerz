import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white), // Texte en blanc
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white), // Icône de fermeture en blanc
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.8), // Fond plus clair
      duration: const Duration(seconds: 3),
    ),
  );
}
