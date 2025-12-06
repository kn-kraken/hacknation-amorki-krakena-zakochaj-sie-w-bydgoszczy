import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StampedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String svgAssetPath;

  const StampedButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.svgAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            // The Stamp Frame (SVG) overlay
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                svgAssetPath,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF8B2F3A), // White stamp border
                  BlendMode.srcIn,
                ),
                // fit: BoxFit.fill,
              ),
            ),

            // The Button Text
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    height: 1.1,
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