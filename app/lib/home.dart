// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:teamtrash/pages/mappage.dart';
import 'package:teamtrash/pages/profile.dart';
import 'package:teamtrash/pages/volunteer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    MapPage(),
    Volunteer(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
bottomNavigationBar: BottomNavigationBar(
  selectedIconTheme: IconThemeData(size: 26),
  unselectedIconTheme: IconThemeData(size: 24),
  selectedFontSize: 16,
  backgroundColor: Colors.green,
  unselectedItemColor: Colors.green[100],
  selectedItemColor: Colors.white,
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Map',
    ),
        BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Community',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
)
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
