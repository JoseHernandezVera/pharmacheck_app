import 'package:flutter/material.dart';
//import 'pages/home.dart';
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
        fontFamily: 'Storyboo',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const SplashPage(),
    );
  }
}