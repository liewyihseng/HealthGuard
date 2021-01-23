import 'package:HealthGuard/main.dart';
import 'package:flutter/material.dart';

/// User's account information screen page widget class
class MyAccount extends StatefulWidget{
  static const String id = "MyAccountPage";
  const MyAccount({Key key}) : super(key: key);
  @override
  _MyAccountState createState() => _MyAccountState();
}

/// My account screen page state class
class _MyAccountState extends State<MyAccount>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Account',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          /// Full Name
          Text(MyAppState.currentUser.fullName(),
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// User id
          Text(MyAppState.currentUser.userID,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Email Address
          Text(MyAppState.currentUser.email,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),

          /// Phone Number
          Text(MyAppState.currentUser.phoneNumber,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontSize: 15,
            ),
          ),
          
        ],
      ),
    );
  }
}