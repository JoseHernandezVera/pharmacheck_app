import 'package:flutter/material.dart';

class RememberPage extends StatelessWidget {
  const RememberPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Remember")),
      body: const Center(child: Text("Remember Page")),
    );
  }
}