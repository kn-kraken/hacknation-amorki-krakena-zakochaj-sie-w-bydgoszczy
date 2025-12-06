import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/swapper.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/preferences/preferences.dart';

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
    String title = '';
    List<Widget> actions = [];

    if (status == PreferencesStatus.initial) {
      title = 'Start Dating';
    } else if (status == PreferencesStatus.listDates) {
      title = 'LIST OF DATES';
    } else if (status == PreferencesStatus.listProfiles) {
      title = 'MATCHING PROFILES';
      actions = [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => context.read<SwipeBloc>().add(ResetCards()),
        ),
      ];
    }

    return AppBar(
      title: Text(title),
      leading: status != PreferencesStatus.initial
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // TODO: Implement a simple goBack logic in the cubit if desired, or just navigate back to the previous state.
        },
      )
          : null,
      actions: actions,
    );
  }

  // Helper to swap the body content
  Widget _buildBody(BuildContext context, PreferencesStatus status) {
    switch (status) {
      case PreferencesStatus.initial:
        return const InitialPage();
      case PreferencesStatus.listDates:
        return const ListDatesPage();
      case PreferencesStatus.listProfiles:
        return const SwipeCardsScreenContent();
    }
  }
}

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PreferencesCubit>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Looking for love?', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => cubit.startPreferencesFlow(),
            child: const Text('YES'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: NO logic here yet
            },
            child: const Text('NO'),
          ),
        ],
      ),
    );
  }
}

class ListDatesPage extends StatelessWidget {
  const ListDatesPage({super.key});
  final List<Map<String, String>> dates = const [
    {'id': '1', 'title': 'Coffee Date', 'desc': 'Quick and casual'},
    {'id': '2', 'title': 'Dinner & a Movie', 'desc': 'A classic choice'},
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PreferencesCubit>();
    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        return ListTile(
          leading: const Icon(Icons.favorite),
          title: Text(date['title']!),
          subtitle: Text(date['desc']!),
          onTap: () => cubit.selectDate(date['id']!),
        );
      },
    );
  }
}
