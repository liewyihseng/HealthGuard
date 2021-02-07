import 'package:HealthGuard/Bloodpressure1.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/Bloodpressurechart.dart';
import 'package:HealthGuard/user_bp_info.dart' as bp_info;
import 'package:HealthGuard/validation_tool.dart';
import 'package:HealthGuard/authentication.dart';
import 'package:HealthGuard/constants.dart' as Constants;

import 'home.dart';
import 'main.dart';

class Bloodpressure2 extends StatefulWidget {
  static const String id = "Bloodpressure";

  @override
  State createState() => _bpPageState();
}

class _bpPageState extends State<Bloodpressure2> {
  String systolic;
  String diastolic;
  String pulse;
  final sysCon = new TextEditingController();
  final diaCon = new TextEditingController();
  final pulCon = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          title: Text('Blood Pressure Diary'),
        ),
        body: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: sysCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Systolic Reading '),
                    onChanged: (String val) {
                      systolic = val;
                    },
                  ),
                  TextField(
                    controller: diaCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Diastolic Reading '),
                    onChanged: (String val) {
                      diastolic = val;
                    },
                  ),
                  TextField(
                    controller: pulCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Pulse Reading '),
                    onChanged: (String val) {
                      pulse = val;
                    },
                  ),
                  RaisedButton(
                    onPressed: _sendToServer,

                    ///() {
                    /// Navigator.push(
                    ///  context,
                    ///  new MaterialPageRoute(
                    ///    builder: (context) => Bloodpressure1(
                    ///     sys: _sys, dia: _dia, pul: _pul)));
                    ///  },
                    child: Text('Submit'),
                  ),
                  Text('$systolic, $diastolic, $pulse'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _sendToServer() async {
    showProgress(context, "Processing Submission", false);

    /// Assigning all the user's input medical information to the user_medic_info instance
    bp_info.user_bp_info user_bp_info = bp_info.user_bp_info(
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
    );

    await FireStoreUtils.firestore
        .collection(Constants.USERS)
        .doc(MyAppState.currentUser.userID)
        .collection(Constants.BP_INFO)
        .add(user_bp_info.toJson());
    hideProgress();
    pushAndRemoveUntil(context, home(user: MyAppState.currentUser), false);
  }
}
