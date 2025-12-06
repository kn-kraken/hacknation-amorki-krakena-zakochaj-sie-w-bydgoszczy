import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  final String text;

  const Header({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const svgAssetPath = 'assets/header_1.svg';
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              svgAssetPath,
              colorFilter: const ColorFilter.mode(
                Color(0xFF8B2F3A), // White stamp border
                BlendMode.srcIn,
              ),
            ),
          ),

          // Text on top
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}