import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'package:trilingo/home_widgets/flight_bookings_page.dart';
import 'package:trilingo/home_widgets/food_beverages_page.dart';
import 'package:trilingo/home_widgets/hotel_bookings_page.dart';
import 'package:trilingo/home_widgets/language_translator_page.dart';

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
          backgroundColor: Colors.deepOrangeAccent,
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
                  color: Colors.deepPurpleAccent,
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
                child: _buildCategoryContainer(
                  'assets/images/flight_booking.png',
                  'Flight Bookings',
                  'Book your flights with ease and discover exciting destinations.',
                  Colors.amber,
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
                child: _buildCategoryContainer(
                  'assets/images/hotel_booking.png',
                  'Hotel Bookings',
                  'Find the perfect hotels for your stay and enjoy a comfortable experience.',
                  Colors.blueAccent,
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
                child: _buildCategoryContainer(
                  'assets/images/language_translator.png',
                  'Language Translator',
                  'Translate between different languages and communicate effortlessly.',
                  Colors.redAccent,
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
                child: _buildCategoryContainer(
                  'assets/images/food_beverages.png',
                  'Food and Beverages',
                  'Explore a variety of delicious cuisines and quench your thirst with refreshing drinks.',
                  Colors.orangeAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCategoryContainer(
      String imagePath, String title, String description, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 120,
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
