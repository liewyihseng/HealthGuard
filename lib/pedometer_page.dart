
import 'package:flutter/material.dart';

class Pedometer extends StatefulWidget {
  @override
  _PedometerState createState() => _PedometerState();
}

class _PedometerState extends State<Pedometer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Text("pedometer right here"),
      ),
    );
  }
}
