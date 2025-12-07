import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FunFactCard extends StatelessWidget {
  final String funFact;
  final String wikipediaUrl;

  const FunFactCard({
    super.key,
    required this.funFact,
    required this.wikipediaUrl,
  });

  Future<void> _launchWikipedia(BuildContext context) async {
    final uri = Uri.parse(wikipediaUrl);

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Wikipedia link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error opening Wikipedia link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 50),
      child: SizedBox(
        height: 250,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SvgPicture.asset(
                'assets/stamp_half.svg',
                width: double.infinity,
                height: double.infinity,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF6B1D27), // White stamp border
                  BlendMode.srcIn,
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'CIEKAWOSTKA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFdbdad8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontFamily: 'Serif',
                      ),
                    ),

                    const SizedBox(height: 8),
SizedBox( width: 300, child:
                    Text(
                      funFact,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFdbdad8),
                        fontSize: 12,
                        height: 1.5,
                        fontFamily: 'Serif',
                      ),
                    ),
),

                    const SizedBox(height: 16),

                    OutlinedButton(
                      onPressed: () => _launchWikipedia(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFdbdad8),
                        side: const BorderSide(
                          color: Color(0xFFdbdad8),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Dowiedz się więcej',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Serif',
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
