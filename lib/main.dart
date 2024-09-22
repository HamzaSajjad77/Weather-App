import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/LoginRegister/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA8f1cIdlPrUyKLo38TaZ84ret-WbZ8BQk",
            authDomain: "weatherapp-1af42.firebaseapp.com",
            projectId: "weatherapp-1af42",
            storageBucket: "weatherapp-1af42.appspot.com",
            messagingSenderId: "1091683592784",
            appId: "1:1091683592784:web:3ae609d5bb914592a27f55"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weatherly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthCheck(), // Set the AuthCheck widget as the home
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the user is logged in, navigate to the HomeScreen
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const MyLogin(); // Not logged in, show login screen
          } else {
            return const HomeScreen(); // Logged in, show home screen
          }
        }
        // Show loading indicator while checking auth status
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
