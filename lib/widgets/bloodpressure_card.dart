import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:intl/intl.dart';

import 'custom_clipper.dart';


class BloodPressureCard extends StatelessWidget {
  final String BPvalue;
  final String HRvalue;
  final String submittedDate;

  BloodPressureCard(
      {Key key,
        @required this.BPvalue,
        @required this.HRvalue,
        @required this.submittedDate,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0, left: 15.0, top: 20.0),
        width: (
            (MediaQuery.of(context).size.width - (30.0 * 2 + 30.0 / 2))),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: Color(0xFFFFDA7A),
        ),
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              overflow: Overflow.clip,
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
                  padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image(
                              width: 32,
                              height: 32,
                              image: AssetImage('assets/icons/blooddrop.png'),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Text(
                              "Blood Pressure",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Constants.TEXT_DARK,
                              ),
                            ),
                          ),
                          Image(
                              width: 32,
                              height: 32,
                              image: AssetImage('assets/icons/heartbeat.png'),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Text(
                              "Heart Beat",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: Constants.TEXT_DARK,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            BPvalue,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Constants.TEXT_DARK,
                            ),
                          ),

                          SizedBox(width: 50),
                          Text(
                            HRvalue,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Constants.TEXT_DARK,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "mmHg",
                            style: TextStyle(
                                fontSize: 15,
                                color: Constants.TEXT_DARK
                            ),
                          ),

                          SizedBox(width: 105),

                          Text(
                            "bpm",
                            style: TextStyle(
                                fontSize: 15,
                                color: Constants.TEXT_DARK
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.only(left: 220.0),
                        child: Text(
                          convertDateTimeDisplay(submittedDate),
                          style: TextStyle(
                              fontSize: 15,
                              color: Constants.TEXT_DARK
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            onTap: () {
              debugPrint("CARD main clicked. redirect to details page");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => DetailScreen()),
              // );
            },
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }

  /// Converting dateTime that shows hours: minutes: seconds to date only
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormatter.parse(date);
    final String formatted = serverFormatter.format(displayDate);
    return formatted;
  }
}