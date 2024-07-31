import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lockerz/views/shared/navbar.dart';
import '../../controllers/signup_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignupController _signupController = SignupController();
  bool _acceptedCGU = false;

  @override
  void dispose() {
    _signupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double maxWidth = constraints.maxWidth < 400 ? constraints.maxWidth : 400;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: maxWidth,
                        child: buildSignupForm(context),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSignupForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Inscription",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                          shadows: [
                            const Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Prénom"),
                buildFirstNameField(context),
                const SizedBox(height: 20),
                const Text("Nom"),
                buildLastNameField(context),
                const SizedBox(height: 20),
                const Text("Email"),
                buildEmailField(context),
                const SizedBox(height: 20),
                const Text("Mot de passe"),
                buildPasswordField(context),
                const SizedBox(height: 20),
                buildCGUCheckbox(context),
                const SizedBox(height: 20),
                buildSignupButton(context),
                const SizedBox(height: 20),
                buildLoginButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFirstNameField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _signupController.firstnameController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.person,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildLastNameField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _signupController.lastnameController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.person,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildEmailField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _signupController.emailController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.mail,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
      child: TextFormField(
        controller: _signupController.passwordController,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
        obscureText: true,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.lock,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          fillColor: Theme.of(context).textTheme.bodyLarge!.color,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildCGUCheckbox(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _acceptedCGU,
          onChanged: (bool? value) {
            setState(() {
              _acceptedCGU = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showCGUPopup(context);
            },
            child: Text(
              "J'ai lu et j'accepte les Conditions Générales d'Utilisation",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCGUPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: SizedBox(
                  width: 300,
                  height: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Conditions Générales d\'Utilisation',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            'Bienvenue sur l\'application de réservation de casiers de notre école. En utilisant cette application, vous acceptez les présentes Conditions Générales d\'Utilisation (CGU). Veuillez les lire attentivement avant de procéder à l\'utilisation de l\'application.\n\n'
                            'L\'application de réservation de casiers est destinée à permettre aux étudiants de réserver des casiers en ligne de manière simple et efficace, tout en facilitant la gestion et l\'administration des casiers par les administrateurs.\n\n'
                            'Affichage des casiers : Les casiers disponibles sont affichés en vert. Les casiers réservés sont grisés et non sélectionnables.\n\n'
                            'Réservation : Sélection d\'un casier disponible. Saisie d\'au moins deux noms et prénoms pour confirmer la réservation. Validation de la réservation.\n\n'
                            'Règles associées aux cadenas : Cadenas à clés : Obligation de déposer un double de la clé à l\'accueil. Cadenas à code : Obligation de déposer le code à l\'accueil.\n\n'
                            'Validation des réservations : Confirmer ou refuser les demandes de réservation. Notification aux étudiants de la décision.\n\n'
                            'Gestion des casiers : Forcer la disponibilité d\'un casier à "disponible" ou "occupé". Visualisation des casiers : Disponible : Casier affiché en vert. Occupé : Casier affiché en grisé avec les noms et prénoms des étudiants qui l\'occupent.\n\n'
                            'Protection des données personnelles : Collecte des données : L\'application collecte les noms, prénoms et adresses email des utilisateurs pour les besoins de la réservation et de la gestion des casiers. Utilisation des données : Les données personnelles sont utilisées uniquement pour la gestion des réservations de casiers. Stockage des données : Les données sont stockées de manière sécurisée et ne sont accessibles qu\'aux administrateurs autorisés. Consentement : En utilisant l\'application, vous consentez explicitement au traitement de vos données personnelles. Droits des utilisateurs : Vous avez le droit d\'accéder, de rectifier et de supprimer vos données personnelles. Pour exercer ces droits, veuillez contacter l\'administration de l\'école. Sécurité des données : Nous avons mis en place des mesures de sécurité appropriées pour protéger vos données contre les accès non autorisés, la perte ou la divulgation.\n\n'
                            'Utilisation des cookies : Fonctionnement des cookies : L\'application utilise des cookies essentiels pour assurer son bon fonctionnement et améliorer votre expérience utilisateur. Respect de la vie privée : Nous respectons votre vie privée et ne partageons aucune donnée personnelle avec des tiers. Consentement aux cookies : En utilisant cette application, vous consentez à l\'utilisation des cookies.\n\n'
                            'Inscription et Authentification : Vérification d\'email : L\'inscription requiert l\'utilisation d\'une adresse email en \'@myges.fr\'. Sécurité des comptes : Les mots de passe doivent respecter des exigences de sécurité élevées pour protéger les informations personnelles.\n\n'
                            'Responsabilité de l\'utilisateur : Exactitude des informations : Les utilisateurs sont responsables de l\'exactitude des informations fournies lors de la réservation. Utilisation appropriée : L\'utilisation de l\'application doit être conforme aux règles de l\'école et aux lois en vigueur.\n\n'
                            'Modifications des CGU : Révisions des CGU : Nous nous réservons le droit de modifier les présentes CGU à tout moment. Les utilisateurs seront informés de toute modification importante.\n\n'
                            'Contact : Support : Pour toute question ou assistance, veuillez contacter le support technique ou l\'administration de l\'école.\n\n'
                            'En utilisant cette application, vous acceptez les présentes Conditions Générales d\'Utilisation et vous vous engagez à les respecter. Merci d\'utiliser notre application de réservation de casiers et de contribuer à la gestion efficace des ressources de notre école.',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSignupButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: _acceptedCGU
            ? () {
                _signupController.signUp(context);
              }
            : null,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "S'inscrire",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            "/login",
          );
        },
        child: Text(
          "Vous avez déjà un compte ? Connectez-vous !",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                shadows: [
                  const Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
