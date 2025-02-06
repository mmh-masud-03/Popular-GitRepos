import 'dart:math';
import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const CustomLoader({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _radiusAnimation = Tween<double>(
      begin: 0.2,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
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
          size: Size(widget.size, widget.size),
          painter: _LoaderPainter(
            rotationAngle: _rotationAnimation.value,
            radius: _radiusAnimation.value,
            color: widget.color ?? Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final double rotationAngle;
  final double radius;
  final Color color;

  _LoaderPainter({
    required this.rotationAngle,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Draw the base circle
    canvas.drawCircle(
      center,
      size.width * 0.4,
      paint..color = color.withOpacity(0.2),
    );

    // Draw the animated arc
    final rect = Rect.fromCircle(center: center, radius: size.width * 0.4);
    canvas.drawArc(
      rect,
      rotationAngle,
      pi * radius,
      false,
      paint..color = color,
    );

    // Draw the small circles at the ends of the arc
    final startPoint = Offset(
      center.dx + size.width * 0.4 * cos(rotationAngle),
      center.dy + size.width * 0.4 * sin(rotationAngle),
    );
    final endPoint = Offset(
      center.dx + size.width * 0.4 * cos(rotationAngle + pi * radius),
      center.dy + size.width * 0.4 * sin(rotationAngle + pi * radius),
    );

    canvas.drawCircle(startPoint, 4, paint..style = PaintingStyle.fill);
    canvas.drawCircle(endPoint, 4, paint);
  }

  @override
  bool shouldRepaint(covariant _LoaderPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.radius != radius ||
        oldDelegate.color != color;
  }
}