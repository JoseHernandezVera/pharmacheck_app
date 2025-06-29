import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'no_internet.dart';
import '../models/model_drawer.dart';
import '../providers/location_provider.dart';
import '../models/person_model.dart';

class MapPage extends StatefulWidget {
  final Person? person;
  const MapPage({super.key, this.person});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Connectivity _connectivity = Connectivity();
  bool _hasInternet = true;
  bool _isLoading = true;
  bool _firstTime = true;
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Person? _currentPerson;
  LatLng? _currentLocation;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 2,
  );

  @override
  void initState() {
    super.initState();
    _currentPerson = widget.person;
    _checkInternetAndLocation();
  }

  @override
  void didUpdateWidget(MapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.person != oldWidget.person) {
      _currentPerson = widget.person;
      _updateMapForCurrentPerson();
    }
  }

  Future<void> _updateMapForCurrentPerson() async {
    if (_currentPerson == null) return;
    
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    
    if (_currentLocation != null) {
      locationProvider.setPatientLocation(_currentLocation!);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      await _checkInternetAndLocation();
    }
  }

  Future<void> _checkInternetAndLocation() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    final hasConnection = connectivityResult.isNotEmpty &&
        !connectivityResult.contains(ConnectivityResult.none);

    if (!hasConnection) {
      if (mounted) {
        setState(() {
          _hasInternet = false;
          _isLoading = false;
        });
      }
      return;
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!serviceEnabled) {
          throw 'Servicios de ubicación desactivados';
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permisos de ubicación denegados';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Permisos de ubicación permanentemente denegados';
      }

      Position position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      
      final newLocation = LatLng(position.latitude, position.longitude);
      _currentLocation = newLocation;
      
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      locationProvider.setPatientLocation(newLocation);

      if (mounted) {
        setState(() {
          _hasInternet = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener ubicación: \$e')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _retryConnection() async {
    setState(() => _isLoading = true);
    await _checkInternetAndLocation();
  }

  Future<void> _showAddressDialog() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    _addressController.text = locationProvider.patientAddress;
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentPerson != null 
          ? 'Dirección de \${_currentPerson!.name}'
          : 'Dirección del paciente'),
        content: TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            hintText: 'Ingrese la dirección completa',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_addressController.text.isNotEmpty) {
                locationProvider.setPatientAddress(_addressController.text);
                if (_firstTime) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dirección guardada por primera vez')),
                  );
                }
                setState(() => _firstTime = false);
                navigator.pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return NoInternetPage(
        onRetry: _retryConnection,
        previousRoute: '/map',
      );
    }

    final locationProvider = Provider.of<LocationProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const ModelDrawer(),
      appBar: AppBar(
        title: Text(
          _currentPerson != null 
            ? 'Ubicación de \${_currentPerson!.name}'
            : 'Mapa',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              size: 32,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition:
                              locationProvider.patientLocation != null
                                  ? CameraPosition(
                                      target: locationProvider.patientLocation!,
                                      zoom: 14,
                                    )
                                  : _initialPosition,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          markers: locationProvider.patientLocation != null
                              ? {
                                  Marker(
                                    markerId: MarkerId(
                                      _currentPerson?.name ?? 'defaultLocation'),
                                    position: locationProvider.patientLocation!,
                                    infoWindow: InfoWindow(
                                      title: _currentPerson != null
                                        ? 'Ubicación de \${_currentPerson!.name}'
                                        : 'Ubicación actual'),
                                  ),
                                }
                              : {},
                        ),
                      ),
                    ),
                  ),
                ),
          if (locationProvider.patientAddress.isNotEmpty)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Dirección: \${locationProvider.patientAddress}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddressDialog();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.edit_location,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
