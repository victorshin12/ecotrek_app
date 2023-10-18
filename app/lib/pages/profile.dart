// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  List<String> listImage = [];

  Future<void> loadImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images');

    if (await imagesDir.exists()) {
      listImage = imagesDir.listSync().map((item) => item.path).toList();

      listImage.sort((a, b) =>
          File(b).lastModifiedSync().compareTo(File(a).lastModifiedSync()));

      print("IMAGE: $listImage");
    }
  }
}

Future<int> getEcoPoints() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('ecoPoints') ?? 0;
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Profile profile = Profile();
  late Future<void> loadImagesFuture;
  late Future<int> ecoPoints;

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  void refreshPage() {
    loadImagesFuture = profile.loadImages();
    ecoPoints = getEcoPoints();
    ecoPoints.then((value) {
      print(value); // Prints the value of ecoPoints
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadImagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  //DELETE IMAGES --> DANGEROUSDANGEROUSDANGEROUSDANGEROUS
                  // SizedBox(
                  //   height: 50,
                  // ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     final prefs = await SharedPreferences.getInstance();
                  //     int ecoPoints = prefs.getInt('ecoPoints') ?? 0;
                  //     await prefs.setInt('ecoPoints', 0);

                  //     final appDir = await getApplicationDocumentsDirectory();
                  //     final imagesDir = Directory('${appDir.path}/images');

                  //     if (await imagesDir.exists()) {
                  //       imagesDir.listSync().forEach((fileSystemEntity) {
                  //         if (fileSystemEntity is File) {
                  //           print('Deleting file: ${fileSystemEntity.path}');
                  //           fileSystemEntity.deleteSync();
                  //         }
                  //       });
                  //       print('All images deleted');
                  //     }
                  //   },
                  //   child: Text('Delete All Images'),
                  // ),
                  SizedBox(height: 90), // Add some spacing at the top
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      radius: 68,
                      backgroundImage: AssetImage(
                          'assets/profile_image.png'), // Replace with your asset image
                    ),
                  ),
                  SizedBox(height: 10), // Add some spacing
                  Text(
                    'victorShin12', // Replace with your username
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30), // Add some spacing
                  Container(
                    child: Divider(),
                    width: 200,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "EcoPoints",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  FutureBuilder<int>(
                    future: ecoPoints,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading spinner while waiting
                      } else {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else
                          return Text('${snapshot.data} 🌱',
                              style:
                                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold)); // Display ecoPoints
                      }
                    },
                  ),

                  SizedBox(height: 15), // Add some spacing
                  Container(
                    child: Divider(),
                    width: 200,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Past Memories 🎞",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GridView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10), // Add horizontal padding
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                      childAspectRatio: 1, // Aspect ratio of each item
                    ),
                    itemCount: profile.listImage.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Make the images have rounded corners
                        child: Image.file(
                          File(profile.listImage[index]),
                          fit: BoxFit
                              .cover, // Make the image cover the entire grid cell
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[200],
        onPressed: () {
          setState(() {
            refreshPage(); // Refresh the page when the button is pressed
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
