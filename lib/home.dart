import 'dart:math';

import 'package:HealthGuard/pedometer_page.dart';
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
  // bottom nav bar selected index
  int _selectedIndex = 0;
  // list of widgets to switch between for bottom nav bar
  static List<Widget> _bottomNavBarOptions;

  _home(this.user);

  // bottom nav bar on item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // initialize options with widgets
    _bottomNavBarOptions = <Widget>[
      HomeOption(
        user: user,
      ),
      HealthOption(),
    ];

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
      body: _bottomNavBarOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Health",
          )
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}

// option 2 in bottom nav bar
class HealthOption extends StatelessWidget {
  const HealthOption({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        RaisedButton(
          child: Text("pedometer"),
          onPressed: () {
            Navigator.pushNamed(context, PedometerPage.id);
          },
        ),
        Card(
            elevation: 3.0,
            child: GestureDetector(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/Logo.png",
                        alignment: Alignment.center,
                        width: 40.0,
                        height: 40.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Health Articles",
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
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
    ));
  }
}

// home option in bottom nav bar
class HomeOption extends StatefulWidget {
  final OUser.User user;
  HomeOption({Key key, @required this.user}) : super(key: key);
  @override
  _HomeOptionState createState() => _HomeOptionState(user);
}

class _HomeOptionState extends State<HomeOption> {
  final OUser.User user;

  _HomeOptionState(this.user);

  @override
  Widget build(BuildContext context) {
    return Center(
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
        ],
      ),
    );
  }
}
