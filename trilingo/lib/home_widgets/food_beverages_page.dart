import 'package:flutter/material.dart';

class FoodBeveragesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food and Beverages'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('This page is for Food and Beverages'),
      ),
    );
  }
}
