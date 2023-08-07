import 'package:flutter/material.dart';

class HomeOptionWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;

  HomeOptionWidget({
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the new page for this option
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OptionPage(title: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              imageAsset,
              height: 150, // Adjust the image height as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionPage extends StatelessWidget {
  final String title;

  OptionPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This page is for - $title'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          'Content for $title goes here!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
