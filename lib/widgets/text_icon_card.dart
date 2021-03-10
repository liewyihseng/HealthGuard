import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class TextIconCard extends StatelessWidget {

  final String imageName, text;
  final Function onTap;

  TextIconCard({this.imageName, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
    boxShadow: [
    BoxShadow(
    color: Colors.grey,
    blurRadius: 6.0,
    ),
    ],
    color: Colors.white,
    ),
    child: InkWell(
        child: Card(
          elevation: 3.0,
          child: Container(
            padding: EdgeInsets.all(3),
            child: Column(
              children: <Widget>[
                Image.asset(
                  imageName,
                  alignment: Alignment.center,
                  width: 30.0,
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontFamily: Constants.FONTSTYLE,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: onTap,
    ),
    );
  }
}
