import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'main.dart';
import 'valtool.dart';
import 'package:flutter/cupertino.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'constants.dart' as Constants;
import 'User.dart' as OUser;
import 'infomation.dart' as info;

import 'dart:io';

// Define a custom Form widget.
class EmedicReport extends StatefulWidget {
  static const String id = "EmedicalReport";
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

GlobalKey<FormState> _key = new GlobalKey();

// Define a corresponding State class.

class MyCustomFormState extends State<EmedicReport> {
  String birthday,
      sex,
      healthCondition,
      currentMedication,
      address,
      emergencyContact;
  final _formKey = GlobalKey<FormState>();
  //variable
  DateTime _dateTime;
  String dropdownValue;
  //test style
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("E-Medical Report"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RaisedButton(
                        child: Text(_dateTime == null
                            ? 'Select Birthday'
                            : Jiffy(_dateTime).yMMMMd),
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime(2100))
                              .then((date) {
                            setState(() {
                              _dateTime = date;
                            });
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      DropdownButton<String>(
                        value: dropdownValue,
                        hint: Text("Gender"),
                        elevation: 16,
                        style: TextStyle(color: Colors.blue),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
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
                    ],
                  ),
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextFormField(
                            validator: validateName,
                            onSaved: (String val) {
                              healthCondition = val;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                fillColor: Colors.white,
                                hintText: 'Health Condition',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ))))),
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextFormField(
                            validator: validateName,
                            onSaved: (String val) {
                              currentMedication = val;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                fillColor: Colors.white,
                                hintText: 'Current Medication',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ))))),
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextFormField(
                            validator: validateName,
                            onSaved: (String val) {
                              address = val;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                fillColor: Colors.white,
                                hintText: 'Home address',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ))))),
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, right: 8.0, left: 8.0),
                        child: TextFormField(
                            validator: validateName,
                            onSaved: (String val) {
                              emergencyContact = val;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                fillColor: Colors.white,
                                hintText: 'Emergency Contact',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ))))),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: double.infinity),
                    child: RaisedButton(
                      color: Color(0xff01A0C7),
                      child: Text(
                        'Submit',
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
                          side: BorderSide(color: Colors.blue)),
                    ),
                  ),
                ),
              ]),
        ));
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Submiting Infomation', false);
      info.infomation Hinfo = info.infomation(
          birthday: birthday,
          sex: sex,
          healthCondition: healthCondition,
          currentMedication: currentMedication,
          address: address,
          emergencyContact: emergencyContact);

      await FireStoreUtils.firestore.collection(Constants.RECORDS);
      hideProgress();
    }
  }
}
