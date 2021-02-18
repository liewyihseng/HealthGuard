import 'package:HealthGuard/widgets/medical_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// User's medical information screen page widget class
class MyMedical extends StatefulWidget {
  static const String id = "MyMedicalPage";
  const MyMedical({Key key}) : super(key: key);
  @override
  _MyMedicalState createState() => _MyMedicalState();
}

/// User's medical information screen page state class
class _MyMedicalState extends State<MyMedical> {
  final db = FirebaseFirestore.instance;

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
      body: Container(
        alignment: Alignment.topCenter,
        child: StreamBuilder<QuerySnapshot>(
          /// Creating a stream connecting to the database (collection is to access the collection, doc is to access the document within the collection)
            stream: db
                .collection(Constants.USERS)
                .doc(MyAppState.currentUser.userID)
                .collection(Constants.MED_INFO)
                .snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Container();
              }else if(snapshot.data.size == 0){
                return Container( color: Color(0xFFF6F8FC),
                  child: Center(
                    child:  Text(
                      'Nothing to be shown',
                      style: TextStyle(
                          fontSize: 24,
                          color: Constants.TEXT_SUPER_LIGHT,
                          fontFamily: Constants.FONTSTYLE,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }else{
                var doc = snapshot.data.documents;
                return new ListView.builder(
                  shrinkWrap: true,
                  itemCount: doc.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index){
                    return Container(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          MedicalCard(
                              height: doc[index].get("height"),
                              weight: doc[index].get("weight"),
                              birthday: doc[index].get("birthday"),
                              healthCondition: doc[index].get("healthCondition"),
                              currentMedication: doc[index].get("currentMedication"),
                              address: doc[index].get("address"),
                              emergencyContact: doc[index].get("emergencyContact"),
                              insuranceID: doc[index].get("insuranceID"),
                            uploadedDate: doc[index].get("uploadedDate"),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
