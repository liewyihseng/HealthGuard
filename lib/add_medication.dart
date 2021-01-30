import 'dart:math';
import 'dart:ui';

import 'package:HealthGuard/model/medication_type.dart';
import 'package:HealthGuard/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:HealthGuard/model/medication_error.dart';
import 'package:HealthGuard/medication_reminder_bloc.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/model/medicine_model.dart';
import 'package:HealthGuard/helper/convert_time.dart';
import 'package:HealthGuard/medication_reminder.dart';

/// Medication Reminder screen page widget class
class AddMedicationReminder extends StatefulWidget{
  static const String id = "AddMedicationReminderPage";
  @override
  _AddMedicationReminderState createState() => _AddMedicationReminderState();
}

/// Medication Reminder screen page state class
class _AddMedicationReminderState extends State<AddMedicationReminder>{
  TextEditingController nameController;
  TextEditingController dosageController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  MedicationReminderBloc _medicationReminderBloc;
  GlobalKey<ScaffoldState> _scaffoldKey;
  
  /// Select interval var
  var _intervals =[
    6,
    8,
    12,
    26,
  ];
  var _selected = 0;


  /// Select time var
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;
  String _checker = "None";


  void dispose(){
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _medicationReminderBloc.dispose();
  }

  void initState(){
    super.initState();
    _medicationReminderBloc = MedicationReminderBloc();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    initializeErrorListen();
  }


  /// Method to decide which error to be displayed in the method displayError
  void initializeErrorListen(){
    _medicationReminderBloc.errorState$.listen(
            (EntryError error){
          switch (error){
            case EntryError.NameNull:
              displayError("Please enter the medicine's name");
              break;
            case EntryError.NameDuplicate:
              displayError("Medicine name already exists");
              break;
            case EntryError.Dosage:
              displayError("Please enter the dosage required");
              break;
            case EntryError.Interval:
              displayError("Please select the reminder's interval");
              break;
            case EntryError.StartTime:
              displayError("Please select the reminder's starting time");
              break;
            default:
          }
        }
    );
  }

  /// Method to display error message when the input given is invalid
  void displayError(String error){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  initializeNotifications() async{
    var initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
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

  ///Take Note Here
  ///
  ///
  ///
  ///
  /// This method is responsible for the action which is going to be happenning when the user click on the notification
  Future onSelectNotification(String payload) async{
    if(payload != null){
      debugPrint('notification payload: '+ payload);
    }
    await Navigator.pushNamed(context, MedicationReminder.id);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Add Medication',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 25,),
            children: <Widget>[
              PanelTitle(
                title: "Medicine Name",
                isRequired: true,
              ),
              TextFormField(
                style: TextStyle(
                    color: Constants.TEXT_LIGHT,
                    fontFamily: "Montserrat",
                    fontSize: 16,
                ),
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),

              PanelTitle(
                title: "Dosage in mg",
                isRequired: false,
              ),
              TextFormField(
                controller: dosageController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Constants.TEXT_LIGHT,
                  fontFamily: "Montserrat",
                  fontSize: 16,
                ),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              PanelTitle(
                title: "Medicine Type",
                isRequired: false,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MedicineTypeColumn(
                      medicineType: MedicineType.Pill,
                      medicineName: "Pill",
                      iconName: "Pill",
                    ),
                    MedicineTypeColumn(
                      medicineType: MedicineType.Syringe,
                      medicineName: "Syringe",
                      iconName: "Syringe",
                    ),
                  ],
                ),
              ),

              PanelTitle(
                title: "Interval Selection",
                isRequired: true,
              ),

              Padding(
                padding: EdgeInsets.only(top :8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Remind me every ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<int>(
                        iconEnabledColor: Color(0xFF3EB16F),
                        hint: _selected == 0
                            ? Text(
                          "Select an Interval",
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.w400
                          ),
                        ): null,
                        elevation: 4,
                        value: _selected == 0 ? null : _selected,
                        items: _intervals.map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newVal){
                          setState(() {
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
              ),

              PanelTitle(
                title: "Starting Time",
                isRequired: true,
              ),

              Container(
                height: 60,
                child: Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 4.0),
                    child: RaisedButton(
                      color: Constants.BUTTON_COLOUR,
                      child: Text(_clicked == false ? "Pick Time" : "${convertTime(_time.hour.toString())} : ${convertTime(_time.minute.toString())}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              fontFamily: "Montserrat")),
                      textColor: Colors.white,
                      splashColor: Colors.blue,
                      onPressed: () async {
                        final TimeOfDay picked = await showTimePicker(
                          context: context,
                          initialTime: _time,
                        );
                        if(picked != null && picked != _time){
                          setState((){
                            _time = picked;
                            _clicked = true;
                            _checker = _time.toString();
                          });
                        }
                        return picked;
                      },
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.blue),
                      ),
                    )
                ),
              ),

              SizedBox(
                height: 35,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.08,
                  right: MediaQuery.of(context).size.height * 0.08,
                ),
                child: RaisedButton(
                  color: Constants.BUTTON_COLOUR,
                  child: Text('Confirm',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: "Montserrat"
                      ),
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  padding: EdgeInsets.only(top:12, bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                  onPressed: (){
                    String medicineName;
                    int dosage;
                    if(nameController.text != ""){
                      medicineName = nameController.text;
                    }
                    if(dosageController.text == ""){
                      dosage = 0;
                    }
                    if(dosageController.text != ""){
                      dosage = int.parse(dosageController.text);
                    }

                    if(_selected == 0){
                      _medicationReminderBloc.submitError(EntryError.Interval);
                      return;
                    }
                    if(_checker == "None"){
                      _medicationReminderBloc.submitError(EntryError.StartTime);
                      return;
                    }

                    String medicineType = "Pills";
                    int interval = _selected;
                    String startTime = _checker;

                    List<int> intIDs = makeIDs(24 / _selected);
                    List<String> notificationIDs = intIDs.map((i) => i.toString()).toList();

                    Medicine newEntryMedicine = Medicine(
                      notificationIDs: notificationIDs,
                      medicineName: medicineName,
                      dosage: "Testing",
                      medicineType: medicineType,
                      interval: interval,
                      startTime: startTime,
                    );

                    scheduleNotification(newEntryMedicine);

                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context){
                          return SuccessScreen();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }
}


class MedicineTypeColumn extends StatelessWidget{
  final MedicineType medicineType;
  final String medicineName;
  final String iconName;
  bool isSelected = false;
  
  MedicineTypeColumn(
  {Key key,
  @required this.medicineType,
  @required this.medicineName,
  @required this.iconName,
  })
  : super(key: key);


  bool selectMed(String medName){
    if(medicineName != medName){
      return isSelected = true;
    }else{
      return isSelected = false;
    }
  }

  String  iconPath(String iconName) {
    if (iconName == "Pill"){
      return "assets/capsule.png";
    }else if(iconName == "Syringe"){
      return "assets/syringe.png";
    }
  }
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        selectMed(medicineName);
        print(medicineName);
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Color(0xFF3EB16F): Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Image.asset(
                  iconPath(iconName),
                  height: 75,
                  width: 75,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF3EB16F) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  medicineName,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? Colors.white : Color(0xFF3EB16F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget{
  final String title;
  final bool isRequired;
  PanelTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 4),
      child: Text.rich(
          TextSpan(children: <TextSpan>[
            TextSpan(
              text: title,
            style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500
            ),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(fontSize: 14, color: Color(0xFF3EB16F)),
          )
        ])
      ),
    );
  }
}


