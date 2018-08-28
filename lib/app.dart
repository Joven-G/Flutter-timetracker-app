import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/sp_widget.dart';

class TimeTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker (lite)',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Lato'
      ),
//      home: SpWidget(title: 'Test Title Value'),
      home: HomePage(),
    );
  }
}
