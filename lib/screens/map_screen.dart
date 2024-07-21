import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(0.0, 0.0);
  bool _locationServiceEnabled = false;
  LocationPermission _locationPermission = LocationPermission.denied;
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String _distance = '0 km';
  String _duration = '0 min';

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

      if (mapController != null) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _initialPosition, zoom: 14.0),
          ),
        );
      }
    }
  }

  Future<void> _searchLocation() async {
    String searchText = _searchController.text;
    List<Location> locations = await locationFromAddress(searchText);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      LatLng searchedLocation = LatLng(location.latitude, location.longitude);

      setState(() {
        _destinationLocation = searchedLocation;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('current'),
            position: _currentLocation!,
            infoWindow: InfoWindow(
              title: 'Current Location',
            ),
          ),
        );
        _markers.add(
          Marker(
            markerId: MarkerId('destination'),
            position: _destinationLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
            infoWindow: InfoWindow(
              title: searchText,
            ),
          ),
        );

        if (_currentLocation != null && _destinationLocation != null) {
          double distanceInMeters = Geolocator.distanceBetween(
            _currentLocation!.latitude,
            _currentLocation!.longitude,
            _destinationLocation!.latitude,
            _destinationLocation!.longitude,
          );
          setState(() {
            _distance = (distanceInMeters / 1000).toStringAsFixed(2) + ' km';
          });
        }

        _getDirections();
      });

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

  Future<void> _getDirections() async {
    if (_currentLocation == null || _destinationLocation == null) return;

    final url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}'
        '&key=AIzaSyAnsK0I2lw7YP3qhUthMBtlsiJ31WVkPrY';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final points = data['routes'][0]['overview_polyline']['points'];
      final List<LatLng> polylinePoints = _convertToLatLng(_decodePoly(points));
      final duration = data['routes'][0]['legs'][0]['duration']['text'];
      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: polylinePoints,
          ),
        );
        _duration = duration;
      });
    }
  }

  List<LatLng> _convertToLatLng(List<PointLatLng> points) {
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  List<PointLatLng> _decodePoly(String encoded) {
    var poly = encoded.codeUnits;
    var list = <PointLatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly[index++] - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1)) + lat;
      lat = dlat;
      shift = 0;
      result = 0;
      do {
        b = poly[index++] - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1)) + lng;
      lng = dlng;
      list.add(PointLatLng(lat / 1E5, lng / 1E5));
    }
    return list;
  }

  void _centerOnCurrentLocation() {
    if (_currentLocation != null && mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 14.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _centerOnCurrentLocation,
          ),
        ],
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
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  SizedBox(height: 10),
                  Text(
                    'Distance: $_distance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.directions_car, color: Colors.blue),
                      SizedBox(width: 8.0),
                      Text(
                        '$_distance',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '$_duration',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Traffic: Light',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}

class PointLatLng {
  final double latitude;
  final double longitude;

  PointLatLng(this.latitude, this.longitude);
}
