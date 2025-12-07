import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventTile extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final VoidCallback onTap;
  final String svgAssetPath;

  const EventTile({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.onTap,
    this.svgAssetPath = 'assets/stamp.svg',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Outer container holds the SVG background and the foreground content.
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              // SVG BACKGROUND (no Positioned.fill!)
              SvgPicture.asset(
                svgAssetPath,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF6B1D27),
                  BlendMode.srcIn,
                ),

                // Let the SVG wrap content by giving it a max width
                width: 420,   // <--- ADJUST THIS (this makes SVG narrower)
                fit: BoxFit.contain,
              ),

              // CONTENT
              Padding(
                padding: const EdgeInsets.all(55),
                child: Row(
                  mainAxisSize: MainAxisSize.min,   // <--- important
                  children: [
                    // Picture
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _buildImage(),
                    ),

                    const SizedBox(width: 20),

                    // Text
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 220,  // keep text readable
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null) {
      return _buildPlaceholder();
    }

    final url = imageUrl!;
    if (url.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => _buildPlaceholder(),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => _buildPlaceholder(),
        ),
      );
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.white,
      child: const Icon(
        Icons.image,
        size: 40,
        color: Color(0xFF6B1D27),
      ),
    );
  }
}
