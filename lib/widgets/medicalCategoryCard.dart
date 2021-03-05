import 'package:HealthGuard/view/doctor_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class medicalCategoryCard extends StatelessWidget {

  final String imageName, text;

  medicalCategoryCard({this.imageName, this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 130,
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/medicalCategory/" + imageName,
            ),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                fontFamily: Constants.FONTSTYLE,
              ),
            ),
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorCategory(categoryName: text,)));
      },
    );
  }
}
