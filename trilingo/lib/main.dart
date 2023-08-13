import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'signup_page.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trilingo/welcome_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trilingo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blueAccent,
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => ImageSplashScreen(googleSignIn: googleSignIn),
        '/welcome': (context) => WelcomePage(googleSignIn: googleSignIn),
        '/signup': (context) => SignupPage(),
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
          builder: (context) => WelcomePage(googleSignIn: widget.googleSignIn),
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
