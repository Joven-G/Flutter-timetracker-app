import 'package:flutter/material.dart';

class AButton extends StatelessWidget {
  AButton({
    this.isRaised = true,
    this.label,
    this.onPressed
  });

  final bool isRaised;
  final String label;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final buttonChild = Text(label);

    return isRaised ?
      RaisedButton( child: buttonChild, onPressed: onPressed ) :
      FlatButton( child: buttonChild, onPressed: onPressed );
  }
}


