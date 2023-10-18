// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Volunteer extends StatefulWidget {
  @override
  _VolunteerState createState() => _VolunteerState();
}

class _VolunteerState extends State<Volunteer> {
  List<bool> isParticipated = List.filled(6, false);

  List<String> profileImages = [
    "https://randomuser.me/api/portraits/men/11.jpg",
    "https://randomuser.me/api/portraits/men/51.jpg",
    "https://randomuser.me/api/portraits/men/7.jpg",
    "https://randomuser.me/api/portraits/men/85.jpg",
    "https://randomuser.me/api/portraits/men/62.jpg",
    "https://randomuser.me/api/portraits/men/35.jpg",
  ];

  List<String> title = [
    "Empire State -> Fifth Ave.",
    "Park Ave. -> Wall Street",
    "Met -> Guggen. Museum",
    "Trader Joe's -> The Arconia",
    "Central Park West to Times Square",
    "Brooklyn Bridge to Coney Island",
  ];

  List<String> organizer = [
    "Lily Anderson",
    "Ethan Martinez",
    "Sophia Shin",
    "Aiden Thompson",
    "Olivia Davis",
    "Liam Wilson"
  ];

  List<String> date = [
    "10/21 1:00pm",
    "10/28 8:00am",
    "10/29 6:30pm",
    "11/02 12:00pm",
    "11/08 4:30pm",
    "11/12 9:30am",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green[200],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Community Events', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: title.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15.0),
    border: Border.all(
      color: Colors.green, // Set border color
      width: 1.0, // Set border width
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(profileImages[index]),
        ),
        SizedBox(width: 16.0), // Add space between the image and text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title[index],
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xff231f20))),
              Text('Organizer: ${organizer[index]}', style: TextStyle(color: Color(0xff231f20))),
              Text('Date: ${date[index]}', style: TextStyle(color: Color(0xff231f20))),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isParticipated[index] ? Colors.green : Colors.green[50],
          ),
          onPressed: () {
            setState(() {
              isParticipated[index] = !isParticipated[index];
            });
          },
          child: isParticipated[index]
              ? Icon(Icons.check, color: Colors.white,)
              : Text('RSVP', style: TextStyle(color: Colors.black),),
        ),
      ],
    ),
  ),
)

          );
        },
      ),
    );
  }
}
