import 'dart:ffi';
import 'dart:ui';

import 'package:HealthGuard/chat/chatroom.dart';
import 'package:HealthGuard/view/doctor_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

import '../chat/database.dart';

/// Find doctor screen page widget class
class FindDoctor extends StatefulWidget {
  static const String id = "FindDoctor";
  @override
  State createState() => _findDoctorsPageState();
}

bool isSearching = false;

/// Find doctor screen page state class
class _findDoctorsPageState extends State<FindDoctor> {
  bool isSearching = false;
  Stream usersStream;
  TextEditingController searchUsernameEditingController =
      TextEditingController();

  onSearchBtnClick() async {
    isSearching = true;
    usersStream = await DatabaseMethods()
        .getUserByFirstName(searchUsernameEditingController.text);
    setState(() {});
    Navigator.pushNamed(context, Chatroom.id);
  }

  Widget searchuserlist(String profilePictureURL, firstName, lastName) {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(ds["profilePitureURL"]),
                    )
                  ]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.BACKGROUND_COLOUR,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: pathPainter(),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBar(
                  title: Text(
                    'Find a doctor',
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
                Padding(
                  padding: EdgeInsets.only(left: 14, right: 14, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.FONTSTYLE,
                        ),
                      ),

                      SizedBox(height: 10),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            medicalCategoryContainer(
                                "category7.png", "CT-Scan"),
                            medicalCategoryContainer("category1.png", "Ortho"),
                            medicalCategoryContainer(
                                "category2.png", "Dietician"),
                            medicalCategoryContainer(
                                "category3.png", "Physician"),
                            medicalCategoryContainer(
                                "category4.png", "Paralysis"),
                            medicalCategoryContainer(
                                "category5.png", "Cardiology"),
                            medicalCategoryContainer(
                                "category6.png", "MRI - Scan"),
                            medicalCategoryContainer(
                                "category8.png", "Gynaecology"),
                          ],
                        ),
                      ),
                      Text(
                        "Doctors",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.FONTSTYLE,
                        ),
                      ),

                      /// Zi Jie Your code here
                      ///
                      ///
                      ///
                      ///
                      ///
                      ///
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(children: [
                              isSearching
                                  ? GestureDetector(
                                      onTap: () {
                                        isSearching = false;
                                        searchUsernameEditingController.text =
                                            "";
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 12),
                                        child: Icon(Icons.arrow_back),
                                      ),
                                    )
                                  : Container(),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 16),
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              searchUsernameEditingController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Doctor's name",
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            if (searchUsernameEditingController
                                                    .text !=
                                                "") {
                                              onSearchBtnClick();
                                            }
                                          },
                                          child: Icon(Icons.search)),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),

                      Container(
                        height: 398,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              createDoctorWidget("doc1.png", "Susan Thomas"),
                              createDoctorWidget("doc2.png", "Paul Barbara"),
                              createDoctorWidget("doc3.png", "Nancy Williams"),
                              createDoctorWidget("doc1.png", "Susan Thomas"),
                              createDoctorWidget("doc2.png", "Paul Barbara"),
                              createDoctorWidget("doc3.png", "Nancy Williams"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container medicalCategoryContainer(String imgName, String title) {
    return Container(
      width: 130,
      child: Column(
        children: <Widget>[
          Image.asset('assets/medicalCategory/$imgName'),
          Text(
            "$title",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
              fontFamily: Constants.FONTSTYLE,
            ),
          ),
        ],
      ),
    );
  }

  Container createDoctorWidget(String imgName, String docName) {
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
                Container(
                  width: 70,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/docprofile/$imgName'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dr. $docName",
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
                        "A brief about the doctor to be added here. This is more liek an introduction about the doctor.",
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

class pathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.color = Color(0xffcef4e8);

    Path path = new Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.03,
        size.width * 0.42, size.height * 0.17);
    path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.32, 0, size.height * 0.29);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
