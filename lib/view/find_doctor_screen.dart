import 'dart:ui';

import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/view/doctor_detail_screen.dart';
import 'package:HealthGuard/widgets/doctor_card.dart';
import 'package:HealthGuard/widgets/medicalCategoryCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

import 'package:HealthGuard/chat/database.dart';

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
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserByFirstName(searchUsernameEditingController.text);
    setState(() {});
  }

  onBackArrowClick() async {
    isSearching = false;
    searchUsernameEditingController.text = "";
    setState(() {});
  }

  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return searchListUserTile(
                profilePictureURL: ds["profilePictureURL"],
                firstName: ds["firstName"],
                email: ds["email"],
                userstate: ds["active"]);
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget searchListUserTile(
      {String profilePictureURL, firstName, userstate, email}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, DoctorDetail.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profilePictureURL,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(firstName), Text(email)])
          ],
        ),
      ),
    );
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
                  padding: EdgeInsets.only(left: 20, right: 20, top: 25),
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

                            medicalCategoryCard(
                                imageName:
                                "category5.png",
                                text: "Cardiologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "category8.png",
                                text: "Gynaecologist"
                            ),

                            medicalCategoryCard(
                              imageName: "category7.png",
                              text: "CT-Scan",
                            ),

                            medicalCategoryCard(
                                imageName: "category1.png",
                                text: "Ortho"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "category2.png",
                                text: "Dietician"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "category3.png",
                                text: "Physician"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "category4.png",
                                text: "Paralysis"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "category6.png",
                                text: "MRI - Scan"
                            ),

                          ],
                        ),
                      ),
                      Text(
                        "All Doctors",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.FONTSTYLE,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(children: [
                              isSearching
                                  ? GestureDetector(
                                onTap: () {
                                  onBackArrowClick();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_back),
                                ),
                              )
                                  : Container(),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 16.0),
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
                      isSearching ? searchUsersList() : recommendDoctors()
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

  /// Container to display all the doctors available in our database
  Container recommendDoctors() {
    final db = FirebaseFirestore.instance;
    return Container(
      height: 398,
      child: StreamBuilder<QuerySnapshot>(
        stream: db.collection(Constants.USERS).where("userType", isEqualTo: "Doctor").snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Container();
          }else if(snapshot.data.size == 0){
            return Container(color: Color(0xFFF6F8FC),
              child: Center(
                child: Text(
                  'No Doctors available',
                  style: TextStyle(
                    fontSize: 24,
                    color: Constants.TEXT_SUPER_LIGHT,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }else{
            var doc = snapshot.data.documents;
            return new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: doc.length,
              itemBuilder: (context, index){
                return Container(
                  child: DoctorCard(
                    doctor: new OurUser.User(
                      email: doc[index].get("email"),
                      firstName: doc[index].get("firstName"),
                      lastName: doc[index].get("lastName"),
                      active: doc[index].get("active"),
                      lastOnlineTimestamp: doc[index].get("lastOnlineTimestamp"),
                      settings: null,
                      phoneNumber: doc[index].get("phoneNumber"),
                      userID: doc[index].get("id"),
                      profilePictureURL: doc[index].get("profilePictureURL"),
                      userType: doc[index].get("userType"),
                      sex: doc[index].get("sex"),
                      birthday: doc[index].get("birthday"),
                      workPlace: doc[index].get("workPlace"),
                      speciality: doc[index].get("speciality"),
                      aboutYourself: doc[index].get("aboutYourself"),
                      doctorID: doc[index].get("doctorID"),
                    ),),
                );
              },
            );
          }
        },
      ),
    );
  }

}


/// For UI purposes
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
