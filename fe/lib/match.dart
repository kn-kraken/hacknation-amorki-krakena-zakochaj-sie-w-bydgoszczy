import 'package:flutter/material.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cupid icon
              const Icon(
                Icons.favorite,
                color: Color(0xFF8B1538),
                size: 60,
              ),
              const SizedBox(height: 40),
              
              // "IT'S A MATCH!" text
              const Text(
                "IT'S A MATCH!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B1538),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 60),
              
              // Heart with polka dots
              Container(
                width: 200,
                height: 180,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: CustomPaint(
                  painter: HeartPainter(),
                ),
              ),
              const SizedBox(height: 60),
              
              // Subtitle text
              const Text(
                "I TY MNIE JESZCZE\nUMÓWIENIE!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B1538),
                  height: 1.2,
                ),
              ),
              const Spacer(),
              
              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B1538),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "PRZEJDŹ DO RANKI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final dotPaint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..style = PaintingStyle.fill;

    // Draw heart shape
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    // Heart shape path
    path.moveTo(width * 0.5, height * 0.25);
    path.cubicTo(width * 0.2, height * 0.1, width * 0.1, height * 0.25, width * 0.1, height * 0.4);
    path.cubicTo(width * 0.1, height * 0.55, width * 0.5, height * 0.95, width * 0.5, height * 0.95);
    path.cubicTo(width * 0.5, height * 0.95, width * 0.9, height * 0.55, width * 0.9, height * 0.4);
    path.cubicTo(width * 0.9, height * 0.25, width * 0.8, height * 0.1, width * 0.5, height * 0.25);
    path.close();

    canvas.drawPath(path, paint);

    // Draw polka dots
    final dotRadius = 8.0;
    final spacing = 25.0;
    
    for (double x = dotRadius; x < width - dotRadius; x += spacing) {
      for (double y = dotRadius; y < height - dotRadius; y += spacing) {
        if (path.contains(Offset(x, y))) {
          canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}