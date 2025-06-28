import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trilingo/home_widgets/chatgpt_chatbot.dart';
import 'package:trilingo/home_widgets/food_beverages_page.dart';
import 'profile_page.dart';
import 'package:trilingo/home_widgets/flight_bookings_page.dart';
import 'package:trilingo/home_widgets/hotel_bookings_page.dart';
import 'package:trilingo/home_widgets/language_translator_page.dart';

class HomePage extends StatefulWidget {
  final User? user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  double _currentPage = 0.0;

  final List<_CardData> cards = [
    _CardData(
      imagePath: 'assets/images/flight_booking.png',
      title: 'Flight Bookings',
      description:
          'Embark on interstellar journeys with ease. Discover the universe through hassle-free flight bookings, making your cosmic voyages seamless and delightful.',
      backgroundColors: [Color(0xFFFFE0B2), Color(0xFFFFD699)],
      targetPage: FlightBookingsPage(),
    ),
    _CardData(
      imagePath: 'assets/images/hotel_booking.png',
      title: 'Hotel Bookings',
      description:
          'Indulge in celestial hospitality. Experience luxury and comfort at our cosmic hotels, where you can relax and unwind while exploring the wonders of the universe.',
      backgroundColors: [Color(0xFFFFCCD2), Color(0xFFFFB5BD)],
      targetPage: HotelBookingsPage(),
    ),
    _CardData(
      imagePath: 'assets/images/language_translator.png',
      title: 'Language Translator',
      description:
          'Break down language barriers across galaxies. Communicate effortlessly with beings from different star systems using our advanced language translation technology.',
      backgroundColors: [Color(0xFFD4E6FF), Color(0xFFAEC7FF)],
      targetPage: LanguageTranslatorPage(),
    ),
    _CardData(
      imagePath: 'assets/images/food_beverages.png',
      title: 'Food and Beverages',
      description:
          'Savor exotic cosmic delicacies. Immerse yourself in the flavors of the universe with our wide range of intergalactic cuisines, prepared by master chefs from across the galaxies.',
      backgroundColors: [Color(0xFFE0E5FF), Color(0xFFD1E1FF)],
      targetPage: FoodBeveragesPage(),
    ),
    _CardData(
      imagePath: 'assets/images/ai_chatbot.png',
      title: 'AI Chatbot',
      description:
          'Communicate with our AI Chatbot to get instant assistance and answers to your questions. Whether it\'s travel information or general queries, our AI Chatbot is here to help you.',
      backgroundColors: [Color(0xFFFFE89F), Color(0xFFFFD699)],
      targetPage: ChatPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(user: widget.user),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.user?.photoURL ?? ''),
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
                      widget.user?.displayName ?? 'User',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 80),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index % cards.length];
                        final rotationY = (_currentPage - index).clamp(-1.0, 1.0);
                        final scale = 1.0 - rotationY.abs() * 0.2;

                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(rotationY * pi / 2)
                            ..scale(scale),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => card.targetPage),
                            ),
                            child: AnimatedCard(
                              imagePath: card.imagePath,
                              title: card.title,
                              description: card.description,
                              backgroundColors: card.backgroundColors,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(cards.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentPage.round()
                              ? Colors.blueAccent
                              : Colors.grey.withOpacity(0.5),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardData {
  final String imagePath;
  final String title;
  final String description;
  final List<Color> backgroundColors;
  final Widget targetPage;

  _CardData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColors,
    required this.targetPage,
  });
}

class AnimatedCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<Color> backgroundColors;

  AnimatedCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.backgroundColors,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double cardHeight = screenHeight * 0.6;
    final double cardWidth = screenWidth * 0.9;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundColors,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14),
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  imagePath,
                  height: 400,
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
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
