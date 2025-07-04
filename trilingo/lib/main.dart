import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup_page.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("⏳ Initializing Firebase...");

  try {
    await Firebase.initializeApp().timeout(
      Duration(seconds: 10),
      onTimeout: () {
        print("⛔ Firebase.init timed out after 10 seconds");
        throw TimeoutException("Firebase initialization timed out");
      },
    );
    print("✅ Firebase initialized successfully");

    FirebaseFirestore.instance.settings = const Settings(
      host: 'nam5-firestore.googleapis.com',
      sslEnabled: true,
      persistenceEnabled: true,
    );

    print("🛰 Firestore settings applied for region nam5");

    final user = FirebaseAuth.instance.currentUser;
    print("🔐 FirebaseAuth current user: ${user?.email ?? 'Not signed in'}");
  } catch (e, stackTrace) {
    print("❌ Firebase initialization failed: $e");
    print(stackTrace);
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  runApp(MyApp(googleSignIn: _googleSignIn));
}

class MyApp extends StatelessWidget {
  final GoogleSignIn googleSignIn;

  MyApp({required this.googleSignIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trilingo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromARGB(255, 168, 208, 235),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ImageSplashScreen(googleSignIn: googleSignIn),
        '/welcome': (context) => Onboarding1Widget(),
        '/signup': (context) => SignupPage(),
        '/home': (context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  final user = args is User ? args : null;
  return HomePage(user: user);
},
        },
    );
  }
}

class ImageSplashScreen extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  ImageSplashScreen({required this.googleSignIn});

  @override
  _ImageSplashScreenState createState() => _ImageSplashScreenState();
}

class _ImageSplashScreenState extends State<ImageSplashScreen> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        opacity = 0.0;
      });
      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return Onboarding1Widget();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            },
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 168, 208, 235),
      child: Center(
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            'assets/images/welcome_image.png',
            fit: BoxFit.cover,
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
