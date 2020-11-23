import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MedicalFeed.dart';
import 'User.dart' as OUser;
import 'auth.dart';
import 'login_page.dart';
import 'main.dart';
import 'valtool.dart';

FireStoreUtils _fireStoreUtils = FireStoreUtils();

class home extends StatefulWidget {
  static const String id = "homePage";
  final OUser.User user;

  home({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    print(user.toString());
    return _home(user);
  }
}

// ignore: camel_case_types
class _home extends State<home> {
  final OUser.User user;

  _home(this.user);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Main Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w900),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w900),
              ),
              leading: Transform.rotate(
                  angle: pi / 1,
                  child: Icon(Icons.exit_to_app, color: Colors.black)),
              onTap: () async {
                user.active = false;
                user.lastOnlineTimestamp = Timestamp.now();
                _fireStoreUtils.updateCurrentUser(user, context);
                await FirebaseAuth.instance.signOut();
                MyAppState.currentUser = null;
                pushAndRemoveUntil(context, LoginPage(), false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            displayCircleImage(user.profilePictureURL, 125, false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.firstName),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.email),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.phoneNumber),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(user.userID),
            ),
            Card(
                elevation: 3.0,
                child: new GestureDetector(
                    child: new Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/Logo.png",
                            alignment: Alignment.center,
                            width: 40.0,
                            height: 40.0,
                          ),
                          new Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Health Articles",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, MedicalFeed.id);
                    })),
          ],
        ),
      ),
    );
  }
}
