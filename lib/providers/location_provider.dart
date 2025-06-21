import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  LatLng? _patientLocation;
  String _patientAddress = '';

  LatLng? get patientLocation => _patientLocation;
  String get patientAddress => _patientAddress;

  LocationProvider() {
    _loadData();
  }

  void setPatientLocation(LatLng location) {
    _patientLocation = location;
    notifyListeners();
  }

  Future<void> setPatientAddress(String address) async {
    _patientAddress = address;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('patientAddress', address);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _patientAddress = prefs.getString('patientAddress') ?? '';
    notifyListeners();
  }
}