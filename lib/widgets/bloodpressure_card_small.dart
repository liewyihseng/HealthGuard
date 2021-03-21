import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// Handles the creation of card that displays the average of pulse and blood pressure on the top of the Blood Pressure History Screen
class BloodPressureCardSmall extends StatelessWidget {
  final String status;
  final String value;
  final String unit;
  final String remarks;

  BloodPressureCardSmall({
    Key key,
    @required this.status,
    @required this.value,
    @required this.unit,
    @required this.remarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 115,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        shape: BoxShape.rectangle,
        color: Constants.BACKGROUND_COLOUR,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  status,
                  style: TextStyle(
                      fontSize: 15,
                      color: Constants.TEXT_DARK
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: <Widget>[
                Text(
                  value,
                  style: TextStyle(
                      fontWeight:
                      FontWeight.w900,
                      fontSize: 30,
                      color: Color(0xFF3ABD6F),
                  ),
                ),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}