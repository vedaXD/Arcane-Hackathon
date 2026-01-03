import 'package:flutter/material.dart';
import 'dart:math' as math;

class RadarSearchAnimation extends StatefulWidget {
  final bool isSearching;
  final VoidCallback? onSearchComplete;

  const RadarSearchAnimation({
    super.key,
    required this.isSearching,
    this.onSearchComplete,
  });

  @override
  State<RadarSearchAnimation> createState() => _RadarSearchAnimationState();
}

class _RadarSearchAnimationState extends State<RadarSearchAnimation>
    with TickerProviderStateMixin {
  late AnimationController _radarController;
  late AnimationController _pulseController;
  late Animation<double> _radarAnimation;
  late Animation<double> _pulseAnimation;

  List<MapPoint> _foundRides = [];

  @override
  void initState() {
    super.initState();
    
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _radarAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _radarController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeOut,
    ));

    if (widget.isSearching) {
      _startSearch();
    }
  }

  void _startSearch() {
    _radarController.repeat();
    _pulseController.repeat();
    
    // Simulate finding rides
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted && widget.isSearching) {
        setState(() {
          _foundRides.add(MapPoint(
            angle: math.pi / 4,
            distance: 0.6,
            color: Color(0xFF4CAF50),
          ));
        });
      }
    });

    Future.delayed(Duration(milliseconds: 1200), () {
      if (mounted && widget.isSearching) {
        setState(() {
          _foundRides.add(MapPoint(
            angle: math.pi * 0.8,
            distance: 0.4,
            color: Color(0xFFFF9800),
          ));
        });
      }
    });

    Future.delayed(Duration(milliseconds: 1800), () {
      if (mounted && widget.isSearching) {
        setState(() {
          _foundRides.add(MapPoint(
            angle: -math.pi / 3,
            distance: 0.7,
            color: Color(0xFF2196F3),
          ));
        });
      }
    });

    Future.delayed(Duration(milliseconds: 2500), () {
      if (mounted && widget.isSearching) {
        setState(() {
          _foundRides.add(MapPoint(
            angle: math.pi * 1.5,
            distance: 0.5,
            color: Color(0xFFFF5722),
          ));
        });
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        widget.onSearchComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(RadarSearchAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSearching && !oldWidget.isSearching) {
      _foundRides.clear();
      _startSearch();
    } else if (!widget.isSearching && oldWidget.isSearching) {
      _radarController.stop();
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _radarController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles
          ...List.generate(3, (index) {
            final size = 280.0 - (index * 80);
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFF66BB6A).withOpacity(0.2),
                  width: 1,
                ),
              ),
            );
          }),

          // Pulsing circles
          if (widget.isSearching)
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 280 * _pulseAnimation.value,
                  height: 280 * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFFF8C42).withOpacity(
                        (1 - _pulseAnimation.value) * 0.5,
                      ),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

          // Radar sweep
          if (widget.isSearching)
            AnimatedBuilder(
              animation: _radarAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(280, 280),
                  painter: RadarPainter(
                    angle: _radarAnimation.value,
                  ),
                );
              },
            ),

          // Found rides
          ...(_foundRides.map((point) => AnimatedBuilder(
                animation: _radarAnimation,
                builder: (context, child) {
                  final x = math.cos(point.angle) * (140 * point.distance);
                  final y = math.sin(point.angle) * (140 * point.distance);
                  
                  return Transform.translate(
                    offset: Offset(x, y),
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 500),
                      builder: (context, double value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: point.color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: point.color.withOpacity(0.6),
                                  blurRadius: 12,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.directions_car,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ))),

          // Center point (Your location)
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(0xFFFF8C42),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF8C42).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.my_location,
              size: 12,
              color: Colors.white,
            ),
          ),

          // Searching text
          if (widget.isSearching)
            Positioned(
              bottom: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Color(0xFFFF8C42)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Searching for rides...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Found count
          if (!widget.isSearching && _foundRides.isNotEmpty)
            Positioned(
              bottom: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  '${_foundRides.length} rides found!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle;

  RadarPainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Radar sweep gradient
    final gradient = SweepGradient(
      colors: [
        Color(0xFF66BB6A).withOpacity(0.0),
        Color(0xFF66BB6A).withOpacity(0.3),
        Color(0xFF66BB6A).withOpacity(0.0),
      ],
      stops: [0.0, 0.5, 1.0],
      transform: GradientRotation(angle - math.pi / 4),
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // Radar line
    final linePaint = Paint()
      ..color = Color(0xFF66BB6A).withOpacity(0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final endX = center.dx + radius * math.cos(angle);
    final endY = center.dy + radius * math.sin(angle);

    canvas.drawLine(center, Offset(endX, endY), linePaint);
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) {
    return oldDelegate.angle != angle;
  }
}

class MapPoint {
  final double angle;
  final double distance;
  final Color color;

  MapPoint({
    required this.angle,
    required this.distance,
    required this.color,
  });
}
