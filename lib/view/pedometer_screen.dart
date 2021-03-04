import 'dart:async';
import 'dart:ui';

import 'package:HealthGuard/helper/shared_preferences_services.dart';
import 'package:HealthGuard/helper/time_helper.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:HealthGuard/net/PedometerService.dart';
import 'package:HealthGuard/widgets/round_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/helper/math_helper.dart';

/// pedometer screen page widget class
class PedometerScreen extends StatefulWidget {
  /// screen ID for navigator routing
  static const String id = "PedometerScreen";
  static const String documentID = "staticData";

  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

/// pedometer screen page state class
class _PedometerScreenState extends State<PedometerScreen> {
  /// variables
  int _steps = 0;
  double _calories = 0; // cal
  int _water = 0; // ml
  int _goal = 10000;
  Stream<StepCount> _stepCountStream;
  final String previousStepKey = "preStep"; // shared preferences keys
  final String previousDayNoKey = "preDayNo";
  PedometerService pedometerService = PedometerService();
  List<PedometerData> allHistory = [];

  /// step count stream error
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 0;
    });
  }

  /// additional init for pedometer
  initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) return;
  }

  /// override init
  @override
  initState() {
    super.initState();
    initPlatformState();
    _listenData();
    _getGoal();
  }

  _getGoal() async {
    PedometerData previousData = await pedometerService.receiveFromServer(PedometerScreen.documentID);
    _goal = previousData.goal;
  }

  sendPedoData() async {
    PedometerData currentData = PedometerData(
        goal: _goal,
        steps: _steps,
        water: _water,
        calories: _calories,
        date: Timestamp.now());
    await pedometerService.sendToServer(
        currentData, PedometerScreen.documentID);
  }

  /// step count event handler
  void onStepCount(StepCount event) async {
    /// variable
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
      PedometerData sentData = PedometerData(
          goal: _goal,
          water: _water,
          calories: _calories,
          steps: event.steps - preSteps,
          date: Timestamp.fromDate(TimeHelper.getYesterdayDate()));
      await pedometerService.sendToServer(sentData);
      preSteps = event.steps;
      previousDayNo = todayDayNo;
    }

    /// save all
    sharedPrefService.saveInt(previousStepKey, preSteps);
    sharedPrefService.saveInt(previousDayNoKey, previousDayNo);

    if (mounted) {
      setState(() {
        _steps = event.steps - preSteps;
        _calories = _steps.toDouble() * 0.04;
        _water = (_steps.toDouble() * 0.1282).toInt();
      });
    } else {
      _steps = event.steps - preSteps;
      _calories = _steps.toDouble() * 0.04;
      _water = (_steps.toDouble() * 0.1282).toInt();
    }

    await sendPedoData();
  }

  _listenData() {
    FirebaseFirestore.instance
        .collection(Constants.USERS)
        .doc(MyAppState.currentUser.userID)
        .collection(Constants.PEDOMETER_INFO)
        .orderBy("date", descending: true)
        .snapshots()
        .listen((snap) {
      allHistory.clear();
      setState(() {
        snap.docs.forEach((d) {
          // if (d.id != PedometerScreen.documentID) {
          allHistory.add(PedometerData.fromJson(d.data()));
          // }
        });
      });
    });
  }

  _buildHistory() {
    return ListView.builder(
      itemCount: allHistory.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(
                DateFormat("dd-MM-yyyy")
                    .format(allHistory[index].date.toDate())
                    .toString(),
                style: TextStyle(
                  fontSize: 23.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Steps : " + allHistory[index].steps.toString(),
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Goal : " + allHistory[index].goal.toString(),
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Water : " +
                              allHistory[index].water.toString() +
                              " ml",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Calories : " +
                              allHistory[index].calories.toString() +
                              " cal",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _PopUpDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text(
        'Set Goal',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constants.TEXT_DARK,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: FontWeight.w900),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                  onChanged: (String val) {
                    setState(() {
                      _goal = int.parse(val);
                    });
                  },
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Steps Number",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 40, left: 40, top: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: RaisedButton(
                color: Constants.BUTTON_COLOUR,
                child: Text('Set',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: Constants.FONTSTYLE,
                  ),
                ),
                onPressed: () async {
                  await sendPedoData();
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                splashColor: Colors.blue,
                padding: EdgeInsets.only(top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// GUI
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
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
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_walk_sharp),
                ),
                Tab(
                  icon: Icon(Icons.assignment_sharp),
                ),
              ],
            ),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Constants.APPBAR_COLOUR,
            centerTitle: true,
          ),
          body: TabBarView(children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 8,
                  ),
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
                                  Text(
                                      "${MathHelper.toPrecision(_calories, 2)} cal"),
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
            ),
            _buildHistory(),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _PopUpDialog(context),
              );
            },
            child: Icon(Icons.settings),
            backgroundColor: Colors.lightBlue,
          )),
    );
  }
}
