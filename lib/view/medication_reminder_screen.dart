import 'dart:ui';
import 'dart:math';
import 'dart:core';

import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/view/add_medication_screen.dart';
import 'package:HealthGuard/widgets/medication_reminder_card_large.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/model/medicine_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  List<Map<String, dynamic>> medicineType = [
    {'title': 'Pills', 'value': 'Pills'},
    {'title': 'Syringe', 'value': 'Syringe'},
  ];
  GlobalKey<FormState> _key = new GlobalKey();


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
          color: Colors.white,
        ),
        splashColor: Constants.BUTTON_SPLASH_COLOUR,
        //padding: EdgeInsets.only(top: 12, bottom: 12),
        shape: CircleBorder(
          side: BorderSide(color: Constants.BUTTON_COLOUR),
        ),
        onPressed: (){
          Navigator.pushNamed(context, MedicationForm.id);
        },
      ),
    );
  }



  /// Initializes the display of notification on both Android and iOS
  initializeNotifications() async{
    var initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  /// Redirecting users to the medication reminder screen if they pressed onto the notification
  Future onSelectNotification(String payload) async{
    if(payload != null){
      debugPrint('notification payload: '+ payload);
    }
    await Navigator.pushNamed(context, MedicationReminder.id);
  }

  /// Assigning a unique id to each of the submitted medicine
  List<int> makeIDs(double n){
    var rng = Random();
    List<int> ids = [];
    for(int i = 0; i < n; i++){
      ids.add(rng.nextInt(1000000000));
      return ids;
    }
  }

  /// Handles the scheduling of notifications
  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[3] + medicine.startTime[4]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      importance: Importance.max,
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

      /// Handles the output of content in the notification
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
          /// Retrieving of all medicine from the database using snapshots
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
                        fontFamily: Constants.FONTSTYLE,
                        fontWeight: FontWeight.bold,
                      ),
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
                            /// Passing of medicine being retrieved from the database into medication reminder card large to be displayed on the medication reminder page
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

/// Capitalizes any Strings
String capitalize(String string) {
  if (string == null) {
    throw ArgumentError.notNull('string');
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

/// To format the time into HH:MM
String formatTimeOfDay(TimeOfDay tod) {
  final dt = DateTime(tod.hour, tod.minute);
  final format = DateFormat.jm();
  return format.format(dt);
}

/// Decides which image to be displayed based on the type of the medicine
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

/// Changing the time to a format where it has AM or PM
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
