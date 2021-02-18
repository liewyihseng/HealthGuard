import 'dart:ui';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;


File _image;



/// Doctor Sign up screen page widget class
class DoctorSignUp extends StatefulWidget {
  static const String id = 'DoctorSignUp';
  @override
  State createState() => _doctorSignUpPageState();
}



/// Doctor Sign up screen page state class
class _doctorSignUpPageState extends State<DoctorSignUp> {


  /// build
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Register as Panel Doctor',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
            fontFamily: Constants.FONTSTYLE,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: new Container(
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    }
  }

}
