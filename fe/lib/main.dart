import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/api.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/preferences/preferences_screen.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/swapper.dart';
import 'package:zakochaj_sie_w_bydgoszczy_fe/preferences/preferences.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swipe Cards',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Provider(
        create: (context) => ApiClient(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => PreferencesCubit()),
            BlocProvider(create: (_) => SwipeBloc()),
          ],
          child: const PreferencesScreen(),
        ),
      ),
    );
  }
}
