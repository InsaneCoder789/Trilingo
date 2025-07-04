import 'dart:math';
import 'package:flutter/material.dart';

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
