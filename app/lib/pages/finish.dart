// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class Finish extends StatefulWidget {
  final int numPics;
  final int tempTotals;

  Finish({Key? key, required this.numPics, required this.tempTotals}) : super(key: key);

  @override
  State<Finish> createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  @override
  void initState() {
    super.initState();
    print("NP:" + widget.numPics.toString());
    print("TT:" + widget.tempTotals.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Spacer(),
            SizedBox(
              height: 120,
              width: 120,
              child: Image.asset("assets/plant.png")
            ),
            SizedBox(height: 50,),
            Center(
              child: Text(
                "Thank you for making Earth a cleaner place for the future.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 50,),
            Center(
              child: Text(
              "Litter Picked Up: ${widget.numPics}",
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.w600
              ),
              )
            ),
            Center(
              child: Text(
              "EcoPoints Earned: ${widget.tempTotals}",
              style: TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.w600
              ),
              )
            ),
            SizedBox(height: 90,),
            SizedBox(
              height: 60,
              width: 100,
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 18),),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}