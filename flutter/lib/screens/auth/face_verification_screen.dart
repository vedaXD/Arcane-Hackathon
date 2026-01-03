import 'package:flutter/material.dart';
import 'package:routeopt/theme/app_theme.dart';

class FaceVerificationScreen extends StatefulWidget {
  final bool isRegistration;
  
  const FaceVerificationScreen({
    super.key,
    this.isRegistration = false,
  });

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late Animation<double> _scanAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isScanning = false;
  bool _isVerified = false;
  String _statusMessage = 'Position your face within the frame';

  @override
  void initState() {
    super.initState();
    
    _scanController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _scanAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Auto-start scanning after a delay
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _startScanning();
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
      _statusMessage = 'Scanning...';
    });
    
    _scanController.repeat();
    
    // Simulate face verification
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _scanController.stop();
        setState(() {
          _isScanning = false;
          _isVerified = true;
          _statusMessage = 'Face verified successfully!';
        });
        
        // Navigate back after success
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // Return true for registration flow
            Navigator.pop(context, widget.isRegistration ? true : null);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Face Verification',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey[900]!,
                  Colors.grey[800]!,
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.videocam,
                size: 100,
                color: Colors.grey[700],
              ),
            ),
          ),
          
          // Face frame overlay
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isScanning ? _pulseAnimation.value : 1.0,
                  child: child,
                );
              },
              child: CustomPaint(
                size: const Size(300, 400),
                painter: FaceFramePainter(
                  scanProgress: _scanAnimation,
                  isVerified: _isVerified,
                ),
              ),
            ),
          ),
          
          // Status message
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isVerified 
                        ? Colors.green.withOpacity(0.9)
                        : Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isVerified)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24,
                        )
                      else if (_isScanning)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      else
                        const Icon(
                          Icons.face,
                          color: Colors.white,
                          size: 24,
                        ),
                      const SizedBox(width: 12),
                      Text(
                        _statusMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (!_isScanning && !_isVerified) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _startScanning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text(
                      'Start Verification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Instructions
          if (!_isScanning && !_isVerified)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildInstruction(Icons.light_mode, 'Ensure good lighting'),
                    const SizedBox(height: 8),
                    _buildInstruction(Icons.face, 'Look straight at the camera'),
                    const SizedBox(height: 8),
                    _buildInstruction(Icons.remove_red_eye, 'Remove glasses if possible'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class FaceFramePainter extends CustomPainter {
  final Animation<double> scanProgress;
  final bool isVerified;

  FaceFramePainter({
    required this.scanProgress,
    required this.isVerified,
  }) : super(repaint: scanProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Frame color
    paint.color = isVerified ? Colors.green : Colors.white;

    // Draw oval frame
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.9,
    );

    // Draw corner brackets
    final cornerLength = 40.0;
    final cornerPaint = Paint()
      ..color = isVerified ? Colors.green : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.left + cornerLength, rect.top)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left, rect.top + cornerLength),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerLength, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.top + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.bottom - cornerLength)
        ..lineTo(rect.left, rect.bottom)
        ..lineTo(rect.left + cornerLength, rect.bottom),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - cornerLength, rect.bottom)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.right, rect.bottom - cornerLength),
      cornerPaint,
    );

    // Draw scanning line
    if (!isVerified) {
      final scanY = rect.top + (rect.height * scanProgress.value);
      final scanPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            Colors.orange.withOpacity(0.8),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromLTWH(rect.left, scanY - 2, rect.width, 4),
        )
        ..strokeWidth = 2;

      canvas.drawLine(
        Offset(rect.left, scanY),
        Offset(rect.right, scanY),
        scanPaint,
      );

      // Glow effect
      final glowPaint = Paint()
        ..color = Colors.orange.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawLine(
        Offset(rect.left, scanY),
        Offset(rect.right, scanY),
        glowPaint,
      );
    }

    // Draw guide points
    final dotRadius = 4.0;
    final dotPaint = Paint()
      ..color = isVerified ? Colors.green : Colors.white
      ..style = PaintingStyle.fill;

    // Center dot
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      dotRadius,
      dotPaint,
    );

    // Eye positions
    canvas.drawCircle(
      Offset(size.width / 2 - 40, size.height / 2 - 50),
      dotRadius,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2 + 40, size.height / 2 - 50),
      dotRadius,
      dotPaint,
    );

    // Nose position
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2 + 20),
      dotRadius,
      dotPaint,
    );

    // Mouth position
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2 + 70),
      dotRadius,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(FaceFramePainter oldDelegate) {
    return oldDelegate.isVerified != isVerified;
  }
}
