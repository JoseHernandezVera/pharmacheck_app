import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash.dart';
import 'providers/user_provider.dart';
import 'providers/people_provider.dart';
import 'providers/remedies_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/location_provider.dart';
import 'themes/theme.dart';
import 'themes/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsProvider = SettingsProvider();
  await settingsProvider.loadPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PeopleProvider()),
        ChangeNotifierProvider(create: (_) => RemediesProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final textTheme = createTextTheme(context, "Roboto", "Roboto Condensed");
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'PharmaCheck',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: settings.themeMode,
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
