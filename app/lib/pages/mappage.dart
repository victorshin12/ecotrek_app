// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_new, prefer_final_fields, no_leading_underscores_for_local_identifiers, unused_element, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teamtrash/const.dart';
import 'package:teamtrash/pages/finish.dart';
import 'package:teamtrash/pages/makeroute.dart';
import 'package:teamtrash/pages/takepicture.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  Set<Marker> _markers = {};

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  bool onRoute = false;

  LatLng startPoint = LatLng(40.7396956, -74.002375);
  LatLng endPoint = LatLng(40.7396956, -74.002375);
  List<LatLng> waypoints = [
    // new LatLng(40.7396956, -74.002375),
  ];

  int tempTotal = 0;
  int numPicsTaken = 0;

  

  @override
  void initState() {
    super.initState();
    if (onRoute) {
      getLocationUpdate().then((_) => {
            getPolylinePoints().then((coordinates) => {
                  print(coordinates),
                  generatePolylineFromPoints(coordinates),
                })
          });
    } else {
      getLocationUpdate().then((_) => {
            getPolylinePoints().then((coordinates) => {
                  print(coordinates),
                  generatePolylineFromPoints(coordinates),
                })
          });
    }
  }
  void updateStartPoint(LatLng newStartPoint, LatLng newEndPoint, List<LatLng> newWaypoints) {
    setState(() {
      // print("BEFORE || ENDPOINT: " + endPoint.toString() + " START POINT: " + startPoint.toString());
      startPoint = newStartPoint;
      //newendpoint (long lat)
      endPoint = newEndPoint;
      // print("TO BE SET || ENDPOINT: " + newEndPoint.toString() + " START POINT: " + newStartPoint.toString());
      // print("AFTER || NEW ENDPOINT: " + endPoint.toString() + " NEW START POINT: " + startPoint.toString());
      
      
      //function to turn waypoints into polyline points
      print("Old: " + waypoints.toString());
      waypoints = newWaypoints;
      print("New: " + waypoints.toString());
      getPolylinePoints().then((coordinates) => {
                  print(coordinates),
                  generatePolylineFromPoints(coordinates),
                });

      _mapController.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: startPoint, zoom: 15),
          ),
        );
      });
      // Create a new set of markers
      Set<Marker> newMarkers = {
        Marker(
          markerId: MarkerId("_sourceLocation"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: startPoint,
        ),
        Marker(
          markerId: MarkerId("_destinationLocation"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: endPoint,
        ),
      };
      // Update the state to include the new markers
      setState(() {
        _markers = newMarkers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("EcoTrek", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _currentP == null
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
              myLocationButtonEnabled: false,
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: startPoint,
                zoom: 15,
              ),
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
            ),
      floatingActionButton: onRoute
          ? Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: SizedBox(
                    height: 60,
                    width: 160,
                    child: FloatingActionButton(
                      onPressed: () {
                        onRoute = false;
                        int a = numPicsTaken;
                        int b = tempTotal;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Finish(numPics: a, tempTotals: b)),
                        );
                        numPicsTaken = 0;
                        tempTotal = 0;
                        print("Route ended");
                      },
                      child: Text(
                        "Finish Route!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.red.shade400,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: SizedBox(
                    height: 60,
                    width: 160,
                    child: FloatingActionButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TakePicture()),
                        );
                        numPicsTaken++;
                        int intValue = Random().nextInt(4) + 1;
                        tempTotal = tempTotal + intValue;
                        print("TEMP TOTAL" + tempTotal.toString());
                        print("PICS TAKEN" + numPicsTaken.toString());
                        await incrementEcoPoints(intValue);
                      },
                      child: Text(
                        "Take Picture!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.blue.shade400,
                    ),
                  ),
                ),
                Spacer(),
              ],
            )
          : Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SizedBox(
              height: 60,
              width: 160,
              child: FloatingActionButton(
                onPressed: () async {
// When navigating to the new page
                  Map<String, dynamic>? result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MakeRoute()),
                  );

// After the new page is popped, result will contain the data sent back
                  if (result != null) {
                    onRoute = true;
                    LatLng newStartPoint = result['startPoint'];
                    LatLng newEndPoint = result['endPoint'];
                    List<LatLng> newWaypoints = result['waypoints'];
                    // print("------------------------------------");
                    // print(newStartPoint);
                    // print(newEndPoint);
                    // print(newWaypoints);
                    updateStartPoint(newStartPoint, newEndPoint, newWaypoints);
                    
                    //UPDATE WAYPOINTS
                  }
                },
                child: Text(
                  "Create Route!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.green,
              ),
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> incrementEcoPoints(int intValue) async {
  final prefs = await SharedPreferences.getInstance();
  int ecoPoints = prefs.getInt('ecoPoints') ?? 0;
  await prefs.setInt('ecoPoints', ecoPoints + intValue);
  print("Ecopoints incremented by: " + intValue.toString());
}

  Future<void> _cameraToolPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 15);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdate() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      print("enabled");
      _serviceEnabled = await _locationController.requestService();
    } else {
      print("not enabled");
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData _currentLocation) {
      if (_currentLocation.latitude != null &&
          _currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
          // _cameraToolPosition(_currentP!);
          // print(_currentP);
        });
      }
    });
  }

Future<List<LatLng>> getPolylinePoints() async {
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  
  // Convert each LatLng in waypoints to a PolylineWayPoint
  // Convert each LatLng in waypoints to a PolylineWayPoint
  // Convert each LatLng in waypoints to a PolylineWayPoint
  // print("=========================");
  // print("WAYPOINT TO BE SET: " + waypoints.toString());
  
int n = (waypoints.length / 7).ceil();
List<LatLng> selectedWaypoints = [];
for (int i = 0; i < waypoints.length; i += n) {
  selectedWaypoints.add(waypoints[i]);
}
selectedWaypoints.add(endPoint);

// print("SELECTED: " + selectedWaypoints.toString());

List<PolylineWayPoint> wayPoints = selectedWaypoints.map((latLng) {
  return PolylineWayPoint(location: "${latLng.latitude},${latLng.longitude}");
}).toList();

  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    GOOGLE_MAPS_API_KEY,
    PointLatLng(startPoint.latitude, startPoint.longitude),
    PointLatLng(endPoint.latitude, endPoint.longitude),
    travelMode: TravelMode.walking,
    wayPoints: wayPoints, // Use the converted waypoints here
  );

  if (result.points.isNotEmpty) {
    result.points.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
  } else {
    print(result.errorMessage);
  }
  // print("READ READ READ : " + polylineCoordinates.toString());
  return polylineCoordinates;
}

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
