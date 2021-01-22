import 'dart:math';
import 'dart:ui';

import 'package:HealthGuard/pedometer_page.dart';
import 'package:HealthGuard/medical_feed.dart';
import 'package:HealthGuard/widgets/custom_clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Bloodpressure1.dart';
import 'User.dart' as OurUser;
import 'authentication.dart';
import 'login_page.dart';
import 'main.dart';
import 'medical_report.dart';
import 'validation_tool.dart';

FireStoreUtils _fireStoreUtils = FireStoreUtils();

class home extends StatefulWidget {
  static const String id = "homePage";
  final OurUser.User user;

  home({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    print(user.toString());
    return _home(user);
  }
}

// ignore: camel_case_types
class _home extends State<home> {
  final OurUser.User user;

  // bottom nav bar selected index
  int _selectedIndex = 0;

  /// list of widgets to switch between for bottom nav bar
  static List<Widget> _bottomNavBarOptions;

  _home(this.user);

  /// bottom nav bar on item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// initialize options with widgets
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

/// option 2 in bottom nav bar
class HealthOption extends StatelessWidget {
  const HealthOption({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Card(
                elevation: 3.0,
                child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/E-Medical Report.png",
                            alignment: Alignment.center,
                            width: 100.0,
                            height: 27.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "E-Medical Report",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, EMedicalReport.id);
                    })),
            Card(
                elevation: 3.0,
                child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/Pedometer.png",
                            alignment: Alignment.center,
                            width: 40.0,
                            height: 27.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Pedometer",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, PedometerPage.id);
                    })),
            Card(
                elevation: 3.0,
                child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/Medical News Update.png",
                            alignment: Alignment.center,
                            width: 40.0,
                            height: 27.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Medical News Update",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, MedicalFeed.id);
                    })),
            Card(
                elevation: 3.0,
                child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/Medication Reminder.png",
                            alignment: Alignment.center,
                            width: 40.0,
                            height: 27.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Medication Reminder",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, PedometerPage.id);
                    })),
            Card(
                elevation: 3.0,
                child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/Blood Pressure Diary.png",
                            alignment: Alignment.center,
                            width: 40.0,
                            height: 27.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Blood Pressure Diary",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, Bloodpressure1.id);
                    })),
            Card(
                elevation: 3.0,
                child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/Chat with Doctor.png",
                            alignment: Alignment.center,
                            width: 40.0,
                            height: 27.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Chat with Doctor",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, PedometerPage.id);
                    })),
            Card(
                elevation: 3.0,
                child: GestureDetector(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/Hospital Suggestions.png",
                            alignment: Alignment.center,
                            width: 40.0,
                            height: 27.0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Hospital Suggestions",
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, PedometerPage.id);
                    })),
          ],
        ));
  }
}

String displayGreetings() {
  var hourNow = DateTime
      .now()
      .hour;
  if (hourNow < 12) {
    return 'Morning';
  }
  if (hourNow < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

/// home option in bottom nav bar
class HomeOption extends StatefulWidget {
  final OurUser.User user;

  HomeOption({Key key, @required this.user}) : super(key: key);

  @override
  _HomeOptionState createState() => _HomeOptionState(user);
}

class _HomeOptionState extends State<HomeOption> {
  final OurUser.User user;

  _HomeOptionState(this.user);

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F7),
      body: Stack(
          children: <Widget>[
      ClipPath(
      clipper: MyCustomClipper(clipType: ClipType.bottom),
      child: Container(
        color: Color(0xFF3B72FF),
        height: 228.5 + statusBarHeight,
      ),
    ),
      Positioned(
        right: -45,
        top: -30,
        child: ClipOval(
          child: Container(
          color: Colors.black.withOpacity(0.05),
          height: 220,
          width: 220,
          ),
        ),
      ),

      Padding(
        padding: EdgeInsets.all(35),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text("Good " + displayGreetings() + ",\n"+ user.fullName() +".",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
                displayCircleImage(user.profilePictureURL, 55, false),
              ],
            ),

            SizedBox(height: 25),
            /// Green Box containing the user's QR Code
            Container(
              margin: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0, bottom: 15.0),
              width: (
                  (MediaQuery.of(context).size.width - (30.0 * 2 + 30.0 / 2)) /
                      2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                shape: BoxShape.rectangle,
                color: Color(0xFFA1ECBF),
              ),
              child: Material(
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: ClipPath(
                          clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.black.withOpacity(0.03),
                            ),
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            QrImage(
                              data: user.userID,
                              version: QrVersions.auto,
                              padding: EdgeInsets.all(15.0),
                              size: 250.0,
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    ],
      ),
    );


    /*
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
          /// Generation of user's QR Code
          QrImage(
            data: user.userID,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ],
      ),
    );
    */
  }
}
