import 'dart:async';
import 'dart:math';

import 'package:HealthGuard/utils/services/shared_pref_service.dart';
import 'package:HealthGuard/widgets/round_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';

// pedometer plugin doc https://pub.dev/packages/pedometer
// shared preference doc https://pub.dev/packages/shared_preferences

/// pedometer screen page widget class
class PedometerPage extends StatefulWidget {
  /// screen ID for navigator routing
  static const String id = "PedometerPage";

  @override
  _PedometerPageState createState() => _PedometerPageState();
}

/// pedometer screen page state class
class _PedometerPageState extends State<PedometerPage> {
  /// step count stream
  Stream<StepCount> _stepCountStream;

  /// steps
  int _steps = 0;

  /// calories (cal)
  double _calories = 0;

  /// water (ml)
  int _water = 0;

  /// goal (steps)
  int goal = 10000;

  /// override init
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /// additional init for pedometer
  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  /// step count event handler
  void onStepCount(StepCount event) async {
    final String previousStepKey = "previousStep";
    final String previousDayNoKey = "previousDayNo";

    int todayDayNo = Jiffy(event.timeStamp).dayOfYear;
    int preSteps = await SharedPrefService.read(previousStepKey) ?? 0;
    int previousDayNo =
        await SharedPrefService.read(previousDayNoKey) ?? todayDayNo;

    // if reboot then
    if (event.steps < preSteps) {
      preSteps = 0;
      SharedPrefService.saveInt(previousStepKey, preSteps);
    }

    // if new day
    if (previousDayNo < todayDayNo) {
      preSteps = event.steps;
      previousDayNo = todayDayNo;
    }

    // save all
    SharedPrefService.saveInt(previousStepKey, preSteps);
    SharedPrefService.saveInt(previousDayNoKey, previousDayNo);

    setState(() {
      // _steps = event.steps - preSteps;
      _steps = event.steps;
      _calories = _steps.toDouble() * 0.04;
      _water = (_steps.toDouble() * 0.1282).toInt();
    });
  }

  /// step count stream error
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 0;
    });
  }

  double toPrecision(double value, int place) {
    return ((value * pow(10, place)).round()) / pow(10, place);
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pedometer"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(_steps?.toString() ?? '0'),
            Card(
              elevation: 2,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundProgressBar(
                      value: (_calories < 2000) ? _calories : 2000,
                      max: 2000,
                      size: 100,
                      color: Colors.orangeAccent,
                      innerWidget: (value) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_fire_department),
                            Text("${toPrecision(_calories, 2)} cal"),
                          ],
                        );
                      }),
                  RoundProgressBar(
                      value: (_water < 3000) ? _water.toDouble() : 3000,
                      max: 3000,
                      size: 100,
                      color: Colors.blue[300],
                      innerWidget: (value) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.opacity),
                            Text(_water.toString() + " ml"),
                          ],
                        );
                      }),
                ],
              ),
            ),
            RoundProgressBar(
                value: ((_steps ?? 0) < goal)
                    ? _steps?.toDouble()
                    : goal.toDouble(),
                max: goal.toDouble(),
                size: 300,
                color: Colors.lightGreenAccent,
                innerWidget: (double value) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_run,
                        size: 80,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("$_steps / $goal steps"),
                      Text(
                          "${toPrecision(value / goal.toDouble() * 100, 2)} %"),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}