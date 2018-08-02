import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_time_tracker/widgets/cards.dart';
import 'package:flutter_time_tracker/widgets/buttons.dart';
import 'package:flutter_time_tracker/widgets/backgrounds.dart';
import 'package:flutter_time_tracker/widgets/generics.dart';

const double SIDE_PADDING = 24.0;

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Timer _timer;
  int _currentTimerValue = 0;

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), _handleTimerCallback);
  }

  _clearTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  _stopTimer() {
    _clearTimer();

    setState(() {
      _currentTimerValue = 0;
    });
  }

  _handleTimerCallback(Timer _timer) {
    setState(() {
      _currentTimerValue += 1;
    });
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
              GraphCard(),
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
        Text((height * 100).toString()),
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