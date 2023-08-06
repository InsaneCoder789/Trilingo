import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // Create an instance of GoogleSignIn
  runApp(MyApp(googleSignIn: _googleSignIn));
}

class MyApp extends StatelessWidget {
  final GoogleSignIn googleSignIn;

  MyApp({required this.googleSignIn});
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Signup Pages',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(googleSignIn: googleSignIn),
        '/signup': (context) => SignupPage(googleSignIn: googleSignIn),
        '/home': (context) => HomePage(
            name: ModalRoute.of(context)?.settings.arguments as String),
      },
    );
  }
}
