import 'dart:math';
import 'dart:ui';

import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/model/doctor_model.dart' as OurDoctor;
import 'package:HealthGuard/view/doctor_qr_scanner.dart';
import 'package:HealthGuard/view/doctor_sign_in_screen.dart';
import 'package:HealthGuard/view/user_profile_screen.dart';
import 'package:HealthGuard/widgets/navigating_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:flutter_svg/svg.dart';

import 'package:HealthGuard/view/chat_with_patient.dart';

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
      body: Scaffold(
        backgroundColor: Constants.BACKGROUND_COLOUR,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  NavigatingCard(
                    imageName: "assets/Patient QR Scanner.png",
                    text: "Patient QR Scanner",
                    screenID: DoctorQrScanner.id,
                  ),
                  NavigatingCard(
                    imageName: "assets/Chat with Doctor.png",
                    text: "Chat with Patient",
                    screenID: ChatWithPatient.id,
                  ),
                ],
              ),
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


}