import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:trilingo/ui/widgets/spacethemeui.dart';

class LanguageTranslatorPage extends StatefulWidget {
  const LanguageTranslatorPage({Key? key}) : super(key: key);

  @override
  State<LanguageTranslatorPage> createState() => _LanguageTranslatorPageState();
}

class _LanguageTranslatorPageState extends State<LanguageTranslatorPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'zh', 'name': 'Chinese'},
    {'code': 'hi', 'name': 'Hindi'},
  ];

  String fromLanguageCode = 'en';
  String toLanguageCode = 'es';

  String recognizedText = '';
  String translatedText = '';

  final TextEditingController typingController = TextEditingController();

  late stt.SpeechToText speech;
  bool isListening = false;

  final FlutterTts flutterTts = FlutterTts();

  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();

    _glowController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    typingController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> translateText() async {
    if (typingController.text.isNotEmpty) {
      setState(() {
        recognizedText = typingController.text;
      });
    }
    String input = recognizedText.trim();
    if (input.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      translatedText = '$input [${toLanguageCode.toUpperCase()}] (translated)';
    });
  }

  void startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => isListening = false);
        }
      },
      onError: (error) {
        setState(() => isListening = false);
      },
    );
    if (available) {
      setState(() => isListening = true);
      speech.listen(
        onResult: (result) {
          setState(() {
            recognizedText = result.recognizedWords;
            typingController.text = recognizedText;
          });
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  Future<void> speakText() async {
    if (translatedText.isEmpty) return;
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.speak(translatedText);
  }

  @override
  Widget build(BuildContext context) {
    final double mainBoxWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const AnimatedSpaceBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Container(
                  width: mainBoxWidth,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.cyanAccent.withOpacity(0.85),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Translate',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontFamily: 'Orbitron',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildLanguageRow('From:', fromLanguageCode, (value) {
                        setState(() => fromLanguageCode = value);
                      }),
                      const SizedBox(height: 18),
                      _buildLanguageRow('To:', toLanguageCode, (value) {
                        setState(() => toLanguageCode = value);
                      }, labelSpacing: 24),
                      const SizedBox(height: 28),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.cyanAccent.withOpacity(0.85)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.35),
                              blurRadius: 16,
                              spreadRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: typingController,
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontFamily: 'Orbitron',
                            fontSize: 16,
                          ),
                          cursorColor: Colors.cyanAccent,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            border: InputBorder.none,
                            hintText: 'Type text here...',
                            hintStyle: TextStyle(color: Colors.cyanAccent.withOpacity(0.45)),
                          ),
                          onChanged: (val) {
                            setState(() {
                              recognizedText = val;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 26),
                      _buildTextDisplay(
                        text: recognizedText.isEmpty
                            ? 'Recognized speech will appear here...'
                            : recognizedText,
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          if (isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, child) {
                            double glow = isListening ? _glowController.value : 0.4;
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isListening
                                    ? Colors.cyanAccent.withOpacity(0.9)
                                    : Colors.black87,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(glow),
                                    blurRadius: isListening ? 30 * glow : 10,
                                    spreadRadius: isListening ? 12 * glow : 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isListening ? Icons.mic : Icons.mic_none,
                                size: 42,
                                color: isListening ? Colors.black : Colors.cyanAccent,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildActionButton(
                        label: 'Translate',
                        enabled: recognizedText.trim().isNotEmpty,
                        onPressed: translateText,
                      ),
                      const SizedBox(height: 28),
                      _buildTextDisplay(
                        text: translatedText.isEmpty
                            ? 'Translation will appear here'
                            : translatedText,
                      ),
                      const SizedBox(height: 26),
                      _buildActionButton(
                        label: 'Speak',
                        enabled: translatedText.isNotEmpty,
                        onPressed: speakText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageRow(
    String label,
    String currentCode,
    Function(String) onChanged, {
    double labelSpacing = 12,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Orbitron',
            shadows: [
              Shadow(
                color: Colors.cyanAccent.withOpacity(0.6),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        SizedBox(width: labelSpacing),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.75)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.35),
                    blurRadius: 14,
                    spreadRadius: 1.5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                dropdownColor: Colors.black87,
                value: currentCode,
                isExpanded: true,
                iconEnabledColor: Colors.cyanAccent,
                style: const TextStyle(color: Colors.cyanAccent, fontFamily: 'Orbitron'),
                underline: const SizedBox.shrink(),
                items: languages
                    .map(
                      (lang) => DropdownMenuItem<String>(
                        value: lang['code'],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(lang['name']!),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextDisplay({required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.85)),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.3),
            blurRadius: 18,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 16,
          fontFamily: 'Orbitron',
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? Colors.cyanAccent : Colors.grey[700],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            shadowColor: Colors.cyanAccent.withOpacity(0.8),
            elevation: enabled ? 14 : 0,
            textStyle: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onPressed: enabled ? onPressed : null,
          child: Text(
            label,
            style: TextStyle(color: enabled ? Colors.black : Colors.grey[400]),
          ),
        ),
      ),
    );
  }
}
