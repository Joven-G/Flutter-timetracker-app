import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_time_tracker/data/checkin.dart';
import 'dart:convert';

class SpWidget extends StatefulWidget {
  SpWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SpWidgetState createState() => _SpWidgetState();
}

class _SpWidgetState extends State<SpWidget> {
  int _counter = 0;
  List<CheckIn> _checkins = <CheckIn>[];

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0);
      final jsonData = prefs.getString('flt_time_traker_data') ?? '[]';
      final List<Map<String, dynamic>> parsedJson = json.decode(jsonData) as List<Map<String, dynamic>>;

      print('JSON Data: ' + jsonData);
    });
  }

  //Incrementing counter after click
  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      final jsonData = prefs.getString('flt_time_tracker_data');
      var parsedJson = json.decode(jsonData) as List;
      List<CheckIn> checkins = parsedJson.map((i) => CheckIn.fromJson(i)).toList();

      print('JSON Data: ' + jsonData);
      print(checkins[0].id);
    });

//    prefs.setString('flt_time_tracker_data', '[{"id":"1232", "day": null, "startTime": null, "elapsed": 200}]');
    prefs.setInt('counter', _counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}