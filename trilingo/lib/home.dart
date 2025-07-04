import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trilingo/home_widgets/chatgpt_chatbot.dart';
import 'package:trilingo/home_widgets/food_beverages_page.dart';
import 'package:trilingo/profile_page.dart';
import 'package:trilingo/home_widgets/flight_bookings_page.dart';
import 'package:trilingo/home_widgets/hotel_bookings_page.dart';
import 'package:trilingo/home_widgets/language_translator_page.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  double _currentPage = 0.0;
  User? _currentUser;
  int? avatarIndex;

  // List of Material Icons for avatars
  final List<IconData> _avatarIcons = [
    Icons.pets,
    Icons.android,
    Icons.face,
    Icons.rocket_launch,
    Icons.auto_awesome,
    Icons.catching_pokemon,
    Icons.emoji_nature,
    Icons.bug_report,
    Icons.star,
    Icons.waves,
  ];

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
      if (user != null && !_isGoogleUser(user)) {
        _fetchAvatarIndex(user.uid);
      }
    });

    if (_currentUser != null && !_isGoogleUser(_currentUser!)) {
      _fetchAvatarIndex(_currentUser!.uid);
    }
  }

  bool _isGoogleUser(User user) {
    // Check if user is signed in with a Gmail Google account
    final email = user.email ?? '';
    return email.endsWith('@gmail.com');
  }

  Future<void> _fetchAvatarIndex(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('avatarIndex')) {
        setState(() {
          avatarIndex = doc['avatarIndex'];
        });
      }
    } catch (e) {
      print("Error fetching avatarIndex: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _currentUser?.displayName ?? "Galactic Traveler";
    final photoURL = _currentUser?.photoURL ?? "";

    Widget buildGlowingAvatar(Widget child) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const SweepGradient(
            colors: [Colors.cyanAccent, Colors.blueAccent, Colors.purpleAccent, Colors.cyanAccent],
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
        child: child,
      );
    }

    late final Widget avatarWidget;

    if (photoURL.isNotEmpty && _isGoogleUser(_currentUser!)) {
      // Google user with photoURL
      avatarWidget = buildGlowingAvatar(
        CircleAvatar(
          backgroundImage: NetworkImage(photoURL),
          radius: 36,
          backgroundColor: Colors.transparent,
        ),
      );
    } else if (avatarIndex != null && avatarIndex! >= 0 && avatarIndex! < _avatarIcons.length) {
      // Show icon avatar for non-Google users with avatarIndex
      avatarWidget = buildGlowingAvatar(
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.black,
          child: Icon(
            _avatarIcons[avatarIndex!],
            size: 36,
            color: Colors.cyanAccent,
          ),
        ),
      );
    } else {
      // Fallback: show initial letter avatar
      avatarWidget = buildGlowingAvatar(
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'G',
              style: GoogleFonts.orbitron(
                fontSize: 28,
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

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
                      child: avatarWidget,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          displayName,
                          style: GoogleFonts.orbitron(
                            color: Colors.lightBlueAccent,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
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
                                      MaterialPageRoute(builder: (context) => card.targetPage),
                                    );
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4), // translucent black
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: Colors.cyanAccent.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.asset(
                                              card.imagePath,
                                              height: 200,  // reduced height for smaller image
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(height: 15), // some extra vertical space
                                          Text(
                                            card.title,
                                            style: GoogleFonts.orbitron(
                                              fontSize: 40, // slightly bigger font size for title
                                              fontWeight: FontWeight.bold,
                                              color: Colors.cyanAccent,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 14),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Text(
                                              card.description,
                                              style: GoogleFonts.orbitron(
                                                fontSize: 17,
                                                color: Colors.lightBlueAccent,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 45),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),  // Move text up by adding bottom padding here
                        child: Text(
                          'Swipe cards left or right to explore',
                          style: GoogleFonts.orbitron(color: Colors.white70),
                        ),
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

class AnimatedSpaceBackground extends StatefulWidget {
  const AnimatedSpaceBackground({super.key});

  @override
  State<AnimatedSpaceBackground> createState() => _AnimatedSpaceBackgroundState();
}

class _AnimatedSpaceBackgroundState extends State<AnimatedSpaceBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _stars = List.generate(150, (index) => _Star.random());
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarPainter(_stars, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _Star {
  Offset position;
  double radius;
  Color color;
  double twinkleSpeed;

  _Star({
    required this.position,
    required this.radius,
    required this.color,
    required this.twinkleSpeed,
  });

  factory _Star.random() {
    final random = Random();
    return _Star(
      position: Offset(random.nextDouble(), random.nextDouble()),
      radius: random.nextDouble() * 1.5 + 0.5,
      color: Colors.white,
      twinkleSpeed: random.nextDouble() * 2 + 1,
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  _StarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var star in stars) {
      final alpha = (0.5 + 0.5 * sin(animationValue * 2 * pi * star.twinkleSpeed)) * 255;
      paint.color = star.color.withAlpha(alpha.toInt());
      canvas.drawCircle(
        Offset(star.position.dx * size.width, star.position.dy * size.height),
        star.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
