import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/header.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/match.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/swapper.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/date_page.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/preferences/preferences.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/api.dart';
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
          body: _buildBody(context, state!),
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
      title: getTitle(status),
      cubit: cubit, // Pass the cubit for BLoC navigation
    );
  }

  String getTitle(PreferencesStatus status) {
    switch(status) {
      case PreferencesStatus.initial:
        return '';
      case PreferencesStatus.listDatesShouldSwipe:
      case PreferencesStatus.listDatesNoSwipe:
        return 'Wybierz swoją podróż przez dzieje!';
      case PreferencesStatus.listProfiles:
        return 'Wybierz towarzysza podróży!';
      case PreferencesStatus.datePage:
        return '';
      case PreferencesStatus.matched:
        return '';
    }
  }

  Widget _buildBody(BuildContext context, PreferencesState state) {
    switch (state.status) {
      case PreferencesStatus.initial:
        return const InitialPage();
      case PreferencesStatus.listDatesShouldSwipe:
      case PreferencesStatus.listDatesNoSwipe:
        return const ListDatesPage();
      case PreferencesStatus.listProfiles:
        return const SwipeCardsScreenContent();
      case PreferencesStatus.datePage:
        return const DatePage();
      case PreferencesStatus.matched:
        return MatchScreen(matchedCard: state.matchedCard!);
    }
  }
}

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});
  static const String _kStampFramePath = 'assets/stamp.svg';
  static const String _kDecorativePngPath = 'assets/your_image.png'; // Replace with your PNG path
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  children: [
                    const Text(
                      "Tutaj historia łączy…\n a my podpowiadamy z kim",
                      textAlign: TextAlign.center, // Center the text
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B1D27),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 30),
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
class ListDatesPage extends StatefulWidget {
  const ListDatesPage({super.key});

  @override
  State<ListDatesPage> createState() => _ListDatesPageState();
}

class _ListDatesPageState extends State<ListDatesPage> {
  List<ScenarioInfoRes> scenarios = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadScenarios();
  }

  Future<void> _loadScenarios() async {
    final apiClient = context.read<ApiClient>();
    final response = await apiClient.api.getScenarios();

    if (!response.isSuccessful && response.body != null) return;

    setState(() {
      scenarios = response.body!;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PreferencesCubit>();

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    return ListView.builder(
      itemCount: scenarios.length,
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        return EventTile(
          title: scenario.title,
          description: scenario.description,
          imageUrl: null, // ScenarioInfoRes doesn't have image field
          onTap: () => cubit.selectDate(scenario.id.toString()),
        );
      },
    );
  }
}
