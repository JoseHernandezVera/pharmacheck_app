import 'package:flutter/material.dart';
import 'base_pages.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Home',
      body: const Center(
        child: Text("Esta es la pagina de Home", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}