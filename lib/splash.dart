import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke onboarding setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA), // Biru
              Color(0xFF764BA2), // Ungu
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: GlobePainter(),
                  child: const Center(
                    child: Icon(
                      Icons.airplanemode_active,
                      size: 40,
                      color: Color(0xFF667EEA),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Nama Aplikasi
              const Text(
                'GoTour',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              // Tagline
              const Text(
                'Jelajahi Indonesia Bersamamu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter untuk Globe Logo
class GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF667EEA).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Draw globe circles
    canvas.drawCircle(center, radius, paint);

    // Draw latitude lines
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      3.14 * 2,
      false,
      paint,
    );

    // Draw vertical line (longitude)
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.quadraticBezierTo(
      center.dx + radius * 0.3,
      center.dy,
      center.dx,
      center.dy + radius,
    );
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(center.dx, center.dy - radius);
    path2.quadraticBezierTo(
      center.dx - radius * 0.3,
      center.dy,
      center.dx,
      center.dy + radius,
    );
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
