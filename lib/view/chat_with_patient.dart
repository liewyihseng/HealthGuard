import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// Chat with Patient screen page widget class
class ChatWithPatient extends StatefulWidget{
  static const String id = "DoctorQrScannerPage";
  const ChatWithPatient({Key key}) : super(key: key);
  @override
  _ChatWithPatientState createState() => _ChatWithPatientState();
}

/// Chat with Patient screen page state class
class _ChatWithPatientState extends State<ChatWithPatient>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Chat with Patient',
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

    );
  }
}