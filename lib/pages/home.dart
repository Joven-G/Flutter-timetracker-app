import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/data/checkin.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter_time_tracker/widgets/cards.dart';
import 'package:flutter_time_tracker/widgets/buttons.dart';
import 'package:flutter_time_tracker/widgets/backgrounds.dart';
import 'package:flutter_time_tracker/widgets/generics.dart';

import 'package:shared_preferences/shared_preferences.dart';

const double SIDE_PADDING = 24.0;
const int EXPECTED_TIME_FRAME = 28800;
const String TIME_RECORDINGS_KEY = 'flt_time_tracker_data';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Timer _timer;
  int _currentTimerValue = 0;

  Future<List<CheckIn>> _checkIns;

  CheckIn currentCheckIn;

  Future<Null> _startTimer() async {
    setState(() {
      _currentTimerValue = 0;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final checkIns = await fetchCheckInsFromPrefs();
    currentCheckIn = CheckIn(Uuid().v4().toString(), DateTime.now(), 0, DateTime.now());
    checkIns.add(currentCheckIn);

    prefs.setString(TIME_RECORDINGS_KEY, json.encode(checkIns));
    _timer = Timer.periodic(Duration(seconds: 1), _handleTimerCallback);
  }

  _clearTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  Future<Null> _stopTimer() async {
    _clearTimer();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var checkIns = await fetchCheckInsFromPrefs();

    checkIns.remove(currentCheckIn);
    currentCheckIn.elapsed = _currentTimerValue;
    checkIns.add(currentCheckIn);

    setState(() {
      _currentTimerValue = 0;
      _checkIns = prefs.setString(TIME_RECORDINGS_KEY, json.encode(checkIns)).then((bool success) {
        return checkIns;
      });
    });
  }

  _handleTimerCallback(Timer _timer) {
    setState(() {
      _currentTimerValue += 1;
    });
  }

  @override
  void initState() {
    super.initState();

    // Fetch List of Data from SharedPreferences
    _checkIns = fetchCheckInsFromPrefs();
  }

  Future<List<CheckIn>> fetchCheckInsFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final theList = prefs.getString(TIME_RECORDINGS_KEY) ?? '';

    var jsonList = json.decode(theList) as List;
    return jsonList.map((entry) => CheckIn.fromJson(entry)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageBackground(
            backColor: Colors.grey[200],
            foreColor: Theme.of(context).primaryColor,
          ),
          ListView(
            children: <Widget>[
              ASpacer(),
              TimeWidget(currentTimerValue: _currentTimerValue),
              ASpacer(),
              new FutureBuilder<List<CheckIn>>(
                future: _checkIns,
                builder: (BuildContext context, AsyncSnapshot<List<CheckIn>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError)
                        return new Text('Error::: ${snapshot.error}');
                      else
                        return GraphCard(snapshot.data);
                  }
                }
              ),
              ASpacer(),
              WeekView(),
              ASpacer(),
              TimerControl(
                startHandler: null == _timer || !_timer.isActive ?
                  () => _startTimer() : null,
                stopHandler: null != _timer && _timer.isActive ?
                  () => _stopTimer() : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _clearTimer();
    super.dispose();
  }
}

class TimerControl extends StatelessWidget {
  // Ensure at least one of the handlers is always set
  TimerControl({ this.startHandler, this.stopHandler }) :
    assert(null != startHandler || null != stopHandler);

  final Function startHandler;
  final Function stopHandler;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        null != startHandler ?
        AButton(
          label: "CHECK IN",
          onPressed: startHandler,
        ) :
        AButton(
          isRaised: false,
          label: "STOP TIMER",
          onPressed: stopHandler,
        ),
      ],
    );
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({ this.currentTimerValue = 0 });
  final currentTimerValue;

  String _elapsedTime() {
    if (0 == currentTimerValue) {
      return '00:00:00';
    }

    final double hours = currentTimerValue / 3600;
    final double minutes = (currentTimerValue / 60) % 60;
    final seconds = currentTimerValue % 60;

    return hours.floor().toString().padLeft(2, '0') + ':' +
      minutes.floor().toString().padLeft(2, '0') + ':' +
      seconds.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SIDE_PADDING * 1.5),
      width: MediaQuery.of(context).size.width * .8,
      child: Center(
        child: Text(
          _elapsedTime(),
          style: TextStyle(
            fontSize: 64.0,
            fontFamily: 'Calculator',
            color: Colors.white
          )
        ),
      )
    );
  }
}

class ChartColumn extends StatelessWidget {
  const ChartColumn({ this.label, this.height });

  final String label;
  final double height;
  final _wellHeight = SIDE_PADDING * 5.25;
  final _barWidth = SIDE_PADDING / 1.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label),
        ASpacer(height: 8.0),
        Stack(
          children: <Widget>[
            _well,
            buildChartSpine(height, context)
          ],
          alignment: AlignmentDirectional.bottomStart
        ),
        ASpacer(height: SIDE_PADDING / 3),
        Text((height * 100).toStringAsFixed(2)),
      ],
    );
  }

  Widget buildChartSpine(double height, BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      height: _wellHeight * height,
      width: _barWidth,
    );
  }

  Widget get _well {
    return Container(
      decoration: BoxDecoration(
        color: Colors.greenAccent[100],
      ),
      height: _wellHeight,
      width: _barWidth,
    );
  }
}

class GraphCard extends StatelessWidget {
  GraphCard(this.checkIns);
  final List<CheckIn> checkIns;

  getChartColumns() {
    if (this.checkIns.isEmpty) {
      return <ChartColumn>[];
    }

    return this.checkIns.map((CheckIn checkIn) {
      return ChartColumn(
        label: checkIn.day?.day?.toString() ?? 'DEF',
        height: (checkIn.elapsed ?? (EXPECTED_TIME_FRAME / 2)) / EXPECTED_TIME_FRAME,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: SIDE_PADDING),
      child: ACard(
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.all(SIDE_PADDING * .5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: getChartColumns(),
          ),
        ),
      ),
    );
  }
}

class WeekView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: SIDE_PADDING),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text('Recent Weeks', style: textTheme.title),
              ),
              InkWell(
                onTap: () => print('Browse List...'),
                child: Row(
                  children: <Widget>[
                    Text('Browse List'),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              )
            ],
          ),
        ),
        ASpacer(height: 16.0),
        Container(
          height: 160.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _buildCards(5),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCards (int count) {
    final cardList = <Widget>[];

    for (int i = 0; i < count; i++) {
      cardList.add(
          Container(
            margin: const EdgeInsets.only(bottom: SIDE_PADDING / 3),
            width: 200.0,
            child: ATapCard(
              onTap: () => print('Card $i tapped!'),
              child: Padding(
                padding: const EdgeInsets.all(SIDE_PADDING / 1.5),
                child: Text(i.toString()),
              ),
            ),
          )
      );
    }

    return cardList.toList();
  }
}