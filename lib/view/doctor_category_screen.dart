import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/widgets/doctor_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class DoctorCategory extends StatefulWidget{

  final String categoryName;

  const DoctorCategory({Key key, @required this.categoryName}) : super(key: key);

  @override
  _DoctorCategoryState createState() => _DoctorCategoryState(categoryName);
}

class _DoctorCategoryState extends State<DoctorCategory>{

  final String categoryName;
  final db = FirebaseFirestore.instance;
  _DoctorCategoryState(this.categoryName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          categoryName,
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: Container(
              /// Connecting to the database
              child: StreamBuilder<QuerySnapshot>(
                /// Query to filter
                stream: db.collection(Constants.USERS)
                    .where("userType", isEqualTo: "Doctor")
                    .where("speciality", isEqualTo: categoryName)
                    .snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Container();
                  }else if(snapshot.data.size == 0){
                    return Container(color: Color(0xFFF6F8FC),
                      child: Center(
                        /// If there are no doctors available
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
                    /// If there are doctors available
                    var doc = snapshot.data.documents;
                    return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: doc.length,
                      itemBuilder: (context, index){
                        return Container(
                          child: DoctorCard(
                            /// Creating new doctor instances
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
            ),
          ),
        ],
      ),
    );
  }

}