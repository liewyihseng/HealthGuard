import 'dart:math';

import 'package:HealthGuard/helper/convert_time.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/model/medication_type.dart';
import 'package:HealthGuard/model/medicine_model.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/view/medication_reminder_screen.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_select/smart_select.dart';

class MedicationForm extends StatefulWidget {
  static final String id = "medicationForm";

  @override
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  /// variables
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final _formKey = GlobalKey<FormState>();

  String _medName;
  String _dosage;
  bool _clicked = false;
  String _checker = "None";
  String _selectedMedicineType = '';
  int _selectedInterval = 0;
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);

  List<int> _intervals = [6, 8, 12, 24];
  List<Map<String, dynamic>> medicineType = [
    {'title': 'Pills', 'value': 'Pills'},
    {'title': 'Syringe', 'value': 'Syringe'},
  ];

  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initializeNotifications();
  }

  /// Redirecting users to the medication reminder screen if they pressed onto the notification
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.pushNamed(context, MedicationReminder.id);
  }

  /// Initializes the display of notification on both Android and iOS
  initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
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
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
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

  /// Assigning a unique id to each of the submitted medicine
  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
      return ids;
    }
  }

  /// Handles the submission of data into the database
  _sendToServer() async {
    if (_formKey.currentState.validate()) {
      showProgress(context, "Processing Submission", false);

      /// Watchout
      List<int> intIDs = makeIDs(24 / 10);
      List<String> notificationIDs = intIDs.map((i) => i.toString()).toList();
      // int interval = _selectedInterval;

      Medicine newEntryMedicine = Medicine(
        notificationIDs: notificationIDs,
        medicineName: capitalize(_medName),
        dosage: _dosage,
        interval: _selectedInterval,
        medicineType: _selectedMedicineType,
        startTime: _checker,
      );

      await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .doc(MyAppState.currentUser.userID)
          .collection(Constants.MEDICATION_INFO)
          .add(newEntryMedicine.toJson());
      scheduleNotification(newEntryMedicine);
      hideProgress();
      Navigator.pop(context);

      ///Show success submit
      // }else{
      //   print('false');
      //   setState(() {
      //     _validate = true;
      //   });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Constants.BACKGROUND_COLOUR,
        appBar: AppBar(
          title: Text(
            'Medication Form',
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
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                    child: TextFormField(
                      validator: validateMedicationName,
                      onChanged: (String val) {
                        setState(() {
                          _medName = val;
                        });
                      },
                      textCapitalization: TextCapitalization.words,
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Medication Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                    child: TextFormField(
                      validator: validateDosage,
                      onChanged: (String val) {
                        setState(() {
                          _dosage = val;
                        });
                      },
                      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Dosage in mg",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: double.infinity),
                  child: SmartSelect<String>.single(
                    title: 'Medicine Type',
                    value: _selectedMedicineType,
                    choiceItems: S2Choice.listFrom<String, Map>(
                      source: medicineType,
                      value: (index, item) => item['value'],
                      title: (index, item) => item['title'],
                    ),
                    modalTitle: 'Medicine',
                    modalType: S2ModalType.popupDialog,
                    choiceType: S2ChoiceType.chips,
                    choiceDirection: Axis.horizontal,
                    onChange: (selected) {
                      setState(() {
                        _selectedMedicineType = selected.value;
                      });
                      print(_selectedMedicineType);
                    },
                    tileBuilder: (context, state) => S2Tile.fromState(
                      state,
                      onTap: (){
                        FocusScope.of(context).unfocus();
                        state.showModal();
                      },
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<int>(
                        iconEnabledColor: Constants.BUTTON_COLOUR,
                        hint: _selectedInterval == 0
                            ? Text(
                                "Interval",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              )
                            : null,
                        elevation: 4,
                        value: _selectedInterval == 0 ? null : _selectedInterval,
                        items: _intervals.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onTap: (){
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (newVal) {
                          setState(() {
                            _selectedInterval = newVal;
                          });
                        },
                      ),
                      Text(
                        _selectedInterval == 1 ? " hour" : " hours",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: RaisedButton(
                    color: Constants.LOGO_COLOUR_PINK_LIGHT,
                    padding: EdgeInsets.fromLTRB(60, 12, 60, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Constants.LOGO_COLOUR_PINK_LIGHT,
                      ),
                    ),
                    child: Text(
                        _clicked == false
                            ? "Pick Time"
                            : "${convertTime(_time.hour.toString())} : ${convertTime(_time.minute.toString())}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: Constants.FONTSTYLE,
                        )),
                    textColor: Colors.white,
                    splashColor: Constants.LOGO_COLOUR_PINK_DARK,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final TimeOfDay picked = await showTimePicker( context: context, initialTime: _time);
                      if (picked != null && picked != _time) {
                        setState(() {
                          _time = picked;
                          _clicked = true;
                          _checker = toString(_time);
                        });
                      }
                      return picked;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
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
//
// /// To format the time into HH:MM
// String formatTimeOfDay(TimeOfDay tod) {
//   final dt = DateTime(tod.hour, tod.minute);
//   final format = DateFormat.jm();
//   return format.format(dt);
// }
//
// /// Decides which image to be displayed based on the type of the medicine
// String imageLink(String title){
//   switch(title){
//     case "Pills":
//       return "assets/capsule.png";
//     case "Syringe":
//       return "assets/syringe.png";
//     default:
//       return "null";
//   }
// }

/// Changing the time to a format where it has AM or PM
@override
String toString(TimeOfDay timeOfDay) {
  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  final String hourLabel = _addLeadingZeroIfNeeded(timeOfDay.hour);
  final String minuteLabel = _addLeadingZeroIfNeeded(timeOfDay.minute);
  String periodLabel;

  if (timeOfDay.hour <= 12 && timeOfDay.minute == 00) {
    periodLabel = "AM";
  } else {
    periodLabel = "PM";
  }

  return '$hourLabel:$minuteLabel $periodLabel';
}
