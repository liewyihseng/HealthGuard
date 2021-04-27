import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/model/bloodpressure_model.dart';
import 'package:HealthGuard/widgets/bloodpressure_card.dart';
import 'package:HealthGuard/widgets/bloodpressure_card_small.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:HealthGuard/main.dart';


class BloodPressureHistory extends StatefulWidget {
  /// Screen ID for navigator routing
  static const String id = "BloodPressureHistoryPage";
  @override
  _BloodPressureHistoryState createState() => _BloodPressureHistoryState();
}

class _BloodPressureHistoryState extends State<BloodPressureHistory> {
  String diastolic, systolic, pulse;
  bool _validate = false;
  DateTime submittedDate;
  GlobalKey<FormState> _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Blood Pressure Diary',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: BpGraph(),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              "BLOOD PRESSURE LOGS",
              style: TextStyle(
                color: Constants.TEXT_LIGHT,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: Constants.FONTSTYLE,
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: MainContainer(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.BUTTON_COLOUR,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        splashColor: Constants.BUTTON_SPLASH_COLOUR,
        shape: CircleBorder(
          side: BorderSide(color: Constants.BUTTON_COLOUR),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        },
      ),
    );
  }

  /// Handles the pop up once the user pressed onto the add button on the bottom right corner
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      title: Text(
        'Add Blood Pressure Log',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constants.TEXT_DARK,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: FontWeight.w900),
      ),
      content: Form(
        key: _key,
        autovalidate: _validate,
        child: Container(
          height: 350,
          width: 250,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 25),
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                    validator: validateSystolic,
                    onChanged: (String val) {
                      setState(() {
                        systolic = val;
                      });
                    },
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Systolic",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                    validator: validateDiastolic,
                    onChanged: (String val) {
                      setState(() {
                        diastolic = val;
                      });
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Diastolic",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                    validator: validatePulse,
                    onChanged: (String val) {
                      setState(() {
                        pulse = val;
                      });
                    },
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Pulse",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: RaisedButton(
                    color: Constants.BUTTON_COLOUR,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontFamily: Constants.FONTSTYLE,
                      ),
                    ),
                    textColor: Colors.white,
                    splashColor: Constants.BUTTON_SPLASH_COLOUR,
                    onPressed: _sendToServer,
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Constants.BUTTON_COLOUR),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The function that handles the process of submitting data to the database when the button to submit has been pressed
  _sendToServer() async {
    if (_key.currentState.validate()) {
      showProgress(context, "Processing Submission", false);

      BloodPressure newEntryBloodPressure = BloodPressure(
        systolic: systolic,
        diastolic: diastolic,
        pulse: pulse,
        submittedDate: DateTime.now().toString(),
      );

      await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .doc(MyAppState.currentUser.userID)
          .collection(Constants.BLOODPRESSURE_INFO)
          .add(newEntryBloodPressure.toJson());
      hideProgress();
      Navigator.pop(context);
    }
  }
}

/// Class instance to handle the data inside the chart
class SalesData {
  final int year;
  final int sales;

  SalesData(
    this.year,
    this.sales,
  );
}

/// Handles the presentation of the upper container
class BpGraph extends StatelessWidget {
  final db = FirebaseFirestore.instance;

  final data = [
    /// Must contain something in a list so it is set to a random value then will be deleted
    new SalesData(19, 5),
  ];

  List<SalesData> addData(AsyncSnapshot<QuerySnapshot> snapshot, String value) {
    /// Clears the list as a list cannot be empty upon creation
    data.clear();
    for (var i = 0; i < snapshot.data.documents.length; i++) {
      /// Looping through every element within the database, then add into the list
      data.add(
          new SalesData(i, int.parse(snapshot.data.documents[i].get(value))));
    }
    return data;
  }

  /// Handles the creation of the chart
  _getSeriesData(AsyncSnapshot<QuerySnapshot> snapshot) {
    addData(
      snapshot,
      "pulse",
    );

    List<charts.Series<SalesData, int>> series = [
      charts.Series(
        id: "Sales",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SalesData series, _) => series.year,
        measureFn: (SalesData series, _) => series.sales,
        data: data,
      ),
    ];
    return series;
  }

  // systolic ===============

  final data2 = [
    /// Must contain something in a list so it is set to a random value then will be deleted
    new SalesData(19, 5),
  ];

  List<SalesData> addData2(
      AsyncSnapshot<QuerySnapshot> snapshot, String value) {
    /// Clears the list as a list cannot be empty upon creation
    data2.clear();
    for (var i = 0; i < snapshot.data.documents.length; i++) {
      /// Looping through every element within the database, then add into the list
      data2.add(
          new SalesData(i, int.parse(snapshot.data.documents[i].get(value))));
    }
    return data2;
  }

  /// Handles the creation of the chart
  _getSeriesData2(AsyncSnapshot<QuerySnapshot> snapshot) {
    addData2(
      snapshot,
      "systolic",
    );

    List<charts.Series<SalesData, int>> series = [
      charts.Series(
        id: "Sales",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SalesData series, _) => series.year,
        measureFn: (SalesData series, _) => series.sales,
        data: data2,
      ),
    ];
    return series;
  }

  // diastolic ===============

  final data3 = [
    /// Must contain something in a list so it is set to a random value then will be deleted
    new SalesData(19, 5),
  ];

  List<SalesData> addData3(
      AsyncSnapshot<QuerySnapshot> snapshot, String value) {
    /// Clears the list as a list cannot be empty upon creation
    data3.clear();
    for (var i = 0; i < snapshot.data.documents.length; i++) {
      /// Looping through every element within the database, then add into the list
      data3.add(
          new SalesData(i, int.parse(snapshot.data.documents[i].get(value))));
    }
    return data3;
  }

  /// Handles the creation of the chart
  _getSeriesData3(AsyncSnapshot<QuerySnapshot> snapshot) {
    addData3(
      snapshot,
      "diastolic",
    );

    List<charts.Series<SalesData, int>> series = [
      charts.Series(
        id: "Sales",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SalesData series, _) => series.year,
        measureFn: (SalesData series, _) => series.sales,
        data: data3,
      ),
    ];
    return series;
  }

  /// Handles the calculation of average figures of systolic, diastolic and pulse
  String avgCalculator(
      AsyncSnapshot<QuerySnapshot> snapshot, String fieldName) {
    int sum = 0;
    for (var i = 0; i < snapshot.data.documents.length; i++) {
      sum += int.parse(snapshot.data.documents[i].get(fieldName));
    }
    return (sum / snapshot.data.documents.length).toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection(Constants.USERS)
              .doc(MyAppState.currentUser.userID)
              .collection(Constants.BLOODPRESSURE_INFO)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data.size == 0) {
              return Center(
                child: Text(
                  'No stats to be shown',
                  style: TextStyle(
                    fontSize: 24,
                    color: Constants.TEXT_SUPER_LIGHT,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return Material(
                shadowColor: Colors.grey.withOpacity(0.01),
                type: MaterialType.card,
                elevation: 10,
                borderRadius: new BorderRadius.circular(10.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                  height: 800.0,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "SUMMARY",
                          style: TextStyle(
                            color: Constants.TEXT_LIGHT,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: Constants.FONTSTYLE,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          BloodPressureCardSmall(
                              status: "Avg Heartbeat",
                              value: avgCalculator(snapshot, "pulse"),
                              unit: "bpm",
                              remarks: "ok"),
                          SizedBox(width: 10),
                          BloodPressureCardSmall(
                              status: "Avg BP",
                              value: avgCalculator(snapshot, "systolic") +
                                  "/" +
                                  avgCalculator(snapshot, "diastolic"),
                              unit: "mmHg",
                              remarks: "ok"),
                        ],
                      ),
                      // Center(
                      //   child: Center(
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: SizedBox(
                      //         height: 10,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        height: 400,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "Pulse",
                                style: TextStyle(
                                  color: Constants.TEXT_LIGHT,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  shape: BoxShape.rectangle,
                                  color: Color(0xFFA1ECBF),
                                ),
                                child: charts.LineChart(
                                  _getSeriesData(snapshot),
                                  animate: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "Systolic",
                                style: TextStyle(
                                  color: Constants.TEXT_LIGHT,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  shape: BoxShape.rectangle,
                                  color: Color(0xFFA1ECBF),
                                ),
                                child: charts.LineChart(
                                  _getSeriesData2(snapshot),
                                  animate: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "Diastolic",
                                style: TextStyle(
                                  color: Constants.TEXT_LIGHT,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  shape: BoxShape.rectangle,
                                  color: Color(0xFFA1ECBF),
                                ),
                                child: charts.LineChart(
                                  _getSeriesData3(snapshot),
                                  animate: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

/// Presents the lower container containing tha blood pressure logs
class MainContainer extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      body: Container(
        alignment: Alignment.topCenter,
        child: StreamBuilder<QuerySnapshot>(

            /// Retrieving of all medicine from the database using snapshots
            stream: db
                .collection(Constants.USERS)
                .doc(MyAppState.currentUser.userID)
                .collection(Constants.BLOODPRESSURE_INFO)
                .orderBy('submittedDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else if (snapshot.data.size == 0) {
                return Container(
                  color: Color(0xFFF6F8FC),
                  child: Center(
                    child: Text(
                      'Nothing to be shown',
                      style: TextStyle(
                        fontSize: 24,
                        color: Constants.TEXT_SUPER_LIGHT,
                        fontFamily: Constants.FONTSTYLE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                var doc = snapshot.data.documents;
                return Padding(
                  padding: const EdgeInsets.only(left: 0, top: 5, right: 0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: doc.length,
                      itemBuilder: (context, index) {
                        return BloodPressureCard(
                          BPvalue: doc[index].get("systolic") +
                              '/' +
                              doc[index].get("diastolic"),
                          HRvalue: doc[index].get("pulse"),
                          submittedDate: doc[index].get("submittedDate"),
                        );
                      }),
                );
              }
            }),
      ),
    );
  }
}
