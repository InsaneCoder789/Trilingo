import 'package:flutter/material.dart';

class HotelBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Bookings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('This page is for Hotel Bookings'),
      ),
    );
  }
}
