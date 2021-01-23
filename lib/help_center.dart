import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(
          'Help Center',
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

        ],
      ),
    );
  }
}