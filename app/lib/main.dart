import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teamtrash/home.dart';
import 'package:teamtrash/pages/finish.dart';
import 'package:teamtrash/pages/mappage.dart';
import 'package:teamtrash/pages/takepicture.dart';
import 'package:teamtrash/pages/volunteer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      title: 'TeamTrash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}
