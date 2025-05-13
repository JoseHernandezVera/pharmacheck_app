import 'package:flutter/material.dart';
import 'base_pages.dart';

class RememberPage extends StatelessWidget {
  const RememberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Remember',
      body: const Center(
        child: Text("Esta es la página de recordatorios", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}