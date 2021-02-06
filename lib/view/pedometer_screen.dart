import 'dart:async';

import 'package:HealthGuard/helper/shared_preferences_services.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/widgets/round_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/helper/math_helper.dart';

// pedometer plugin doc https://pub.dev/packages/pedometer

/// pedometer screen page widget class
class PedometerScreen extends StatefulWidget {

  /// screen ID for navigator routing
  static const String id = "PedometerScreen";

  @override
  _PedometerScreenState createState() => _PedometerScreenState();

}

/// pedometer screen page state class
class _PedometerScreenState extends State<PedometerScreen> {

  /// variables
  Stream<StepCount> _stepCountStream;
  int _steps = 0;
  double _calories = 0; // cal
  int _water = 0; // ml
  int _goal = 10000;

  final db = FirebaseFirestore.instance;

  /// step count stream error
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 0;
    });
  }

  /// additional init for pedometer
  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) return;
  }

  /// override init
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /// step count event handler
  void onStepCount(StepCount event) async {

    /// shared preferences keys
    final String previousStepKey = "preStep";
    final String previousDayNoKey = "preDayNo";

    int todayDayNo = Jiffy(event.timeStamp).dayOfYear;

    SharedPrefService sharedPrefService = SharedPrefService();

    int preSteps = await sharedPrefService.read(previousStepKey) ?? 0;
    int previousDayNo =
        await sharedPrefService.read(previousDayNoKey) ?? todayDayNo;

    /// if reboot then
    if (event.steps < preSteps) {
      preSteps = 0;
      sharedPrefService.saveInt(previousStepKey, preSteps);
    }

    /// if new day
    if (previousDayNo != todayDayNo) {
      _sendToServer(event.steps - preSteps, _goal, _calories, _water);
      preSteps = event.steps;
      previousDayNo = todayDayNo;
    }

    /// save all
    sharedPrefService.saveInt(previousStepKey, preSteps);
    sharedPrefService.saveInt(previousDayNoKey, previousDayNo);

    setState(() {
      _steps = event.steps - preSteps;
      _calories = _steps.toDouble() * 0.04;
      _water = (_steps.toDouble() * 0.1282).toInt();
    });

  }

  /// send data to database
  _sendToServer(int steps, int goal, double calories, int water) async {

    /// construct updated data
    PedometerData pedometerData = PedometerData(
        goal: _goal,
        steps: _steps,
        water: _water,
        calories: _calories,
        lastUpdate: Timestamp.now()
    );

    /// store it to fire store
    await FireStoreUtils.firestore
        .collection(Constants.USERS)
        .doc(MyAppState.currentUser.userID)
        .collection(Constants.PEDOMETER_INFO)
        .add(pedometerData.toJson());
  }

  /// GUI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Pedometer',
          style: TextStyle(
              color: Colors.white,
              fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection(Constants.USERS)
              .doc(MyAppState.currentUser.userID)
              .collection(Constants.PEDOMETER_INFO)
              .snapshots(),
          builder: (context, snapshot) {
            var doc;
            if (snapshot.hasData) {
              doc = snapshot.data.docs;
              // TODO - continue this part
              /// load data based on day number
              /// calculate new data
              /// store updated data during the same day to the same document in fire store
              /// else the next day store updated data as a new document to fire store
              /// (additional : replace previous year record based on 365 days)
            }
            return Container(
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
                                  Text("${MathHelper.toPrecision(_calories, 2)} cal"),
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
                      value: ((_steps ?? 0) < _goal)
                          ? _steps?.toDouble()
                          : _goal.toDouble(),
                      max: _goal.toDouble(),
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
                            Text("$_steps / $_goal steps"),
                            Text(
                                "${MathHelper.toPrecision(value / _goal.toDouble() * 100, 2)} %"),
                          ],
                        );
                      }),
                ],
              ),
            );
          }),
    );
  }
}
