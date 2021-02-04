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
      appBar: AppBar(
        title: Text(
          'Medical Information',
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w900),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(

          /// Creating a stream connecting to the database (collection is to access the collection, doc is to access the document within the collection)
          stream: db
              .collection(Constants.USERS)
              .doc(MyAppState.currentUser.userID)
              .collection(Constants.MED_INFO)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var doc = snapshot.data.documents;
              return new ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        /// Birthday
                        Text(
                          doc[index].get("birthday"),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                          ),
                        ),

                        /// Sex
                        Text(
                          doc[index].get("sex"),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                          ),
                        ),

                        /// Height
                        Text(
                          doc[index].get("height"),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                          ),
                        ),

                        /// Weight
                        Text(
                          doc[index].get("weight"),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                          ),
                        ),

                        /// Current Medication
                        Text(
                          doc[index].get("currentMedication"),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                          ),
                        ),

                        /// Address
                        Text(
                          doc[index].get("address"),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                          ),
                        ),

                        /// Health Condition
                        Text(
                          doc[index].get("healthCondition"),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: 15,
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return Column(
                children: <Widget>[
                  LinearProgressIndicator(),
                  Text(
                    "Nothing To Show",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
