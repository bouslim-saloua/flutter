import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart'; // Importation du Provider pour gérer les favoris
import 'auth_screen.dart';
import 'produits_list.dart';
import 'profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyADEzNxD_gy46aGk51lsSZBdi338GiHDv0',
      appId: '1:1050821731069:web:5f95fcebf0c8ed7bff1494',
      messagingSenderId: '1050821731069',
      projectId: 'atelier-s-bouslim-iir5g7',
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FavoritesProvider()), // Fournisseur pour les favoris
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/auth': (context) => const AuthScreen(),
        '/products': (context) => const ProduitsList(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const ProduitsList();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
