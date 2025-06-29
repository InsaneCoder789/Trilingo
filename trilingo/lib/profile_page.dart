import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late DateTime _dob;
  String _gender = 'Male';
  IconData? _selectedAvatar;

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.displayName ?? '');
    _dob = DateTime(1990, 1, 1);
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (widget.user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['name'] ?? _nameController.text;
        _dob = (data['dob'] as Timestamp?)?.toDate() ?? _dob;
        _gender = data['gender'] ?? _gender;
        if (data['avatarIndex'] != null) {
          _selectedAvatar = _avatarIcons[data['avatarIndex']];
        }
      });
    }
  }

  Future<void> _saveUserData() async {
    if (widget.user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(widget.user!.uid).set({
      'name': _nameController.text,
      'dob': _dob,
      'gender': _gender,
      'avatarIndex': _selectedAvatar != null ? _avatarIcons.indexOf(_selectedAvatar!) : null,
    }, SetOptions(merge: true));
    await widget.user?.updateDisplayName(_nameController.text);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() => _dob = picked);
    }
  }

  Widget _buildAvatarSelector() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _avatarIcons.map((icon) {
        return GestureDetector(
          onTap: () => setState(() => _selectedAvatar = icon),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: _selectedAvatar == icon ? Colors.cyanAccent : Colors.white24,
            child: Icon(icon, size: 30, color: Colors.white),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGoogleUser = widget.user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedSpaceBackground()),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.cyanAccent, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyanAccent, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black,
                      backgroundImage: isGoogleUser && widget.user?.photoURL != null
                          ? NetworkImage(widget.user!.photoURL!)
                          : null,
                      child: !isGoogleUser && _selectedAvatar != null
                          ? Icon(_selectedAvatar, color: Colors.white, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        labelStyle: const TextStyle(color: Colors.cyanAccent),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: const TextStyle(color: Colors.cyanAccent),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM dd, yyyy').format(_dob),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(Icons.calendar_today, color: Colors.white70),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      dropdownColor: Colors.black,
                      iconEnabledColor: Colors.cyanAccent,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: const TextStyle(color: Colors.cyanAccent),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['Male', 'Female', 'Other'].map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _gender = value);
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Choose Avatar (For non-Google users)',
                      style: TextStyle(color: Colors.cyanAccent, fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    _buildAvatarSelector(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        await _saveUserData();
                        if (!isGoogleUser && _selectedAvatar != null) {
                          await widget.user?.updatePhotoURL(_selectedAvatar.toString());
                        }
                        if (context.mounted) Navigator.of(context).pop(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Save Profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
