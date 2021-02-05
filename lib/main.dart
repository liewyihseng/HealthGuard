import 'package:HealthGuard/Bloodpressure1.dart';
import 'file:///C:/Users/user/AndroidStudioProjects/HealthGuard/lib/view/help_center_view.dart';
import 'package:HealthGuard/medical_feed.dart';
import 'package:HealthGuard/medication_reminder.dart';
import 'package:HealthGuard/medicine_detail.dart';
import 'package:HealthGuard/my_account.dart';
import 'package:HealthGuard/my_medical.dart';
import 'package:HealthGuard/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/user/AndroidStudioProjects/HealthGuard/lib/model/user_model.dart' as OurUser;
import 'package:HealthGuard/authentication.dart';
import 'package:HealthGuard/home.dart';
import 'package:HealthGuard/login_page.dart';
import 'package:HealthGuard/e-medical_report.dart';
import 'package:HealthGuard/view/pedometer_screen.dart';
import 'package:HealthGuard/chat/chatroom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static OurUser.User currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        home.id: (context) => home(
              user: currentUser,
            ),
        UserProfile.id: (context) => UserProfile(),
        MyAccount.id: (context) => MyAccount(),
        MyMedical.id: (context) => MyMedical(),
        HelpCenter.id: (context) => HelpCenter(),
        PedometerScreen.id: (context) => PedometerScreen(),
        MedicalFeed.id: (context) => MedicalFeed(),
        EMedicalReport.id: (context) => EMedicalReport(),
        MedicationReminder.id: (context) => MedicationReminder(),
        MedicineDetail.id: (context) => MedicineDetail(),
        Bloodpressure1.id: (context) =>
            Bloodpressure1(sys: 60, dia: 70, pul: 80),
        Chatroom.id: (context) => Chatroom(),
      },
      theme: ThemeData(accentColor: Colors.white),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (FirebaseAuth.instance.currentUser != null && currentUser != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        currentUser.active = false;
        currentUser.lastOnlineTimestamp = Timestamp.now();
        FireStoreUtils.currentUserDocRef.update(currentUser.toJson());
      } else if (state == AppLifecycleState.resumed) {
        //user online
        currentUser.active = true;
        FireStoreUtils.currentUserDocRef.update(currentUser.toJson());
      }
    }
  }
}

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.red,
    body: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ),
  );
}
