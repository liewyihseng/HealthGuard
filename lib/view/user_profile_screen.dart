import 'dart:io';

import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/view/login_screen.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/view/my_account_screen.dart';
import 'package:HealthGuard/view/my_medical_screen.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/view/help_center_view.dart';

File _image;
FireStoreUtils _fireStoreUtils = FireStoreUtils();

/// User Profile screen page widget class
class UserProfile extends StatefulWidget{
  static const String id = "UserProfilePage";
  const UserProfile({Key key}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

/// User Profile screen page state class
class _UserProfileState extends State<UserProfile>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Profile',
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
      body: Column(
        children: [
          SizedBox(
            child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: displayCircleImage(MyAppState.currentUser.profilePictureURL, 115, false),
              ),
            ]
            ),
          ),
          SizedBox(
            height: 20
          ),

          /// My account button
          ProfileMenu(
            icon: "assets/icons/personal-information.svg",
            text: "My Account",
            press: (){
              Navigator.pushNamed(context, MyAccount.id);
            },
          ),

          /// Medical information button
          ProfileMenu(
            icon: "assets/icons/medical-record.svg",
            text: "Medical Information",
            press: (){
              Navigator.pushNamed(context, MyMedical.id);
            },
          ),

          /// Help center button
          ProfileMenu(
            icon: "assets/icons/help-center.svg",
            text: "Help Center",
            press: (){
              Navigator.pushNamed(context, HelpCenter.id);
            },
          ),

          /// Log out button
          ProfileMenu(
            icon: "assets/icons/logout.svg",
            text: "Log Out",
            press: () async {
              MyAppState.currentUser.active = false;
              MyAppState.currentUser.lastOnlineTimestamp = Timestamp.now();
              _fireStoreUtils.updateCurrentUser(MyAppState.currentUser, context);
              await FirebaseAuth.instance.signOut();
              MyAppState.currentUser = null;
              pushAndRemoveUntil(context, LoginPage(), false);
            },
          ),
        ],
      ),
    );
  }
}


/// Method to create the frame of the button
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.white,
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 25,
              color: Colors.black,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(
                    text,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
                  ),
                ),
            Icon(Icons.arrow_forward_ios),
          ],
        )
      ),
    );
  }
}