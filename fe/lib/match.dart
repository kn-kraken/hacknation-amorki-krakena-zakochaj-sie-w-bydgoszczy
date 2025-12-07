import 'package:flutter/material.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/swapper.dart';

import 'buttons/stamped_button.dart';
import 'map_view.dart';

class MatchScreen extends StatelessWidget {
  final CardItem matchedCard;
  const MatchScreen({super.key, required this.matchedCard,});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cupid icon
              const Icon(
                Icons.favorite,
                color: Color(0xFF6B1D27),
                size: 60,
              ),
              const SizedBox(height: 10),
              
              // "IT'S A MATCH!" text
              const Text(
                "Towarzyszka podróży znaleziona!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B1D27),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 60),

              // HERE PHOTO
              _buildMatchedPhoto(matchedCard),

              const Spacer(),

              StampedButton(
                  text: 'Przejdź do mapy randki',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  },
                  svgAssetPath: 'assets/header_1.svg'
              )
            ],
          ),
        ),
    );
  }

  Widget _buildMatchedPhoto(CardItem card) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image.network(
        card.imageUrl, // Use the matched person's image URL
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
