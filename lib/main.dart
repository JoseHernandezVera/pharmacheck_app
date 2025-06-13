import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'pages/splash.dart';
import 'pages/no_internet_screen.dart';
import 'theme/app_theme.dart';

Future<bool> _checkRealInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final connectivityResult = await Connectivity().checkConnectivity();
  final hasNetworkConnection = connectivityResult != ConnectivityResult.none;

  final hasInternet = hasNetworkConnection && await _checkRealInternetConnection();

  runApp(PharmaCheckApp(hasInternet: hasInternet));
}

class PharmaCheckApp extends StatelessWidget {
  final bool hasInternet;
  
  const PharmaCheckApp({super.key, required this.hasInternet});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PharmaCheck',
      theme: AppTheme.lightTheme,
      home: hasInternet ? const SplashPage() : const NoInternetScreen(),
    );
  }
}