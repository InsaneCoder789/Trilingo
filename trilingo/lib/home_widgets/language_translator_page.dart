import 'package:flutter/material.dart';

class LanguageTranslatorPage extends StatefulWidget {
  @override
  _LanguageTranslatorPageState createState() => _LanguageTranslatorPageState();
}

class _LanguageTranslatorPageState extends State<LanguageTranslatorPage> {
  String selectedLanguage = 'English'; // Default language selection
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translator AI'),
        backgroundColor: Color(0xFF001489),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                  'assets/images/welcome_image.png'), // Replace with your image asset
            ),
            SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
              items: [
                'English',
                'French',
                'Spanish'
              ] // Add more languages as needed
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Select Language',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            isRecording
                ? Column(
                    children: [
                      Text(
                        'Recording...',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Recording will start in 3 seconds.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isRecording = true;
                      });
                      // Start a timer and initiate recording logic
                      Future.delayed(Duration(seconds: 3), () {
                        // Implement recording logic here

                        // After recording, set isRecording back to false
                        setState(() {
                          isRecording = false;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Start Recording',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 16),
            if (isRecording) ...[
              Text(
                'Recording will start in 3 seconds.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
            SizedBox(height: 16),
            isRecording
                ? SizedBox.shrink() // Hide the play button while recording
                : ElevatedButton(
                    onPressed: () {
                      // Implement play logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Play Translation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
