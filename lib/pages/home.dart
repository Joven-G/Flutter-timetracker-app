import 'package:flutter/material.dart';
import 'package:flutter_time_tracker/widgets/cards.dart';
import 'package:flutter_time_tracker/widgets/buttons.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 18.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Center(
                  child: Text('00:00:00', style: TextStyle(fontSize: 36.0)),
                ),
              ),
              SizedBox(height: 16.0),
              GraphCard(),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Recent Weeks', style: textTheme.title),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Browse List'),
                      Icon(Icons.arrow_forward)
                    ],
                  )
                ],
              ),
              SizedBox(height: 48.0),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AButton(
                    isRaised: true,
                    label: "TIME IN",
                    onPressed: () {
                      print("Time In...");
                    },
                  ),
                  AButton(
                    isRaised: false,
                    label: "TIME OUT",
                    onPressed: () {
                      print("Time Out");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
    // TODO: implement build
    return ACard(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // TODO: Add Bars
            ChartColumn(label: 'MON', height: .8),
            ChartColumn(label: 'TUE', height: .65),
            ChartColumn(label: 'WED', height: .86),
            ChartColumn(label: 'THU', height: .43),
            ChartColumn(label: 'FRI', height: .95),
          ],
        ),
      ),
    );
  }
}