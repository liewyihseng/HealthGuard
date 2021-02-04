
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

import 'package:HealthGuard/main.dart';

class MedicineDetail extends StatefulWidget{
  static const String id = "MedicineDetailPage";
  const MedicineDetail({Key key}) : super(key: key);
  @override
  _MedicineDetailState createState() => _MedicineDetailState();
}

class _MedicineDetailState extends State<MedicineDetail> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medicine Detail',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),

      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: db.collection(Constants.USERS).doc(
              MyAppState.currentUser.userID).collection(
              Constants.MEDICATION_INFO).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data.size == 0) {
              return Container(color: Color(0xFFF6F8FC),
                child: Center(
                  child: Text(
                    "Nothing to be shown",
                    style: TextStyle(
                        fontSize: 24,
                        color: Constants.TEXT_LIGHT,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              );
            } else {
              var doc = snapshot.data.documents;
              return new ListView.builder(
                  shrinkWrap: true,
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 135,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          Text(doc[index].get("medicineName"),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontSize: 15,
                            ),
                          ),

                          Text(doc[index].get("medicineType"),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontSize: 15,
                            ),
                          ),

                          Text(doc[index].get("startTime"),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontSize: 15,
                            ),
                          ),

                          Text(doc[index].get("dosage"),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontSize: 15,
                            ),
                          ),

                          Text(doc[index].get("interval").toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
          },
        ),
      ),
    );
  }
}