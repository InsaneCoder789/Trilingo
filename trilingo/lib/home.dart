import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  User? _currentUser;

  final List<_CardData> cards = [
    _CardData(
      imagePath: 'assets/images/welcome_image.png',
      title: 'Trilingo',
      description:
          'Explore Flights, Hotels, Food, Languages, and our AI Chatbot in one galactic app! 🌌\n\n Slide to Continue ➟ ',
      targetPage: const SizedBox.shrink(),
    ),
    _CardData(
      imagePath: 'assets/images/flight_booking.png',
      title: 'Flight Bookings',
      description: 'Embark on interstellar journeys with ease... 🚀\n\nTap to Continue',
      targetPage: FlightBookingsPage(),
    ),
    _CardData(
      imagePath: 'assets/images/hotel_booking.png',
      title: 'Hotel Bookings',
      description: 'Indulge in celestial hospitality... 🛸\n\nTap to Continue',
      targetPage: HotelBookingsPage(),
    ),
    _CardData(
      imagePath: 'assets/images/food_beverages.png',
      title: 'Food and Beverages',
      description: 'Savor exotic cosmic delicacies... 🍽️\n\nTap to Continue',
      targetPage: FoodBeveragesPage(),
    ),
    _CardData(
      imagePath: 'assets/images/language_translator.png',
      title: 'Language Translator',
      description: 'Break down language barriers across galaxies... 🌌\n\nTap to Continue',
      targetPage: LanguageTranslatorPage(),
    ),
    _CardData(
      imagePath: 'assets/images/ai_chatbot.png',
      title: 'AI Chatbot',
      description: 'Communicate with our AI companion... 🤖\n\nTap to Continue',
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

    _currentUser = widget.user;
    FirebaseAuth.instance.userChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _currentUser?.displayName ?? "Galactic Traveler";
    final photoURL = _currentUser?.photoURL ?? "";

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedSpaceBackground()),
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                radius: 1.2,
              ),
            ),
          ),
          Padding(
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
                            builder: (context) => ProfilePage(user: _currentUser),
                          ),
                        );
                      },
                      child: photoURL.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(photoURL),
                              radius: 36,
                            )
                          : Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [
                                    Colors.cyanAccent,
                                    Colors.blueAccent,
                                    Colors.purpleAccent,
                                    Colors.cyanAccent
                                  ],
                                  stops: [0.0, 0.5, 0.9, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(0.8),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  child: Center(
                                    child: Text(
                                      displayName[0].toUpperCase(),
                                      style: GoogleFonts.orbitron(
                                        fontSize: 28,
                                        color: Colors.cyanAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          displayName,
                          style: GoogleFonts.orbitron(
                            color: Colors.lightBlueAccent,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            final card = cards[index];
                            final rotationY = (_currentPage - index).clamp(-1.0, 1.0);
                            final scale = 1.0 - rotationY.abs() * 0.2;

                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(rotationY * pi / 2)
                                ..scale(scale),
                              child: GestureDetector(
                                onTap: () {
                                  if (card.targetPage is! SizedBox) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => card.targetPage,
                                      ),
                                    );
                                  }
                                },
                                child: AnimatedCard(
                                  imagePath: card.imagePath,
                                  title: card.title,
                                  description: card.description,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(cards.length, (index) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 25),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: index == _currentPage.round()
                                  ? Colors.cyanAccent
                                  : Colors.white24,
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (index == _currentPage.round())
                                  BoxShadow(
                                    color: Colors.cyanAccent,
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                              ],
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
        ],
      ),
    );
  }
}

class _CardData {
  final String imagePath;
  final String title;
  final String description;
  final Widget targetPage;

  _CardData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.targetPage,
  });
}

class AnimatedCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const AnimatedCard({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: screenWidth * 0.88,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 3),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.cyan.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 1,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.orbitron(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                imagePath,
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 25),
              Text(
                description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSpaceBackground extends StatefulWidget {
  const AnimatedSpaceBackground({super.key});
  @override
  State<AnimatedSpaceBackground> createState() => _AnimatedSpaceBackgroundState();
}

class _AnimatedSpaceBackgroundState extends State<AnimatedSpaceBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> starPositions;
  late List<double> starOpacities;
  final int numStars = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    final random = Random();
    starPositions = List.generate(numStars, (_) => Offset(random.nextDouble(), random.nextDouble()));
    starOpacities = List.generate(numStars, (_) => random.nextDouble() * 0.6 + 0.4);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: StarfieldPainter(
            animationValue: _controller.value,
            starPositions: starPositions,
            starOpacities: starOpacities,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class StarfieldPainter extends CustomPainter {
  final double animationValue;
  final List<Offset> starPositions;
  final List<double> starOpacities;

  StarfieldPainter({
    required this.animationValue,
    required this.starPositions,
    required this.starOpacities,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (int i = 0; i < starPositions.length; i++) {
      final dx = starPositions[i].dx * size.width;
      final dy = starPositions[i].dy * size.height;
      final radius = 0.8 + (animationValue * 1.5);
      paint.color = Colors.white.withOpacity(starOpacities[i] * (0.5 + 0.5 * sin(animationValue * 2 * pi)));
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) => true;
}

