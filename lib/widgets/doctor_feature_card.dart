import 'dart:ui';

import 'package:HealthGuard/widgets/custom_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class DoctorFeatureCard extends StatelessWidget{
  final String image;
  final String title;
  final Color color;
  final Function onTap;

  DoctorFeatureCard (
      {Key key,
        @required this.image,
        @required this.title,
        @required this.color,
        @required this.onTap,})
      :super(key: key);

  @override
  Widget build(BuildContext context){
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 15.0),
        width: (MediaQuery.of(context).size.width - (30.0 * 2 + 30.0 / 2)),
        height: 110,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          shape: BoxShape.rectangle,
          color: color,
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
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0, left: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            width: 32,
                            height: 32,
                            image: AssetImage(
                              image,
                            ),
                          ),

                          SizedBox(width:30),

                          Expanded(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: Constants.FONTSTYLE,
                                fontWeight: FontWeight.bold,
                                color: Constants.TEXT_DARK,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
            onTap: onTap,
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}