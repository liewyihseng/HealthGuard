import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

// TODO - Permissions for iOS in xcode (not sure)

// plugin doc from pedometer
// https://github.com/feelfreelinux/flutter-plugins/tree/master/packages/pedometer

/// pedometer screen page widget class
class PedometerPage extends StatefulWidget {
  /// screen ID for navigator routing
  static const String id = "PedometerPage";
  @override
  _PedometerPageState createState() => _PedometerPageState();
}

/// pedometer screen page state class
class _PedometerPageState extends State<PedometerPage> {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  int _stepCountValue;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  void startListening() {
    print("startlistening1");
    _pedometer = Pedometer();
    _subscription = _pedometer.pedometerStream.listen(
      getTodaySteps,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: false,
    );
    print("startlistening2");
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  Future<int> getTodaySteps(int value) async {
    print(value);
    setState(() {
      print("setstate");
      _stepCountValue = value;
    });
    return _stepCountValue; // this is your daily steps value.
  }

  void stopListening() {
    _subscription.cancel();
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pedometer"),
      ),
      body: Center(child: Text(_stepCountValue?.toString() ?? '0')),
    );
  }
}
