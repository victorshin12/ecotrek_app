// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_new, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import "package:teamtrash/post.dart" as post;

class MakeRoute extends StatefulWidget {
  const MakeRoute({super.key});

  @override
  State<MakeRoute> createState() => _MakeRouteState();
}

class _MakeRouteState extends State<MakeRoute> {
  static const LatLng initialPos = LatLng(40.7396956, -74.002375);
  Marker? _startMarker;
  Marker? _destinationMarker;
  List<LatLng> coords = [LatLng(0, 0), LatLng(0, 0)];

  //important
  late LatLng startPoint;
  late LatLng endPoint;
  late List<LatLng> waypoints;

  void _onMapTap(LatLng position) {
    setState(() {
      if (_startMarker == null) {
        _startMarker = Marker(
          markerId: MarkerId("start"),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        //POST REQUEST START POSITION
        //POST REQUEST START POSITION
        coords[0] = position;
        print("Starting point: " + coords[0].toString());
      } else if (_destinationMarker == null) {
        _destinationMarker = Marker(
          markerId: MarkerId("destination"),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
        //POST REQUEST DESTINATION POSITION
        //POST REQUEST DESTINATION POSITION
        coords[1] = position;
        print("Destination point: " + coords[1].toString());
      } else {
        _startMarker = Marker(
          markerId: MarkerId("start"),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        _destinationMarker = null;
        print("Starting point: $position");
      }
    });
  }
  
final Completer<void> completer = Completer<void>();


void getData(List<LatLng> coords) async {
  try {
    String url = "http://128.61.72.92:8000/route?startLatitude=${coords[0].latitude}&startLongitude=${coords[0].longitude}&endLatitude=${coords[1].latitude}&endLongitude=${coords[1].longitude}";
    // String url = "http://localhost:8000/route?startLatitude=${coords[0].latitude}&startLongitude=${coords[0].longitude}&endLatitude=${coords[1].latitude}&endLongitude=${coords[1].longitude}";
    print(url);
    final response = await get(Uri.parse(url));
    print('Response body: ${response.body}');
    
    // Parse the response body
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    
    // Create Route from response
    post.Route route = post.Route.fromJson(responseBody);
    
    // Convert Points to LatLng
    startPoint = LatLng(double.parse(route.start.latitude.toString()), double.parse(route.start.longitude.toString()));
    endPoint = LatLng(double.parse(route.end.latitude.toString()), double.parse(route.end.longitude.toString()));
    waypoints = route.waypoints.map((point) => LatLng(double.parse(point.latitude.toString()), double.parse(point.longitude.toString()))).toList();
    print(startPoint);
    print(endPoint);
    print(waypoints);
    Navigator.pop(context, {'startPoint': startPoint, 'endPoint': endPoint, 'waypoints': waypoints});
    completer.complete();
  } catch (e) {
    print("Exception thrown: $e");
    completer.completeError(e);
  }
}

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(target: initialPos, zoom: 16),
          onTap: _onMapTap,
          markers:
              {_startMarker, _destinationMarker}.whereType<Marker>().toSet(),
        ),
        Row(
          children: [
            Spacer(),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: 65),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 60,
                    width: 160,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: 65),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 60,
                    width: 160,
                    child: FloatingActionButton(
  onPressed: () {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.green),
                SizedBox(height: 10,),
                Text("Creating a custom route!", style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        );
      },
    );
    getData(coords);

    // Wait for getData to finish
    completer.future.then((_) {
      Navigator.of(context).pop({'startPoint': startPoint, 'endPoint': endPoint, 'waypoints': waypoints}); // Pop the current page
    }).catchError((error) {
      // Handle any errors in getData
      print('Error in getData: $error');
      Navigator.of(context).pop(); // Pop the dialog
    });
  },
  child: Text(
    "Let's Go",
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold
    ),
  ),
  backgroundColor: Colors.green,
),


                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(top: 75),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 50,
                width: 225,
                child: FloatingActionButton(
                  onPressed: () {
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 7, bottom: 7),
                        child: Image.asset("assets/icon1.png")
                      ),
                      Text(
                        "  Start  |  ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7, bottom: 7),
                        child: Image.asset("assets/icon2.png")
                      ),
                      Text(
                        "  Dest.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
