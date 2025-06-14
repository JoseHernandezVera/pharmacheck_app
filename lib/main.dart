import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash.dart';
import 'providers/user_provider.dart';
import 'providers/people_provider.dart';
import 'providers/remedies_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PeopleProvider()),
        ChangeNotifierProvider(create: (_) => RemediesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaCheck',
      theme: ThemeData(
        fontFamily: 'Lato',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 3, 99, 179)),
      ),
      home: const SplashPage(),
    );
  }
}