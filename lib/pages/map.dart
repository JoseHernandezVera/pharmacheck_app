import 'package:flutter/material.dart';
import 'base_pages.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(255, 3, 99, 179),
      ),
      drawer: const BasePage(title: 'Map'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Image.asset(
            'assets/images/mapa.jpg',
            width: screenWidth * 0.9,
            height: screenHeight * 0.7,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}