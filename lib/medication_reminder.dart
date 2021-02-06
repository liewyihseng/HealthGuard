import 'dart:ui';
import 'dart:math';
import 'dart:core';

import 'package:HealthGuard/home.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/widgets/medication_reminder_card_large.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/model/medicine_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:HealthGuard/authentication.dart';
import 'package:HealthGuard/helper/convert_time.dart';
import 'package:HealthGuard/model/medication_type.dart';

class MedicationReminder extends StatefulWidget{
  /// Screen ID for navigator routing
  static const String id = "MedicationReminderPage";
  @override
  _MedicationReminderState createState() => _MedicationReminderState();
}

class _MedicationReminderState extends State<MedicationReminder>{

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String medName;
  String dosage;
  String startTime;
  bool _clicked = false;
  var _intervals = [
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  String _checker = "None";
  String _medicineType = '';
  List<Map<String, dynamic>> medicineType = [
    {'title': 'Pills', 'value': 'Pills'},
    {'title': 'Syringe', 'value': 'Syringe'},
  ];


  void dispose(){
    super.dispose();
  }

  void initState(){
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {Navigator.pushNamed(context, home.id);},
            );
          },
        ),
        title: Text(
          'Medication Reminder',
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
        color: Constants.BACKGROUND_COLOUR,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: TopContainer(),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.BUTTON_COLOUR,
        child: Icon(
          Icons.add,
        ),
        splashColor: Colors.blue,
        //padding: EdgeInsets.only(top: 12, bottom: 12),
        shape: CircleBorder(
          side: BorderSide(color: Colors.blue),
        ),
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        },
      ),
    );
  }


  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      title:  Text(
        'Add Medication',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constants.TEXT_DARK,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w900),
      ),
      content:
      Container(
        height: 430,
        width: 290,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 25),
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                  onChanged: (String val) {
                    setState(() {
                      medName = val;
                    });
                  },
                  textCapitalization: TextCapitalization.words,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Medication Name",
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
                padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                child: TextFormField(
                  onChanged: (String val) {
                    setState(() {
                      dosage = val;
                    });
                  },
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Dosage in mg",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child:
              SmartSelect<String>.single(
                title: 'Medicine Type',
                value: _medicineType,
                choiceItems: S2Choice.listFrom<String, Map>
                  (source: medicineType,
                  value: (index, item) => item['value'],
                  title: (index, item) => item['title'],
                ),
                modalTitle: 'Medicine',
                modalType: S2ModalType.popupDialog,
                choiceType: S2ChoiceType.chips,
                choiceGrouped: true,
                choiceDirection: Axis.horizontal,
                onChange: (selected) => setState(() => _medicineType = selected.value),
                tileBuilder: (context, state) => S2Tile.fromState(
                  state,
                  onTap: state.showModal,
                ),
              ),
            ),

            SizedBox(height: 5),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DropdownButton<int>(
                    iconEnabledColor: Constants.BUTTON_COLOUR,
                    hint: _selected == 0 ? Text("Interval",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                    ): null,
                    elevation: 4,
                    value: _selected == 0 ? null: _selected,
                    items: _intervals.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newVal){
                      setState((){
                        _selected = newVal;
                      });
                    },
                  ),
                  Text(
                    _selected == 1 ? " hour" : " hours",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5),

            Container(
              child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 4.0),
                  child: RaisedButton(
                    color: Constants.LOGO_COLOUR_PINK_LIGHT,
                    child: Text(_clicked == false ? "Pick Time": "${convertTime(_time.hour.toString())} : ${convertTime(_time.minute.toString())}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            fontFamily: "Montserrat")
                    ),
                    textColor: Colors.white,
                    splashColor: Constants.LOGO_COLOUR_PINK_DARK,
                    onPressed: () async{
                      final TimeOfDay picked = await showTimePicker(
                        context: context,
                        initialTime: _time,
                      );
                      if(picked != null && picked != _time){
                        setState((){
                          _time = picked;
                          _clicked = true;
                          _checker = toString(_time);
                        });
                      }
                      return picked;
                    },
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Constants.LOGO_COLOUR_PINK_LIGHT,
                      ),
                    ),
                  )
              ),
            ),

            SizedBox(height: 7),

            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  color: Constants.BUTTON_COLOUR,
                  child: Text('Submit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: _sendToServer,
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
      ),
    );
  }

  initializeNotifications() async{
    var initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async{
    if(payload != null){
      debugPrint('notification payload: '+ payload);
    }
    await Navigator.pushNamed(context, MedicationReminder.id);
  }

  _sendToServer() async{
    showProgress(context, "Processing Submission", false);

    /// Watchout
    List<int> intIDs = makeIDs(24 / 10);
    List<String> notificationIDs = intIDs.map((i) => i.toString()).toList();
    int interval = _selected;

    Medicine newEntryMedicine = Medicine(
      notificationIDs: notificationIDs,
      medicineName: capitalize(medName),
      dosage: dosage,
      interval: interval,
      medicineType: _medicineType,
      startTime: _checker,
    );

    await FireStoreUtils.firestore
        .collection(Constants.USERS)
        .doc(MyAppState.currentUser.userID)
        .collection(Constants.MEDICATION_INFO)
        .add(newEntryMedicine.toJson());
    scheduleNotification(newEntryMedicine);
    hideProgress();
    Navigator.pushNamed(context, MedicationReminder.id);
    ///Show success submit
  }

  List<int> makeIDs(double n){
    var rng = Random();
    List<int> ids = [];
    for(int i = 0; i < n; i++){
      ids.add(rng.nextInt(1000000000));
      return ids;
    }
  }

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      importance: Importance.max,
      //sound: 'sound',
      ledColor: Color(0xFF3EB16F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics
    );

    for( int i = 0; i< (24 / medicine.interval).floor(); i++){
      if((hour + (medicine.interval * i) > 23)){
        hour = hour + (medicine.interval * i) - 24;
      }else{
        hour = hour + (medicine.interval * i);
      }
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          int.parse(medicine.notificationIDs[i]),
          'HealthGuard: ${medicine.medicineName}',
          medicine.medicineType.toString() != MedicineType.None.toString()
              ? 'It is time to take your ${medicine.medicineType.toLowerCase()}, according to schedule'
              : 'It is time to take your medicine, according to schedule',
          Time(hour, minute, 0),
          platformChannelSpecifics);
      hour = ogValue;
    }
  }
}


class TopContainer extends StatelessWidget{
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: StreamBuilder<QuerySnapshot>(
            stream: db.collection(Constants.USERS).doc(MyAppState.currentUser.userID).collection(Constants.MEDICATION_INFO).snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Container();
              }else if(snapshot.data.size == 0){
                return Container( color: Color(0xFFF6F8FC),
                  child: Center(
                    child:  Text(
                      'Nothing to be shown',
                      style: TextStyle(
                          fontSize: 24,
                          color: Constants.TEXT_SUPER_LIGHT,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }else{
                var doc = snapshot.data.documents;
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: doc.length,
                    itemBuilder: (context, index){
                      return Container(
                        height: 135,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            MedicationReminderCardLarge(
                              title: doc[index].get("medicineName"),
                              value: doc[index].get("dosage"),
                              unit: "mg",
                              time: doc[index].get("startTime"),
                              image: AssetImage(imageLink(doc[index].get("medicineType"))),
                              isDone: false,
                            ),
                          ],
                        ),
                      );
                    }
                );
              }
            }
        ),
      ),
    );
  }
}

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

String formatTimeOfDay(TimeOfDay tod) {
  final dt = DateTime(tod.hour, tod.minute);
  final format = DateFormat.jm();
  return format.format(dt);
}

String imageLink(String title){
  switch(title){
    case "Pills":
      return "assets/capsule.png";
    case "Syringe":
      return "assets/syringe.png";
    default:
      return "null";
  }
}

@override
String toString(TimeOfDay timeOfDay) {
  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10)
      return '0$value';
    return value.toString();
  }

  final String hourLabel = _addLeadingZeroIfNeeded(timeOfDay.hour);
  final String minuteLabel = _addLeadingZeroIfNeeded(timeOfDay.minute);
  String periodLabel;

  if (timeOfDay.hour <= 12 && timeOfDay.minute == 00){
    periodLabel = "AM";
  }else{
    periodLabel = "PM";
  }

  return '$hourLabel:$minuteLabel $periodLabel';
}
