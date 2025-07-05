import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;

class LanguageTranslatorPage extends StatefulWidget {
  @override
  _LanguageTranslatorPageState createState() => _LanguageTranslatorPageState();
}

class _LanguageTranslatorPageState extends State<LanguageTranslatorPage>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool isListening = false;
  String recognizedText = '';
  String translatedText = '';
  String fromLanguageCode = 'auto';
  String toLanguageCode = 'es';
  List<Map<String, String>> translationHistory = [];

  final List<Map<String, String>> languages = [
    {'name': 'Auto Detect', 'code': 'auto'},
    {'name': 'English', 'code': 'en'},
    {'name': 'Spanish', 'code': 'es'},
    {'name': 'French', 'code': 'fr'},
    {'name': 'German', 'code': 'de'},
    {'name': 'Hindi', 'code': 'hi'},
    {'name': 'Japanese', 'code': 'ja'},
    {'name': 'Chinese', 'code': 'zh-CN'},
    {'name': 'Korean', 'code': 'ko'},
    {'name': 'Arabic', 'code': 'ar'},
    {'name': 'Russian', 'code': 'ru'},
  ];

  late final AnimationController _controller;
  late final Timer _twinkleTimer;
  final Random _random = Random();
  final List<_Star> _stars = [];

  late AnimationController _micAnimationController;
  late Animation<double> _micGlowAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize stars for background
    for (int i = 0; i < 150; i++) {
      _stars.add(_Star(
        position: Offset(_random.nextDouble(), _random.nextDouble()),
        size: _random.nextDouble() * 2 + 0.5,
        twinklePhase: _random.nextDouble() * 2 * pi,
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _twinkleTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      setState(() {});
    });

    // Mic glowing orb animation controller
    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _micGlowAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(
      parent: _micAnimationController,
      curve: Curves.easeInOut,
    ));

    _micAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _micAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _micAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _twinkleTimer.cancel();
    _micAnimationController.dispose();
    super.dispose();
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
        _micAnimationController.forward();
      });
      _speech.listen(onResult: (result) {
        setState(() => recognizedText = result.recognizedWords);
      });
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
    setState(() {
      isListening = false;
      _micAnimationController.stop();
      _micAnimationController.value = 0.4;
    });
  }

  Future<void> translateText(String text) async {
    if (text.trim().isEmpty) {
      setState(() {
        translatedText = 'Please speak or enter text to translate.';
      });
      return;
    }

    final apiKey = 'YOUR_GOOGLE_CLOUD_TRANSLATE_API_KEY';
    final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?key=$apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'q': text,
        'source': fromLanguageCode,
        'target': toLanguageCode,
        'format': 'text',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final translated = data['data']['translations'][0]['translatedText'];
      final detectedSource = data['data']['translations'][0]['detectedSourceLanguage'] ?? fromLanguageCode;
      setState(() {
        translatedText = translated;
        translationHistory.add({
          'from': recognizedText,
          'to': translated,
          'source': detectedSource,
          'target': toLanguageCode,
        });
      });
    } else {
      setState(() => translatedText = 'Translation failed.');
    }
  }

  Future<void> speakTranslatedText() async {
    if (translatedText.trim().isEmpty) return;
    await _flutterTts.setLanguage(toLanguageCode);
    await _flutterTts.setPitch(1.2);
    await _flutterTts.setSpeechRate(0.9);
    await _flutterTts.speak(translatedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _SpacePainter(_stars, _controller.value),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 48),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Language Translator",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Orbitron',
                        shadows: [
                          Shadow(blurRadius: 12, color: Colors.cyanAccent)
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Main UI Container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.6),
                            width: 1.8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 6)
                        ],
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.black87],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildDropdown("Translate From", fromLanguageCode, true),
                          const SizedBox(height: 10),

                          // Recognized Speech
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.6),
                                  width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  recognizedText.isEmpty
                                      ? 'Press record and speak...'
                                      : recognizedText,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(height: 12),

                                // Glowing Mic Button with Orb Animation
                                GestureDetector(
                                  onTap: () => isListening
                                      ? stopListening()
                                      : startListening(),
                                  child: AnimatedBuilder(
                                    animation: _micAnimationController,
                                    builder: (context, child) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: isListening
                                                ? [
                                                    Colors.cyanAccent.withOpacity(
                                                        _micGlowAnimation.value),
                                                    Colors.blueAccent.withOpacity(
                                                        _micGlowAnimation.value),
                                                  ]
                                                : [
                                                    Colors.grey.shade700,
                                                    Colors.grey.shade900,
                                                  ],
                                            stops: const [0.0, 1.0],
                                          ),
                                          boxShadow: isListening
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.cyanAccent.withOpacity(
                                                        _micGlowAnimation.value),
                                                    blurRadius: 24,
                                                    spreadRadius: 8,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.blueAccent.withOpacity(
                                                        _micGlowAnimation.value),
                                                    blurRadius: 32,
                                                    spreadRadius: 12,
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        child: Icon(
                                          isListening ? Icons.stop : Icons.mic,
                                          size: 36,
                                          color:
                                              isListening ? Colors.black : Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildDropdown("Translate To", toLanguageCode, false),
                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () => translateText(recognizedText),
                            child: const Text("Translate",
                                style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 120, vertical: 15),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Translated Result
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.6)),
                            ),
                            child: Text(
                              translatedText.isEmpty
                                  ? 'Translation will appear here.'
                                  : translatedText,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),

                          ElevatedButton.icon(
                            onPressed: () => speakTranslatedText(),
                            icon: const Icon(Icons.volume_up),
                            label: const Text("Speak"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 120, vertical: 15),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String currentCode, bool isFrom) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
              fontSize: 14,
            )),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.7)),
          ),
          child: DropdownButton<String>(
            value: currentCode,
            dropdownColor: Colors.black87,
            iconEnabledColor: Colors.cyanAccent,
            isExpanded: true,
            underline: Container(),
            items: languages.map((lang) {
              return DropdownMenuItem<String>(
                value: lang['code'],
                child: Text(
                  lang['name']!,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                if (isFrom) {
                  fromLanguageCode = value;
                } else {
                  toLanguageCode = value;
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class _Star {
  Offset position;
  double size;
  double twinklePhase;

  _Star({
    required this.position,
    required this.size,
    required this.twinklePhase,
  });
}

class _SpacePainter extends CustomPainter {
  final List<_Star> stars;
  final double animationValue;

  _SpacePainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // Background gradient
    final gradient = LinearGradient(
      colors: [Colors.black, Colors.deepPurple.shade900],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final rect = Offset.zero & size;
    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Draw stars
    for (var star in stars) {
      final twinkle =
          0.5 + 0.5 * sin(animationValue * 2 * pi + star.twinklePhase);
      paint.color = Colors.white.withOpacity(twinkle);
      canvas.drawCircle(
          Offset(star.position.dx * size.width, star.position.dy * size.height),
          star.size,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpacePainter oldDelegate) => true;
}
