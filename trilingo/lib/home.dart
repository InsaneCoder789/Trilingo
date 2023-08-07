import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_options.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  final User? user;

  HomePage({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 0, 0, 0), // Set the background color to black
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trilingo'),
          backgroundColor: Colors.deepPurple,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(user?.displayName ?? 'Guest'),
                accountEmail: Text(user?.email ?? 'guest@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(user?.photoURL ?? ''),
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  // Handle tapping on home option
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(user: user), // Use the ProfilePage class
                    ),
                  );
                },
              ),
              // Add more options as needed
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to Flight Bookings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightBookingsPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Colors.amber, // Set the widget box color to dark purple
                    borderRadius: BorderRadius.circular(12), // Rounded edges
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/flight_booking.png',
                        height: 120, // Adjust image size
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Flight Bookings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Book your flights with ease and discover exciting destinations.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // Set text color to white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to Hotel Bookings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelBookingsPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .blueAccent, // Set the widget box color to dark purple
                    borderRadius: BorderRadius.circular(12), // Rounded edges
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/hotel_booking.png',
                        height: 120, // Adjust image size
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Hotel Bookings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Find the perfect hotels for your stay and enjoy a comfortable experience.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // Set text color to white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to Language Translator page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageTranslatorPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .tealAccent, // Set the widget box color to dark purple
                    borderRadius: BorderRadius.circular(12), // Rounded edges
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/language_translator.png',
                        height: 120, // Adjust image size
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Language Translator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Translate between different languages and communicate effortlessly.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // Set text color to white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to Food and Beverages page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodBeveragesPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors
                        .deepOrangeAccent, // Set the widget box color to dark purple
                    borderRadius: BorderRadius.circular(12), // Rounded edges
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/food_beverages.png',
                        height: 120, // Adjust image size
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Food and Beverages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Explore a variety of delicious cuisines and quench your thirst with refreshing drinks.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white, // Set text color to white
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Create separate pages for each widget
class FlightBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Bookings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('This page is for Flight Bookings'),
      ),
    );
  }
}

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

class LanguageTranslatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translator'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text('This page is for Language Translator'),
      ),
    );
  }
}

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
