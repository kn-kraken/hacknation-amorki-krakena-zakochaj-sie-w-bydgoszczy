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

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final MaterialColor mySwatch = createMaterialColor(const Color(0xFFDBDAD8));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zakochaj się w Bydgoszczy',
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFdbdad8),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: mySwatch)
      ),
      home: Provider(
        create: (context) => ApiClient(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => PreferencesCubit()),
            BlocProvider(create: (context) => SwipeBloc(apiService: Provider.of<ApiClient>(context, listen: false).api)),
          ],
          child: const PreferencesScreen(),
        ),
      ),
    );
  }
}
