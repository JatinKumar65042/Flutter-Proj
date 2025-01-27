import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  late GoogleMapController _mapController;
  final Location _location = Location();

  LatLng? _currentPosition;
  bool _isLoading = true; // Show loader initially
  final String _currentUserUid = 'userUID'; // This should come from your auth system (e.g., FirebaseAuth)

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _getCurrentLocation();
  }

  Future<void> _checkLocationPermission() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          debugPrint("Location services not enabled.");
          return;
        }
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          debugPrint("Location permission denied.");
          return;
        }
      }
      debugPrint("Location permission granted.");
    } catch (e) {
      debugPrint("Error checking location permissions: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
          _isLoading = false; // Stop showing loader
        });

        // Move the map camera to the user's location
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition!, zoom: 15.0),
          ),
        );

        // Update the location in Firestore after getting current location
        await _updateLocationInFirestore();
      }

      // Listen for location changes
      _location.onLocationChanged.listen((LocationData newLocation) {
        if (newLocation.latitude != null && newLocation.longitude != null) {
          setState(() {
            _currentPosition = LatLng(newLocation.latitude!, newLocation.longitude!);
          });

          // Update camera position
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _currentPosition!, zoom: 15.0),
            ),
          );

          // Update the location in Firestore whenever the location changes
          _updateLocationInFirestore();
        }
      });
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  // Function to update user's location in Firestore
  Future<void> _updateLocationInFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users')
          .doc(_currentUserUid) // Use current user's UID
          .update({
        'location': GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude),
        'timestamp': FieldValue.serverTimestamp(),
      });

      debugPrint("Location updated in Firestore.");
    } catch (e) {
      debugPrint("Error updating location in Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker'),
      ),
      body: Stack(
        children: [
          if (_currentPosition != null)
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 11.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
