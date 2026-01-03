import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  
  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated gradient background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    Color(0xFFFAF9F6),
                    Color(0xFFF5F5DC),
                    Color(0xFFFFF8E7),
                  ],
                  stops: [
                    0.0,
                    0.5 + math.sin(_controller.value * 2 * math.pi) * 0.2,
                    1.0,
                  ],
                ),
              ),
            );
          },
        ),
        // Floating circles
        ...List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final offset = (index * 0.2 + _controller.value) % 1.0;
              final size = 80.0 + (index * 40.0);
              final opacity = 0.03 + (math.sin(offset * math.pi) * 0.02);
              
              return Positioned(
                left: MediaQuery.of(context).size.width * 
                    (0.2 + math.sin(offset * 2 * math.pi + index) * 0.3),
                top: MediaQuery.of(context).size.height * offset,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFF8C42).withOpacity(opacity),
                  ),
                ),
              );
            },
          );
        }),
        // Content
        widget.child,
      ],
    );
  }
}
