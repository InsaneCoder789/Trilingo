import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void handleSignup(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('Sign-Up Successful! User ID: ${userCredential.user!.uid}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-Up Successful!')),
      );
      Navigator.pushNamed(context, '/');
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-Up Failed. Please try again.')),
      );
    }
  }

  void handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in canceled')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Successful')),
      );

      Navigator.pushNamed(context, '/');
    } catch (e) {
      print('Google Sign-In Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/signuppage.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.only(top: 5),
                width: 400,
                height: 580,
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/images/welcome_image.png'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Welcome!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 238, 240, 243),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            TextField(
                              controller: fullNameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  LineIcons.userAlt,
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: emailController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  LineIcons.envelope,
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: passwordController,
                              style: TextStyle(color: Colors.white),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  LineIcons.lock,
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                handleSignup(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 0, 136, 255),
                                elevation: 45,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40),
                                minimumSize: Size(350, 0),
                              ),
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => handleGoogleSignIn(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 24),
                                minimumSize: Size(350, 0),
                              ),
                              icon: Icon(LineIcons.googleLogo, size: 20),
                              label: Text(
                                'Sign up with Google',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
