import 'dart:async';
import 'dart:html';

import 'package:HealthGuard/helper/shared_preferences_services.dart';
import 'package:HealthGuard/helper/time_helper.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:HealthGuard/view/pedometer_history_screen.dart';
import 'package:HealthGuard/widgets/round_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/helper/math_helper.dart';

/// pedometer screen page widget class
class PedometerScreen extends StatefulWidget {

  /// screen ID for navigator routing
  static const String id = "PedometerScreen";
  static int steps = 0;
  static double calories = 0; // cal
  static int water = 0; // ml
  static int goal = 10000;

  @override
  _PedometerScreenState createState() => _PedometerScreenState();

}

/// pedometer screen page state class
class _PedometerScreenState extends State<PedometerScreen> {

  /// variables
  Stream<StepCount> _stepCountStream;
  // int steps = 0;
  // double calories = 0; // cal
  // int water = 0; // ml
  // int goal = 10000;

  var db = FirebaseFirestore.instance;

  /// shared preferences keys
  final String previousStepKey = "preStep";
  final String previousDayNoKey = "preDayNo";

  /// step count stream error
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      PedometerScreen.steps = 0;
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

    int todayDayNo = Jiffy(event.timeStamp).dayOfYear;

    SharedPrefService sharedPrefService = SharedPrefService();

    int preSteps = await sharedPrefService.read(previousStepKey) ?? 0;
    int previousDayNo = await sharedPrefService.read(previousDayNoKey) ?? todayDayNo;

    /// if reboot then
    if (event.steps < preSteps) {
      preSteps = 0;
      sharedPrefService.saveInt(previousStepKey, preSteps);
    }

    /// if new day
    if (previousDayNo != todayDayNo) {
      _sendToServer(event.steps - preSteps, PedometerScreen.goal, PedometerScreen.calories, PedometerScreen.water); // to lower database traffic (downside : not real time)
      preSteps = event.steps;
      previousDayNo = todayDayNo;
    }

    /// save all
    sharedPrefService.saveInt(previousStepKey, preSteps);
    sharedPrefService.saveInt(previousDayNoKey, previousDayNo);

    setState(() {
      PedometerScreen.steps = event.steps - preSteps;
      PedometerScreen.calories = PedometerScreen.steps.toDouble() * 0.04;
      PedometerScreen.water = (PedometerScreen.steps.toDouble() * 0.1282).toInt();
    });
    // _sendToServer(_steps, _goal, _calories, _water); // high traffic

  }

  /// send data to database
  _sendToServer(int steps, int goal, double calories, int water) async {

    /// variable
    // PedometerData oldPedometerData;
    // String oldDataId;

    /// database reference
    var pedometerRef = db
        .collection(Constants.USERS)
        .doc(MyAppState.currentUser.userID)
        .collection(Constants.PEDOMETER_INFO);

    /// construct updated data
    PedometerData pedometerData = PedometerData(
        goal: goal,
        steps: steps,
        water: water,
        calories: calories,
        date: Timestamp.fromDate(TimeHelper.getYesterdayDate())
    );

    await pedometerRef.add(pedometerData.toJson());

    // await pedometerRef
    //     .orderBy("date",descending: true)
    //     .limit(1)
        // timestamp query not working
        // .where("lastUpdate", isGreaterThanOrEqualTo: Timestamp.fromDate(TimeHelper.getLastMidnightDate()))
        // .where("lastUpdate", isLessThan: Timestamp.fromDate(TimeHelper.getNextMidnightDate()))
    //     .get()
    //     .then((value){
    //       if(value.docs.isNotEmpty){
    //
    //         /// get data
    //         oldDataId = value.docs.single.id;
    //         oldPedometerData = PedometerData.fromJson(value.docs.single.data());
    //
    //         /// display incoming data
    //         print("Existing pedometer document found, id : $oldDataId");
    //         print(oldPedometerData.toJson());
    //
    //         DateTime oldDate = oldPedometerData.date.toDate();
    //         Duration dateDiff = newTimestamp.toDate().difference(oldDate);
    //
    //         print("old date");
    //         print(oldDate);
    //         print("new date");
    //         print(newTimestamp.toDate());
    //         print("diff date");
    //         print(dateDiff);
    //
    //         if(dateDiff.inDays >= 1){
    //           oldDataId = null;
    //           print("old data id set to null : $oldDataId");
    //         }
    //
    //       } else {
    //         print("No existing pedometer document found");
    //       }
    //       print("new data : ${pedometerData.toJson()}");
    // }).catchError((e)=> print("error fetching old pedometer data : $e"));

    // await pedometerRef
    //     .orderBy("lastUpdate", descending: true)
    //     .get()
    //     .then((value){
    //       if(value.docs.isNotEmpty){
    //         oldDataId = value.docs.first.id;
    //         print("${oldDataId} is the id of documents");
    //         oldPedometerData = PedometerData.fromJson(value.docs.first.data());
    //         print(oldPedometerData.toJson());
    //       }
    // });
    
    // if (oldDataId != null){
    //   await pedometerRef.doc(oldDataId).update(pedometerData.toJson());
    // } else {
    //   await pedometerRef.add(pedometerData.toJson());
    // }

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
                            value: (PedometerScreen.calories < 2000) ? PedometerScreen.calories : 2000,
                            max: 2000,
                            size: 100,
                            color: Colors.orangeAccent,
                            innerWidget: (value) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_fire_department),
                                  Text("${MathHelper.toPrecision(PedometerScreen.calories, 2)} cal"),
                                ],
                              );
                            }),
                        RoundProgressBar(
                            value: (PedometerScreen.water < 3000) ? PedometerScreen.water.toDouble() : 3000,
                            max: 3000,
                            size: 100,
                            color: Colors.blue[300],
                            innerWidget: (value) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.opacity),
                                  Text(PedometerScreen.water.toString() + " ml"),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                  RoundProgressBar(
                      value: ((PedometerScreen.steps ?? 0) < PedometerScreen.goal)
                          ? PedometerScreen.steps?.toDouble()
                          : PedometerScreen.goal.toDouble(),
                      max: PedometerScreen.goal.toDouble(),
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
                            Text("${PedometerScreen.steps} / ${PedometerScreen.goal} steps"),
                            Text(
                                "${MathHelper.toPrecision(value / PedometerScreen.goal.toDouble() * 100, 2)} %"),
                          ],
                        );
                      }),
                  GestureDetector(
                    child: Card(
                      child: Text(
                        "History"
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, PedometerHistoryScreen.id);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
