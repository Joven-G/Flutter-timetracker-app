import 'package:flutter/material.dart';

class ASpacer extends StatelessWidget {
  ASpacer({ this.height: 16.0 });
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}