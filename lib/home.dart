import 'dart:math';
import 'dart:ui';

import 'package:HealthGuard/helper/math_helper.dart';
import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:HealthGuard/view/hospital_suggestions_screen.dart';
import 'package:HealthGuard/view/medical_feed_screen.dart';
import 'package:HealthGuard/view/user_profile_screen.dart';
import 'package:HealthGuard/view/bloodpressure_screen.dart';
import 'package:HealthGuard/widgets/card_items.dart';
import 'package:HealthGuard/widgets/drawerListTile.dart';
import 'package:HealthGuard/widgets/navigating_card.dart';
import 'package:HealthGuard/widgets/medication_reminder_card_small.dart';
import 'package:HealthGuard/view/pedometer_screen.dart';
import 'package:HealthGuard/widgets/custom_clipper.dart';
import 'package:HealthGuard/widgets/text_icon_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/view/patient_sign_in_screen.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/view/e-medical_report_screen.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/view/medication_reminder_screen.dart';

import 'package:HealthGuard/view/find_doctor_screen.dart';

FireStoreUtils _fireStoreUtils = FireStoreUtils();

class home extends StatefulWidget {
  static const String id = "homePage";

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  /// variables
  int _selectedIndex = 0;
  static List<Widget> _bottomNavBarOptions = [
    HomeOption(),
    HealthOption(),
  ];
  List<String> appBarTitles = ['Home', 'Health'];

  /// GUI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,

      /// App Bar
      appBar: AppBar(
        title: Text(
          appBarTitles[_selectedIndex],
          style: Constants.APP_BAR_TEXT_STYLE,
        ),
        centerTitle: true,
      ),

      /// Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            /// drawer header
            Container(
              height: 120.0,
              child: DrawerHeader(
                padding: EdgeInsets.only(left: 50.0, top: 25.0),
                child: Text(
                  'Main Menu',
                  style: Constants.APP_BAR_TEXT_STYLE,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),

            /// profile list tile
            DrawerListTile(
              text: 'My Profile',
              icon: SvgPicture.asset(
                "assets/icons/personal-information.svg",
                width: 25,
              ),
              onTap: () => Navigator.pushNamed(context, UserProfile.id),
            ),

            /// logout list tile
            DrawerListTile(
              text: 'Log Out',
              icon: Transform.rotate(
                  angle: pi / 1,
                  child: Icon(Icons.exit_to_app, color: Colors.black)),
              onTap: () async {
                MyAppState.currentUser.active = false;
                MyAppState.currentUser.lastOnlineTimestamp = Timestamp.now();
                _fireStoreUtils.updateCurrentUser(
                    MyAppState.currentUser, context);
                await FirebaseAuth.instance.signOut();
                MyAppState.currentUser = null;
                pushAndRemoveUntil(context, LoginPage(), false);
              },
            ),
          ],
        ),
      ),

      body: _bottomNavBarOptions.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: appBarTitles[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: appBarTitles[1],
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

/// Heatlh option in bottom nav bar
class HealthOption extends StatelessWidget {
  const HealthOption({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              NavigatingCard(
                imageName: "assets/E-Medical Report.png",
                text: "E-Medical Report",
                screenID: EMedicalReport.id,
              ),
              NavigatingCard(
                imageName: "assets/Pedometer.png",
                text: "Pedometer",
                screenID: PedometerScreen.id,
              ),
              NavigatingCard(
                imageName: "assets/Medical News Update.png",
                text: "Medical News Update",
                screenID: MedicalFeed.id,
              ),
              NavigatingCard(
                imageName: "assets/Medication Reminder.png",
                text: "Medication Reminder",
                screenID: MedicationReminder.id,
              ),
              NavigatingCard(
                imageName: "assets/Blood Pressure Diary.png",
                text: "Blood Pressure Diary",
                screenID: BloodPressureScreen.id,
              ),
              NavigatingCard(
                imageName: "assets/Chat with Doctor.png",
                text: "Find a Doctor",
                screenID: FindDoctor.id,
              ),
              TextIconCard(
                imageName: "assets/Hospital Suggestions.png",
                text: "Hospital Suggestions",
                onTap: () {
                  //_determinePosition();
                  Navigator.pushNamed(context, HospitalSuggestions.id);
                }, // dummy input
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}

/// home option in bottom nav bar
class HomeOption extends StatefulWidget {
  @override
  _HomeOptionState createState() => _HomeOptionState();
}

class _HomeOptionState extends State<HomeOption> {
  final db = FirebaseFirestore.instance;

  String _displayGreetings(String name) {
    var hourNow = DateTime.now().hour;
    String timePart;

    if (hourNow < 12) {
      timePart = 'Morning';
    } else if (hourNow < 17) {
      timePart = 'Afternoon';
    } else {
      timePart = 'Evening';
    }

    return "Good $timePart,\n$name";
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: MyCustomClipper(clipType: ClipType.bottom),
          child: Container(
            color: Colors.blue,
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
        Container(
          child: ListView(
            children: <Widget>[
              /// entire page padding
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// greetings and profile image
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _displayGreetings(
                                MyAppState.currentUser.fullName()),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontFamily: Constants.FONTSTYLE,
                            ),
                          ),
                        ),
                        GestureDetector(
                            child: Container(
                                child: displayCircleImage(
                                    MyAppState.currentUser.profilePictureURL,
                                    80,
                                    false)),
                            onTap: () {
                              Navigator.pushNamed(context, UserProfile.id);
                            }),
                      ],
                    ),

                    /// Green Box and QR Code
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        shape: BoxShape.rectangle,
                        color: Constants.LOGO_COLOUR_GREEN_DARK,
                      ),
                      child: Material(
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: ClipPath(
                                  clipper: MyCustomClipper(
                                      clipType: ClipType.semiCircle),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
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
                                      data: MyAppState.currentUser.userID,
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

                    /// add new stuff here
                  ],
                ),
              ),

              /// medication reminder section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "YOUR DAILY MEDICATION",
                      style: TextStyle(
                        color: Constants.TEXT_LIGHT,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: Constants.FONTSTYLE,
                      ),
                    ),
                  ),

                  /// medication horizontal list
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 15),
                    height: 125,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: db
                          .collection(Constants.USERS)
                          .doc(MyAppState.currentUser.userID)
                          .collection(Constants.MEDICATION_INFO)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else if (snapshot.data.size == 0) {
                          return GestureDetector(
                              child: Container(
                                color: Color(0xFFF6F8FC),
                                child: Center(
                                  child: Text(
                                    'Tap to add medication',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Constants.TEXT_SUPER_LIGHT,
                                        fontFamily: Constants.FONTSTYLE,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, MedicationReminder.id);
                              });
                        } else {
                          var doc = snapshot.data.documents;
                          return ListView.separated(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            scrollDirection: Axis.horizontal,
                            itemCount: doc.length,
                            separatorBuilder: (context, index) => SizedBox(
                              width: 15,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                child: MedicationReminderCardSmall(
                                  title: doc[index].get("medicineName"),
                                  value: doc[index].get("dosage"),
                                  unit: "mg",
                                  time: doc[index].get("startTime"),
                                  image: AssetImage(imageLink(
                                      doc[index].get("medicineType"))),
                                  isDone: false,
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              /// pedometer section
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Pedometer text
                    Text(
                      "YOUR ACTIVITY",
                      style: TextStyle(
                        color: Constants.TEXT_LIGHT,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: Constants.FONTSTYLE,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          StreamBuilder<DocumentSnapshot>(
                            stream: db
                                .collection(Constants.USERS)
                                .doc(MyAppState.currentUser.userID)
                                .collection(Constants.PEDOMETER_INFO)
                                .doc(PedometerScreen.documentID)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PedometerScreen.id);
                                  },
                                  child: CardItems(
                                    image:
                                        Image.asset('assets/icons/Walking.png'),
                                    title: "Unknown",
                                    value: "Null",
                                    unit: "",
                                    color: Constants.LOGO_COLOUR_PINK_LIGHT,
                                    progress: 0,
                                  ),
                                );
                              } else {
                                PedometerData pedometerData =
                                    PedometerData.fromJson(
                                        snapshot.data.data());
                                int pedometerProgress =
                                    MathHelper.intPercentage(
                                        pedometerData.steps,
                                        pedometerData.goal);
                                print(pedometerProgress);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, PedometerScreen.id);
                                  },
                                  child: CardItems(
                                    image:
                                        Image.asset('assets/icons/Walking.png'),
                                    title: "Walking",
                                    value: pedometerData.steps.toString(),
                                    unit: "steps",
                                    color: Constants.LOGO_COLOUR_PINK_LIGHT,
                                    progress: pedometerProgress,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
