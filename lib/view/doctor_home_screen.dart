import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/model/doctor_model.dart' as OurDoctor;
import 'package:HealthGuard/view/doctor_sign_in_screen.dart';
import 'package:HealthGuard/view/my_medical_screen.dart';
import 'package:HealthGuard/view/user_profile_screen.dart';
import 'package:HealthGuard/widgets/navigating_card.dart';
import 'package:HealthGuard/widgets/text_icon_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:flutter_svg/svg.dart';
import 'package:HealthGuard/view/chat_with_patient.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;


FireStoreUtils _fireStoreUtils = FireStoreUtils();

class DoctorHome extends StatefulWidget{
  static const String id = "doctorHomePage";
  final OurDoctor.Doctor doctor;

  DoctorHome({Key key, @required this.doctor}) : super(key: key);

  @override
  State createState(){
    print(doctor.toString());
    return _doctorHome(doctor);
  }
}

class _doctorHome extends State<DoctorHome>{
  final OurDoctor.Doctor doctor;

  _doctorHome(this.doctor);
  TextEditingController _outputController;

  @override
  initState(){
    super.initState();
    this._outputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Home',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            displayCircleImage(doctor.profilePictureURL, 125, false),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Full Name: " + doctor.fullName(), style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Email: " + doctor.email, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Phone Number: " + doctor.phoneNumber, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("User ID: " + doctor.userID, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("User Type: " + doctor.userType, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Gender: " + doctor.sex, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Birthday: " + doctor.birthday, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Workplace: " + doctor.workPlace, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Speciality: " + doctor.speciality, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("About Yourself: " + doctor.aboutYourself, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Doctor ID: " + doctor.doctorID, style: TextStyle(fontFamily: Constants.FONTSTYLE),),
            ),

            TextIconCard(
              text: "Patient Qr Scanner",
              imageName: "assets/Patient Qr Scanner.png",
              onTap: _scanQR,
            ),

            NavigatingCard(
              imageName: "assets/Chat with Doctor.png",
              text: "Chat with Patient",
              screenID: ChatWithPatient.id,
            ),

          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 130.0,
              child: DrawerHeader(
                padding: EdgeInsets.only(left: 50.0, top: 25.0),
                child: Text(
                  'Main Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w900,
                ),
              ),
              leading: SvgPicture.asset(
                "assets/icons/personal-information.svg",
                width: 25,
                color: Colors.black,
              ),
              onTap: (){
                Navigator.pushNamed(context, UserProfile.id);
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w900,
                ),
              ),
              leading: Transform.rotate(
                angle: pi/1,
                child: Icon(Icons.exit_to_app, color: Colors.black,),
              ),
              onTap: () async{
                doctor.active = false;
                doctor.lastOnlineTimestamp = Timestamp.now();
                _fireStoreUtils.updateCurrentUser(doctor, context);
                await FirebaseAuth.instance.signOut();
                MyAppState.currentUser = null;
                pushAndRemoveUntil(context, DoctorSignIn(), false);
              },
            )
          ],
        ),
      ),
    );
  }


  Future _scanQR() async {
    await Permission.camera.request();
    String barcode = await scanner.scan();
    if (barcode == null) {
      print('This is an invalid QR Code');

    }  else{
      this._outputController.text = barcode;
      print("The scanned patient is: "+ _outputController.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyMedical(userID: _outputController.text,)));
    }
  }


}