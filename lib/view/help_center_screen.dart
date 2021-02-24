import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// Help center screen page widget class
class HelpCenter extends StatefulWidget{
  static const String id = "HelpCenterPage";
  const HelpCenter({Key key}) : super(key: key);
  @override
  _HelpCenterState createState() => _HelpCenterState();
}

/// Help center screen page state class
class _HelpCenterState extends State<HelpCenter>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Help Center',
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
        children: <Widget>[

          Container(
            height: 205.0,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                "assets/Logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(height: 20.0),

          Padding(
            padding: EdgeInsets.only(left: 35, right: 35),
            child: Column(
              children: <Widget> [
                Text(
                  'This project aims to provide people with an all in one Health SuperApp that provides users with various features that enhance the living quality of users. Besides, HealthGuard is a currently undergoing project being developed by Year 2 Computer Science students of University of Nottingham Malaysia Campus.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Constants.TEXT_LIGHT,
                      fontFamily: Constants.FONTSTYLE,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),

                SizedBox(height: 25),
                Text(
                  'To know more, get in touch with us via healthguard.firebase@gmail.com. Thank you for your support.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Constants.TEXT_LIGHT,
                      fontFamily: Constants.FONTSTYLE,
                      fontSize: 19),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}