import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/model/doctor_model.dart';
import 'package:HealthGuard/view/doctor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class DoctorCard extends StatelessWidget{
  final Doctor doctor;

  DoctorCard({Key key,
  @required this.doctor})
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            color: Color(0xffECF0F5),
          ),
          child: Container(
            padding: EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                displayCircleImage(doctor.profilePictureURL, 30, true),

                SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dr. " + doctor.fullName(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: Constants.FONTSTYLE,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 250,
                      height: 50,
                      child: Text(
                        doctor.aboutYourself,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: Constants.FONTSTYLE,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, DoctorDetail.id);
        },
      ),
    );
  }
}