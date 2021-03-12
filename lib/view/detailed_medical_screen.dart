import 'package:HealthGuard/model/user_medic_info_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

import '../main.dart';

class DetailedMedical extends StatelessWidget{
  final user_medic_info medicInfo;

  DetailedMedical({Key key, @required this.medicInfo}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Medical Information',
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Height: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.height,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Weight: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.weight,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Health Condition: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.healthCondition,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Current Medication: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.currentMedication,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Address: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.address,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Emergency Contact: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.emergencyContact,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Insurance ID: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.insuranceID,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Text(
                "Uploaded Date: ",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                medicInfo.uploadedDate,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: Constants.FONTSTYLE,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              scannedDoc(),
            ],
          ),

        ],
      ),
    );



  }

  Widget scannedDoc(){
    if(medicInfo.medicalReportImage != null) {
      return Column(
        children: <Widget>[
          Text(
            "Scanned Document: ",
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontFamily: Constants.FONTSTYLE,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: displayMedicalReport(medicInfo.medicalReportImage, false),
          ),

        ],
      );
    }else{
      return Container();
    }
  }

  Widget displayMedicalReport(String picUrl, hasBorder) =>
      CachedNetworkImage(
          imageBuilder: (context, imageProvider) => _getMedicalReportProvider(imageProvider, false),
          imageUrl: picUrl,
          placeholder: (context, url) => _getPlaceholderOrErrorImage(hasBorder),
          errorWidget: (context, url, error) => _getPlaceholderOrErrorImage(hasBorder),
      );

  Widget _getPlaceholderOrErrorImage(hasBorder) => Container(

    decoration: BoxDecoration(
      color: const Color(0xff7c94b6),
      border: new Border.all(
        color: Colors.white,
      ),
    ),
    child: ClipRect(
        child: Image.asset(
          'assets/img_not_available.jpg',
          fit: BoxFit.cover,

        )),
  );

  Widget _getMedicalReportProvider(
      ImageProvider provider, bool hasBorder) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
      ),
      child: ClipRect(
          child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: Image.asset(
                'assets/placeholder.jpg',
                fit: BoxFit.cover,
              ).image,
              image: provider)),
    );
  }
}


