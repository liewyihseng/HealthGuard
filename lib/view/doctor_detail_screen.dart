
import 'package:HealthGuard/chat/chatroom.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/model/doctor_model.dart' as OurDoctor;

/// Doctor detail screen page widget class
class DoctorDetail extends StatefulWidget{
  static const String id = "DoctorDetail";
  final OurDoctor.Doctor doctor;

  DoctorDetail({Key key, this.doctor}) : super(key: key);

  @override
  State createState() => _doctorDetailPageState(doctor);
}

/// Doctor detail screen page state class
class _doctorDetailPageState extends State<DoctorDetail>{
  final OurDoctor.Doctor doctor;

  _doctorDetailPageState(this.doctor);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: Text(
          'Doctor Detail',
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff54D579), Color(0xff00AABF)],
            begin: Alignment(0, -1.15),
            end: Alignment(0, 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.2715,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Image.asset('assets/docinfo/bg1.png'),
                /// To be altered to follow the category of each doctor
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Constants.BACKGROUND_COLOUR,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 8.0, right: 15.0, bottom: 10.0),
                            child: Container(

                              child: displayCircleImage(doctor.profilePictureURL, 100, false),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(doctor.fullNameDr(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),
                              Text(doctor.speciality + " - " + doctor.workPlace,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),

                              ///
                              /// Chat Now Button Here
                              /// And code to link to the chat now page should be inserted here
                              ///
                              RaisedButton(
                                color: Constants.BUTTON_COLOUR,
                                child: Text('Chat Now',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: Constants.FONTSTYLE,
                                  ),
                                ),
                                textColor: Colors.white,
                                splashColor: Colors.blue,
                                onPressed: ()  {
                                  /// Navigate to chat page
                                  Navigator.pushNamed(context, Chatroom.id);
                                },
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  side: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13, right: 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("About the Doctor",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: Constants.FONTSTYLE,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(doctor.aboutYourself,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: Constants.FONTSTYLE,
                              ),
                            ),

                            SizedBox(height: 20),

                            Text("Available Time Slots",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                fontFamily: Constants.FONTSTYLE,
                              ),
                            ),

                            SizedBox(height: 10),
                            /// To be deleted soon
                            timeSlotWidget("13", "MAY", "Consultation", "Sunday 9 am to 11.30 am"),
                            timeSlotWidget("14", "MAY", "Consultation", "Monday 10 am to 12.30 am"),
                            timeSlotWidget("1", "JUN", "Consultation", "Wednesday 8 am to 12.30 pm"),
                            timeSlotWidget("3", "JUN", "Consultation", "Friday 8 am to 1 am"),

                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Change to some other things next time
  Container timeSlotWidget(String date, String month, String slotType, String time)
  {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xffECF0F5),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Container(
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xffD5E0FA),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("$date",
                    style: TextStyle(
                      color: Color(0xff3479C0),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: Constants.FONTSTYLE,
                    ),
                  ),
                  Text("$month",
                    style: TextStyle(
                      color: Color(0xff3479C0),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: Constants.FONTSTYLE,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$slotType",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: Constants.FONTSTYLE,
                  ),
                ),
                Text("$time",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: Constants.FONTSTYLE,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

