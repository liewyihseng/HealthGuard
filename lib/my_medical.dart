import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/authentication.dart';

/// User's medical information screen page widget class
class MyMedical extends StatefulWidget{
  static const String id = "MyMedicalPage";
  const MyMedical({Key key}) : super(key: key);
  @override
  _MyMedicalState createState() => _MyMedicalState();
}

/// User's medical information screen page state class
class _MyMedicalState extends State<MyMedical>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical Information',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          /// Birthday
          Text("Dummy Birthday",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Sex
          Text("Dummy Sex",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Height
          Text("Dummy Height",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Weight
          Text("Dummy Weight",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Current Medication
          Text("Dummy Current Medication",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Address
          Text("Dummy Address",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Health Condition
          Text("Dummy Health Condition",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }


}