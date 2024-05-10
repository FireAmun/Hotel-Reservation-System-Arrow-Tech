import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:hotel/features/app/splash_screen/splash_screen.dart';
import 'package:hotel/features/user_auth/presentation/pages/forgot_password_page.dart';
import 'package:hotel/features/user_auth/presentation/pages/home_page.dart';
import 'package:hotel/features/user_auth/presentation/pages/login_page.dart';
import 'package:hotel/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:hotel/features/user_auth/presentation/pages/user_profile_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAPHNhecjmxAmzR4FaKE1JU0D2BpOvhxGM",
        appId: "1:749942083161:web:a4d73ab9fb50bf68d4eb48",
        messagingSenderId: "749942083161",
        projectId: "hotel-d4fc4",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Reservation System',
      routes: {
        '/': (context) => const SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/User': (context) => UserProfilePage(),
        '/Forget Password': (context) => const ForgotPasswordPage(),
      },
    );
  }
}
