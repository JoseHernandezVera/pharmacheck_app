//Codigo de Jose hernandez Vera
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/splash.dart';
import 'providers/user_provider.dart';
import 'providers/people_provider.dart';
import 'providers/remedies_provider.dart';
import 'themes/theme.dart';
import 'themes/util.dart';

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
    final textTheme = createTextTheme(context, "Roboto", "Roboto Condensed");
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'PharmaCheck',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}