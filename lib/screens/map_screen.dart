import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(0.0, 0.0); // Initial position set to 0,0
  bool _locationServiceEnabled = false;
  LocationPermission _locationPermission = LocationPermission.denied;
  LatLng? _currentLocation;
  TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _checkPermission();
    await _getCurrentLocation();
  }

  Future<void> _checkPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }

    _locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    _locationPermission = await Geolocator.checkPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_locationServiceEnabled &&
        _locationPermission != LocationPermission.denied &&
        _locationPermission != LocationPermission.deniedForever) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _initialPosition = _currentLocation!;
        _markers.add(
          Marker(
            markerId: MarkerId('current'),
            position: _currentLocation!,
            infoWindow: InfoWindow(
              title: 'Current Location',
            ),
          ),
        );
      });

      // Ensure the map controller is initialized before moving the camera
      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _initialPosition, zoom: 14.0),
          ),
        );
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _searchLocation() async {
    String searchText = _searchController.text;
    List<Location> locations = await locationFromAddress(searchText);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      LatLng searchedLocation = LatLng(location.latitude, location.longitude);

      // Clear existing markers and add new marker for searched location
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('searched'),
            position: searchedLocation,
            infoWindow: InfoWindow(
              title: searchText,
            ),
          ),
        );
      });

      // Move camera to searched location
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(searchedLocation, 14.0),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location Not Found'),
          content: Text(
              'Could not find the location "$searchText". Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            markers: _markers,
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Location',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _searchLocation,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
