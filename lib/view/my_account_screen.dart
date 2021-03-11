import 'dart:ui';

import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// User's account information screen page widget class
class MyAccount extends StatefulWidget {
  static const String id = "MyAccountPage";
  const MyAccount({Key key}) : super(key: key);
  @override
  _MyAccountState createState() => _MyAccountState();
}

/// My account screen page state class
class _MyAccountState extends State<MyAccount> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'My Account',
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
      body: StreamBuilder<QuerySnapshot>(

          /// Creating a stream connecting to the database (collection is to access the collection, doc is to access the document within the collection)
          stream: db
              .collection(Constants.USERS)
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var doc = snapshot.data.documents;
              return ListView(
                children: [Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: displayCircleImage(MyAppState.currentUser.profilePictureURL, 150, false),
                                ),
                              ]
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            MyAppState.currentUser.fullName(),
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontFamily: Constants.FONTSTYLE,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    Card(
                      margin: EdgeInsets.all(10),
                      elevation: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User ID: ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              MyAppState.currentUser.userID,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Email Address: ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              MyAppState.currentUser.email,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Phone Number: ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              MyAppState.currentUser.phoneNumber,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Gender: ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              MyAppState.currentUser.sex,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Birthday: ",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              MyAppState.currentUser.birthday,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: Constants.FONTSTYLE,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),]
              );
            } else {
              return Column(
                children: <Widget>[
                  LinearProgressIndicator(),
                  Text(
                    "Nothing To Show",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: Constants.FONTSTYLE,
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
