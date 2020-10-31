import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'User.dart' as OUser;


void main() async{
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
  Widget build(BuildContext context){
    return MaterialApp(
        theme: ThemeData(accentColor: Colors.white),
        home: LoginPage());
  }

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose(){
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


TextStyle style = TextStyle(fontFamily:  'Montserrat', fontSize: 20.0);

@override
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: Colors.red,
    body: Center(
    child: CircularProgressIndicator(backgroundColor: Colors.white,),
  ),
  );
}