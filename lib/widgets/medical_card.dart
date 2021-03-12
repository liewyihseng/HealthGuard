import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/model/user_medic_info_model.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/view/detailed_medical_screen.dart';

class MedicalCard extends StatelessWidget {
  final user_medic_info medicInfo;

  MedicalCard({Key key, @required this.medicInfo}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 1,
        margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: Padding(
          padding:
          EdgeInsets.only(top: 20.0, bottom: 20.0, left: 30.0, right: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  medicInfo.uploadedDate,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Health Condition : " + medicInfo.healthCondition,
                style: TextStyle(
                  fontSize: 15,
                  color: Constants.TEXT_LIGHT,
                ),
              ),
              Text(
                "Current Medication : " + medicInfo.currentMedication,
                style: TextStyle(
                  fontSize: 15,
                  color: Constants.TEXT_LIGHT,
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  "Tap to view more",
                  style: TextStyle(
                    fontSize: 15,
                    color: Constants.TEXT_DARK,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedMedical(medicInfo: medicInfo)));
      },
    );
  }
}
