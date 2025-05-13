import 'package:flutter/material.dart';
import 'home.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Splash")),
      body: Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: AnimatedBuilder(
            animation: AlwaysStoppedAnimation(1),
            child: CircularProgressIndicator(
              strokeWidth: 8,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: 2 * 3.14159265359 * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}