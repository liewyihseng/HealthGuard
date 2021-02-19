import 'package:HealthGuard/constants.dart' as Constants;
import 'package:flutter/material.dart';

class MedicalCard extends StatelessWidget{
  final String height;
  final String weight;
  final String birthday;
  final String sex;
  final String healthCondition;
  final String currentMedication;
  final String address;
  final String emergencyContact;
  final String insuranceID;
  final String uploadedDate;

  MedicalCard(
      {Key key,
        @required this.height,
        @required this.weight,
        @required this.birthday,
        @required this.sex,
        @required this.healthCondition,
        @required this.currentMedication,
        @required this.address,
        @required this.emergencyContact,
        @required this.insuranceID,
        @required this.uploadedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 350,
          margin: EdgeInsets.only(top: 10),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: Stack(
            overflow: Overflow.clip,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 30.0, right: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                        Text(
                          "Height : " + height,
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.TEXT_LIGHT,
                          ),
                        ),
                        Text(
                          "Weight : " + weight,
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.TEXT_LIGHT,
                          ),
                        ),
                        Text(
                          "Health Condition : " + healthCondition,
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.TEXT_LIGHT,
                          ),
                        ),
                        Text(
                          "Current Medication : " + currentMedication,
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.TEXT_LIGHT,
                          ),
                        ),
                        Text(
                          "Emergency Contact : " + emergencyContact,
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.TEXT_LIGHT,
                          ),
                        ),
                        Text(
                          "Insurance ID : " + insuranceID,
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.TEXT_LIGHT,
                          ),
                        ),
                    Text(
                      "Uploaded On "+ uploadedDate,
                      style: TextStyle(
                        fontSize: 15,
                        color: Constants.TEXT_LIGHT,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}