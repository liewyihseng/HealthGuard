import 'package:HealthGuard/Bloodpressure1.dart';
import 'package:HealthGuard/MedicalFeed.dart';
import 'package:HealthGuard/emedical_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'User.dart' as OUser;
import 'auth.dart';
import 'home.dart';
import 'login_page.dart';
import 'pedometer_page.dart';

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
  static OUser.User currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        // ignore: missing_required_param
        home.id: (context) => home(),
        PedometerPage.id: (context) => PedometerPage(),
        MedicalFeed.id: (context) => MedicalFeed(),
        EmedicReport.id: (context) => EmedicReport(),
        Bloodpressure1.id: (context) =>
            Bloodpressure1(sys: 60, dia: 70, pul: 80),
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
