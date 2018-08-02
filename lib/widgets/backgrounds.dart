import 'package:flutter/material.dart';

class PageBackground extends StatelessWidget {
  PageBackground({ this.backColor, this.foreColor }) :
        assert(foreColor != null),
        assert(backColor != null);

  final Color backColor;
  final Color foreColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: backColor,
          ),
        ),
        Container(
          width: screenWidth * .85,
          height: screenHeight * .45,
          decoration: BoxDecoration(
              color: foreColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(360.0),
              )
          ),
        ),
      ],
    );
  }
}
