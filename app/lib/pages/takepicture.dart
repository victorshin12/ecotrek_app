// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace, unnecessary_new

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({Key? key}) : super(key: key);

  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Image Upload', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
leading: IconButton(
  icon: new Icon(Icons.arrow_back, color: Colors.white),
  onPressed: () => Navigator.of(context).pop(),
), 
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Spacer(),
            Container(
              width: 160,
              child: FloatingActionButton(
                onPressed: () {
                  _pickImageFromCamera();
                },
                backgroundColor: Colors.green,
                child: Text("Take Image!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _selectedImage != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 450,
                    width: MediaQuery.of(context).size.width - 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(_selectedImage!),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 450,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Center(child: Text("Your image will appear here!"))),
            SizedBox(height: 20),
            Container(
              width: 250,
              child: FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        iconColor: Colors.green,
                        backgroundColor: Colors.white,
                        title: Text('Great job! 😊'),
                        content: Text(
                          'Your reward will be collected at the end!',
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: <Widget>[
                          FloatingActionButton(
                            elevation: 0,
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Closes the dialog
                              Navigator.of(context).pop(); // Navigates back
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                backgroundColor: Colors.green,
                child: Text("Submit and Earn Points!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
              ),
            ),
            Spacer(),
            Spacer(),
            Spacer(),
          ],
        ),
      ),
    );
  }

Future _pickImageFromCamera() async {
  final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
  
  if (returnedImage != null) {
    final File imageFile = File(returnedImage.path); // Convert XFile to File
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images');
    
    // Check if the directory exists
    if (!await imagesDir.exists()) {
      // If not, create the directory
      await imagesDir.create();
    }

    final fileName = path.basename(imageFile.path);
    final localImagePath = '${imagesDir.path}/$fileName';
    final localImage = await imageFile.copy(localImagePath);

    setState(() {
      _selectedImage = localImage;
    });

    

  }
}

}