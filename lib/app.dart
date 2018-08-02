import 'package:flutter/material.dart';
import 'pages/home.dart';

class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker (lite)',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Lato'
      ),
      home: HomePage(),
    );
  }
}
