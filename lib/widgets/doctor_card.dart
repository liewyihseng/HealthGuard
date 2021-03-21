import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/view/doctor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

import 'custom_clipper.dart';

/// Handles the display of the doctor card containing the information of the doctor where the users will be able to click onto it to have more insights to the doctor
class DoctorCard extends StatelessWidget{
  final OurUser.User doctor;

  DoctorCard({Key key,
    @required this.doctor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        margin: const EdgeInsets.only(right: 15.0, left: 15.0,bottom: 10.0),
        width: (MediaQuery.of(context).size.width),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: Colors.white,
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
                        color: Colors.black.withOpacity(0.07),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 3.0),
                            child: displayCircleImage(doctor.profilePictureURL, 75, true),
                          ),

                          SizedBox(width: 20.0),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              SizedBox(height: 5.0),

                              Text(
                                doctor.fullNameDr(),
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  doctor.speciality,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: Constants.FONTSTYLE,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Text(
                                  doctor.workPlace,
                                  style: TextStyle(
                                    fontSize: 17,
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

                    ],
                  ),
                )
              ],
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetail(doctor: doctor,)));
            },
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}