import 'package:flutter/material.dart';

class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker (lite)',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        body: Container(
          child: Center(
            child: Text('Time Tracker'),
          ),
        ),
      ),
    );
  }
}