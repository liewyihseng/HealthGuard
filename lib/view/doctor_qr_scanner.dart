import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// Doctor QR Scanner screen page widget class
class DoctorQrScanner extends StatefulWidget{
  static const String id = "DoctorQrScannerPage";
  const DoctorQrScanner({Key key}) : super(key: key);
  @override
  _DoctorQrScannerState createState() => _DoctorQrScannerState();
}

/// Doctor QR Scanner screen page state class
class _DoctorQrScannerState extends State<DoctorQrScanner>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'QR Scanner',
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