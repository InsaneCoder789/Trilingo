import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final User? user;

  ProfilePage({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set the background color to black
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
                radius: 60,
              ),
              SizedBox(height: 20),
              Text(
                user?.displayName ?? 'Guest',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set text color to white
                ),
              ),
              SizedBox(height: 10),
              Text(
                user?.email ?? 'guest@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              // Add more user information fields as needed
            ],
          ),
        ),
      ),
    );
  }
}
