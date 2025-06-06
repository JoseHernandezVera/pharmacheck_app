import 'package:flutter/material.dart';
import 'pages/splash.dart';

void main() {
  runApp(const MyApp());
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
