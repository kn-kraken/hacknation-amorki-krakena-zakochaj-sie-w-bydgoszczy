import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/header.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/swapper.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/date_page.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/preferences/preferences.dart';
import '../buttons/stamped_button.dart';
import '../event_tile.dart';
import '../main_app_bar.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context, state.status),
          body: _buildBody(context, state.status),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, PreferencesStatus status) {
    final cubit = context.read<PreferencesCubit>();
    final isInitial = status == PreferencesStatus.initial;
    final isSwiping = status == PreferencesStatus.listProfiles;

    // Check if the current status is one that uses BLoC navigation (i.e., not the MapScreen)
    final needsGoBack = status != PreferencesStatus.initial;

    return buildCustomAppBar(
      context: context,
      isInitialPage: isInitial,
      showBackButton: needsGoBack,
      showRefreshButton: isSwiping,
      cubit: cubit, // Pass the cubit for BLoC navigation
    );
  }

  Widget _buildBody(BuildContext context, PreferencesStatus status) {
    switch (status) {
      case PreferencesStatus.initial:
        return const InitialPage();
      case PreferencesStatus.listDatesShouldSwipe:
      case PreferencesStatus.listDatesNoSwipe:
        return const ListDatesPage();
      case PreferencesStatus.listProfiles:
        return const SwipeCardsScreenContent();
      case PreferencesStatus.datePage:
        return const DatePage();
    }
  }
}

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});
  static const String _kStampFramePath = 'assets/stamp.svg';
  static const Color _kBackgroundColor = Color(0xFFdbdad8);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PreferencesCubit>();

    return Container(
      color: _kBackgroundColor,
      child: Column(
        children: <Widget>[

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Header(text: 'CZEGO DZIŚ SZUKASZ'),
                    StampedButton(
                      text: 'SZUKAM PARY',
                      onPressed: () => cubit.startPreferencesFlow(),
                      svgAssetPath: _kStampFramePath,
                    ),
                    const SizedBox(height: 30),
                    StampedButton(
                      text: 'MAM PARTNERA/\nPARTNERKĘ',
                      onPressed: () => cubit.startPreferencesNoSwipe(),
                      svgAssetPath: _kStampFramePath,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated ListDatesPage with DateStampTile
class ListDatesPage extends StatelessWidget {
  const ListDatesPage({super.key});

  final List<Map<String, String>> dates = const [
    {
      'id': '1',
      'title': 'Coffee Date',
      'desc': 'Quick and casualQuick and casualQuick and casualQuick and casualQuick and casual',
      // 'image': 'assets/images/coffee.jpg', // Add your image path
    },
    {
      'id': '2',
      'title': 'Dinner & a Movie',
      'desc': 'A classic choice',
      // 'image': 'assets/images/dinner.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PreferencesCubit>();
    return ListView.builder(
      itemCount: dates.length,
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemBuilder: (context, index) {
        final date = dates[index];
        return EventTile(
          title: date['title']!,
          description: date['desc']!,
          imageUrl: date['image'],
          onTap: () => cubit.selectDate(date['id']!),
        );
      },
    );
  }
}