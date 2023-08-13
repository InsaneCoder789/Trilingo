import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trilingo/home_widgets/food_beverages_page.dart';
import 'profile_page.dart';
import 'package:trilingo/home_widgets/flight_bookings_page.dart';
import 'package:trilingo/home_widgets/hotel_bookings_page.dart';
import 'package:trilingo/home_widgets/language_translator_page.dart';

class HomePage extends StatelessWidget {
  final User? user;

  HomePage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 168, 208, 235), // Slightly lighter bluish background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(user: user),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user?.photoURL ?? ''),
                      radius: 36,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome,',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user?.displayName ?? 'User',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
              AnimatedCard(
                imagePath: 'assets/images/welcome_image.png',
                title: 'Welcome to Trilingo',
                description: '''
                Experience a world of limitless exploration and unique travel adventures. Embark on interstellar journeys with ease, indulging in celestial hospitality and savoring exotic cosmic delicacies. Break down language barriers across galaxies and step into a realm of boundless exploration and transcend traditional travel experiences.
                ''',
                backgroundColors: [Color(0xFFE0E5FF), Color(0xFFD1E1FF)],
                onPressed: () {},
                showExploreButton: false,
              ),
              SizedBox(height: 30),
              AnimatedCard(
                imagePath: 'assets/images/flight_booking.png',
                title: 'Flight Bookings',
                description: '''
                Embark on interstellar journeys with ease. Discover the universe through hassle-free flight bookings, making your cosmic voyages seamless and delightful.
                ''',
                backgroundColors: [Color(0xFFFFE0B2), Color(0xFFFFD699)],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlightBookingsPage(),
                    ),
                  );
                },
                showExploreButton: true,
              ),
              SizedBox(height: 30),
              AnimatedCard(
                imagePath: 'assets/images/hotel_booking.png',
                title: 'Hotel Bookings',
                description: '''
                Indulge in celestial hospitality. Experience luxury and comfort at our cosmic hotels, where you can relax and unwind while exploring the wonders of the universe.
                ''',
                backgroundColors: [Color(0xFFFFCCD2), Color(0xFFFFB5BD)],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelBookingsPage(),
                    ),
                  );
                },
                showExploreButton: true,
              ),
              SizedBox(height: 30),
              AnimatedCard(
                imagePath: 'assets/images/language_translator.png',
                title: 'Language Translator',
                description: '''
                Break down language barriers across galaxies. Communicate effortlessly with beings from different star systems using our advanced language translation technology.
                ''',
                backgroundColors: [Color(0xFFD4E6FF), Color(0xFFAEC7FF)],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageTranslatorPage(),
                    ),
                  );
                },
                showExploreButton: true,
              ),
              SizedBox(height: 30),
              AnimatedCard(
                imagePath: 'assets/images/food_beverages.png',
                title: 'Food and Beverages',
                description: '''
                Savor exotic cosmic delicacies. Immerse yourself in the flavors of the universe with our wide range of intergalactic cuisines, prepared by master chefs from across the galaxies.
                ''',
                backgroundColors: [Color(0xFFE0E5FF), Color(0xFFD1E1FF)],
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodBeveragesPage(),
                    ),
                  );
                },
                showExploreButton: true,
              ),
              SizedBox(height: 30),
              AnimatedCard(
                imagePath: 'assets/images/ai_chatbot.png',
                title: 'AI Chatbot',
                description: '''
                Communicate with our AI Chatbot to get instant assistance and answers to your questions. Whether it's travel information or general queries, our AI Chatbot is here to help you.
                ''',
                backgroundColors: [Color(0xFFFFE89F), Color(0xFFFFD699)],
                onPressed: () {
                  // Handle button press for AI Chatbot
                },
                showExploreButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<Color> backgroundColors;
  final VoidCallback onPressed;
  final bool showExploreButton;

  AnimatedCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColors,
    required this.onPressed,
    this.showExploreButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundColors,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            imagePath,
            height: 260,
            width: 180,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 12,
            width: 6,
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(
              height: showExploreButton
                  ? 16
                  : 0), // Add space for Explore button if needed
          if (showExploreButton)
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.black,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Explore',
                style: TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
