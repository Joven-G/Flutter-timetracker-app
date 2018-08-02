import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_time_tracker/widgets/cards.dart';
import 'package:flutter_time_tracker/widgets/buttons.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget get _spacer {
    return SizedBox(height: 16.0);
  }

  Timer _timer;
  int _currentTimerValue = 0;

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), _handleTimerCallback);
  }

  _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
      print("Timer cancelled with $_currentTimerValue seconds elapsed");
      setState(() {
        _currentTimerValue = 0;
      });
    }
  }

  _handleTimerCallback(Timer _timer) {
    setState(() {
      _currentTimerValue += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            _spacer,
            TimeWidget(currentTimerValue: _currentTimerValue),
            _spacer,
            GraphCard(),
            _spacer,
            WeekView(),
            _spacer,
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AButton(
                  isRaised: true,
                  label: "TIME IN",
                  onPressed: null == _timer || !_timer.isActive ? () {
                    _startTimer();
                  } : null,
                ),
                AButton(
                  isRaised: false,
                  label: "TIME OUT",
                  onPressed: null != _timer && _timer.isActive ? () {
                    _stopTimer();
                  } : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({ this.currentTimerValue });

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
      margin: const EdgeInsets.symmetric(horizontal: 36.0),
      width: MediaQuery.of(context).size.width * .8,
      child: Center(
        child: Text(
          _elapsedTime(),
          style: TextStyle(
            fontSize: 48.0,
            fontFamily: 'Calculator'
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
  final _wellHeight = 128.0;
  final _barWidth = 16.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label),
        SizedBox(height: 8.0),
        Stack(
          children: <Widget>[
            _well,
            buildChartSpine(height)
          ],
          alignment: AlignmentDirectional.bottomStart
        ),
        SizedBox(height: 8.0),
        Text((height * 100).toString()),
      ],
    );
  }

  Widget buildChartSpine(double height) {
    return Container(
      decoration: BoxDecoration(color: Colors.green[400]),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ACard(
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ChartColumn(label: 'MON', height: .8),
              ChartColumn(label: 'TUE', height: .65),
              ChartColumn(label: 'WED', height: .86),
              ChartColumn(label: 'THU', height: .43),
              ChartColumn(label: 'FRI', height: .95),
            ],
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
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
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
        SizedBox(height: 16.0),
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
            width: 200.0,
            child: ATapCard(
              onTap: () => print('Card $i tapped!'),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(i.toString()),
              ),
            ),
          )
      );
    }

    return cardList.toList();
  }
}