import 'package:flutter/material.dart';
import 'dart:math' as math;

class RotatingCO2Logo extends StatefulWidget {
  final double size;
  final int points;
  final double co2Saved;

  const RotatingCO2Logo({
    super.key,
    this.size = 200,
    required this.points,
    required this.co2Saved,
  });

  @override
  State<RotatingCO2Logo> createState() => _RotatingCO2LogoState();
}

class _RotatingCO2LogoState extends State<RotatingCO2Logo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating outer ring with reward points
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_rotationAnimation.value),
                child: child,
              );
            },
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: CO2RingPainter(points: widget.points),
            ),
          ),

          // Center CO2 logo
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_rotationAnimation.value),
                child: child,
              );
            },
            child: Container(
              width: widget.size * 0.5,
              height: widget.size * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF66BB6A),
                    Color(0xFF388E3C),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF66BB6A).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CO₂',
                    style: TextStyle(
                      fontSize: widget.size * 0.12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${widget.co2Saved.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      fontSize: widget.size * 0.08,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'SAVED',
                    style: TextStyle(
                      fontSize: widget.size * 0.05,
                      fontWeight: FontWeight.w500,
                      color: Colors.white60,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Diamond indicators for reward points
          ...List.generate(8, (index) {
            final angle = (index * math.pi / 4) + (_rotationAnimation.value * 0.5);
            final radius = widget.size * 0.45;
            final x = math.cos(angle) * radius;
            final y = math.sin(angle) * radius;

            return AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                final scale = 0.8 + (math.sin(_rotationAnimation.value + angle) * 0.2);
                return Transform.translate(
                  offset: Offset(x, y),
                  child: Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFB74D),
                      Color(0xFFFF9800),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF9800).withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFD54F),
                          Color(0xFFFF9800),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Points counter at bottom
          Positioned(
            bottom: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFFF8C42).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFF8C42).withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '${widget.points} Points',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CO2RingPainter extends CustomPainter {
  final int points;

  CO2RingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Outer ring
    final outerPaint = Paint()
      ..color = Color(0xFF66BB6A).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, outerPaint);

    // Progress ring based on points
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Color(0xFF66BB6A),
          Color(0xFF4CAF50),
          Color(0xFF81C784),
          Color(0xFF66BB6A),
        ],
        stops: [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final progressAngle = (points % 1000) / 1000 * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CO2RingPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
