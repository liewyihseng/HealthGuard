import 'package:HealthGuard/authentication.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/validation_tool.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:HealthGuard/home.dart';
import 'package:HealthGuard/user_medic_info.dart' as medic_info;
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:flutter/services.dart';

/// Medical report screen page widget class
class EMedicalReport extends StatefulWidget{
  static const String id = "EMedicalReport";
  @override
  State createState() => _medicalPageState();
}

/// Medical Report screen page state class
class _medicalPageState extends State<EMedicalReport>{
   String height, weight, birthday, sex, healthCondition, currentMedication, address, emergencyContact;
   DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Medical Report',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: new Form(
            child: medicalReportForm(),
            /// Calling medical report form
          ),
        )
      ),
    );
  }
  
  /// Medical report form
  Widget medicalReportForm(){
    return new Column(
      children: <Widget>[
        /// Field for user's height input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
                onChanged: (String val){
                  setState((){
                    height = val;
                  });
                },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Height',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                )
              )
            )
          ),
        ),
        /// Field for user's weight input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  onChanged: (String val){
                    setState((){
                      weight = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Weight',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),
        /// Calendar for user's birthday input
        RaisedButton(
          child: Text(_dateTime == null
              ? 'Select Birthday'
              : Jiffy(_dateTime).yMMMMd),
          onPressed: () {
            showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100))
                .then((date) {
              setState(() {
                _dateTime = date;
              });
            });
          },
        ),
        /// Dropdown for user's sex input
        DropdownButton<String>(
          value: sex,
          hint: Text("Gender"),
          elevation: 16,
          style: TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String newValue) {
            setState(() {
              sex = newValue;
            });
          },
          items: <String>['Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        /// Field for user's health condition input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  onChanged: (String val){
                    setState((){
                      healthCondition = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Health Condition',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// Field for user's current medication input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  onChanged: (String val){
                    setState((){
                      currentMedication = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Current Medication',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),
        /// Field for user's address input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  onChanged: (String val){
                    setState((){
                      address = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),
        /// Field for user's emergency contact input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  onChanged: (String val){
                    setState((){
                      emergencyContact = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Emergency Contact',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),
        /// Button to press after user has finished filling in their medical information
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
                  fontFamily: "Montserrat"),
                ),
              textColor: Colors.white,
              splashColor: Colors.blue,
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: Colors.blue)
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Sending user's medical information to server (firebase)
  _sendToServer() async{
    showProgress(context, "Processing Submission", false);
    /// Assigning all the user's input medical information to the user_medic_info instance
    medic_info.user_medic_info user_medic_info = medic_info.user_medic_info(
      height: height,
      weight: weight,
      birthday: _dateTime.toString(),
      sex: sex,
      healthCondition: healthCondition,
      currentMedication: currentMedication,
      address: address,
      emergencyContact: emergencyContact,
    );

    await FireStoreUtils.firestore
      .collection(Constants.USERS)
      .doc(MyAppState.currentUser.userID)
      .collection(Constants.MED_INFO)
      .add(user_medic_info.toJson());
    hideProgress();
    pushAndRemoveUntil(context, home(user: MyAppState.currentUser), false);
  }
}

