// Reusable component that can be called from any screen's Scaffold
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/preferences/preferences.dart'; // Needed for PreferencesCubit/Status

const _kCupidIconPath = 'assets/cupid-bow.svg';
const _kRedCupidColor = Color(0xFF6B1D27);

Widget _buildProfileCircle() {
  return Container(
    width: 40,
    height: 40,
    margin: const EdgeInsets.only(right: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
    ),
  );
}

// Function to generate the custom AppBar
AppBar buildCustomAppBar({
  required BuildContext context,
  bool isInitialPage = false,
  bool showBackButton = false,
  bool showRefreshButton = false,
  // Pass the cubit directly if the back button logic is needed
  PreferencesCubit? cubit,
}) {
  List<Widget> actions = [];
  Widget? leadingWidget;

  actions.add(_buildProfileCircle()); // Always show profile circle

  if (isInitialPage) {
    // INITIAL SCREEN: Cupid Arrow only
    leadingWidget = Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SvgPicture.asset(
        _kCupidIconPath,
        height: 40,
        width: 40,
        colorFilter: const ColorFilter.mode(
          _kRedCupidColor,
          BlendMode.srcIn,
        ),
      ),
    );
  } else {
    // OTHER SCREENS: Cupid Arrow + Back Button
    leadingWidget = Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            _kCupidIconPath,
            height: 40,
            width: 40,
            colorFilter: const ColorFilter.mode(
              _kRedCupidColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          // Back button logic
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: _kRedCupidColor, size: 24),
              onPressed: () {
                if (cubit != null) {
                  cubit.goBack(); // Use the BLoC navigation
                } else {
                  // Fallback for screens outside BLoC flow (like MapScreen)
                  Navigator.of(context).pop();
                }
              },
            ),
        ],
      ),
    );
  }

  return AppBar(
    title: const Text(''),
    leading: leadingWidget,
    leadingWidth: isInitialPage ? 56 : 120,
    actions: actions,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}