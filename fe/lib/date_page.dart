import 'package:flutter/material.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/buttons/stamped_button.dart';
import 'map_view.dart';

class DatePage extends StatelessWidget {
  const DatePage({super.key});

  @override
  Widget build(BuildContext context) {
    const svgAssetPath = 'assets/header_1.svg';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
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
            svgAssetPath: svgAssetPath
          )
        ],
      ),
    );
  }
}