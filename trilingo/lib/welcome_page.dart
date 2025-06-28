import 'package:flutter/material.dart';
import 'package:trilingo/signup_page.dart';
import 'package:video_player/video_player.dart';
import 'login_page.dart';

class Onboarding1Widget extends StatefulWidget {
  @override
  _Onboarding1WidgetState createState() => _Onboarding1WidgetState();
}

class _Onboarding1WidgetState extends State<Onboarding1Widget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      'assets/animations/main4.mp4', // Replace with the correct asset path
    )
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Play the video when it's initialized
        });
      })
      ..setLooping(true); // Set looping to true to loop the video
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
              height: 60), // Added some space between the status bar and text
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 155,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/welcome_image.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 0),
                  Text(
                    'TRILINGO',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF6A57FF),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Enjoy the new era of Tourism with all-new Trilingo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF6A57FF), // Purple
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 1), // Adjusted spacing
                ],
              ),
            ),
          ),
          SizedBox(height: 10), // Added some space between text and video
          Expanded(
            flex: 1, // Adjusted the flex value to make the video larger
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          SizedBox(height: 20), // Adjusted spacing for buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A57FF), // Purple
                    minimumSize: Size(300, 62),
                    textStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    elevation: 20,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Get Started'),
                ),
                SizedBox(
                  height: 25, // Adjusted height
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF6A57FF), backgroundColor: Colors.white, // Purple
                    minimumSize: Size(300, 62),
                    textStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Color(0xFF6A57FF), // Purple
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    elevation: 15,
                    shadowColor: Color(0xFF6A57FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('My Account'),
                ),
                SizedBox(
                  height: 45, // Adjusted height
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
