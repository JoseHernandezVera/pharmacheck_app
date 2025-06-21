import 'package:google_maps_flutter/google_maps_flutter.dart';

class Person {
  final String name;
  String imagePath;
  LatLng? location;
  String address;

  Person({
    required this.name,
    required this.imagePath,
    this.location,
    this.address = '',
  });

  void updateLocation(LatLng newLocation, String newAddress) {
    location = newLocation;
    address = newAddress;
  }
}