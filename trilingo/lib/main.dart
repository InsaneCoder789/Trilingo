import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  runApp(MyApp(googleSignIn: _googleSignIn));
}

class MyApp extends StatelessWidget {
  final GoogleSignIn googleSignIn;

  MyApp({required this.googleSignIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trilingo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
      home: ImageSplashScreen(
        googleSignIn: googleSignIn,
      ),
      routes: {
        '/signup': (context) => SignupPage(googleSignIn: googleSignIn),
        '/home': (context) =>
            HomePage(user: ModalRoute.of(context)?.settings.arguments as User?),
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
  @override
  void initState() {
    super.initState();
    // Delay the splash screen for 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(googleSignIn: widget.googleSignIn),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurpleAccent, // Updated background color
      child: Center(
        child: Image.asset(
          'assets/images/Trilingo-image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
