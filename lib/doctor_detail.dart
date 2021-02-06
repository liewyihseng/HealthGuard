
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// Doctor detail screen page widget class
class DoctorDetail extends StatefulWidget{
  static const String id = "DoctorDetail";
  @override
  State createState() => _doctorDetailPageState();
}

/// Doctor detail screen page state class
class _doctorDetailPageState extends State<DoctorDetail>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title: Text(
          'Doctor Detail',
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,),
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
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.asset('assets/docprofile/doc1.png'),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Dr. Susan Thomas",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              Text("Heart Surgeon - CK Hospital",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("About the Doctor",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text("Please write the description of the doctor here. This will be a detailed information about the doctor and the roles and achievements that the doctor has had over the past years", style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            ),
                            SizedBox(height: 10,),
                            Text("Available Time Slots",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 5,),
                            timeSlotWidget("13", "MAY", "Consultation", "Sunday 9 am to 11.30 am"),
                            timeSlotWidget("14", "MAY", "Consultation", "Monday 10 am to 12.30 am"),
                            timeSlotWidget("1", "JUN", "Consultation", "Wednesday 8 am to 12.30 pm"),
                            timeSlotWidget("3", "JUN", "Consultation", "Friday 8 am to 1 am"),

                            SizedBox(height: 10),

                            ///Chat now button here
                            ///
                            ///
                            ///
                            ///
                            ///
                            ///
                            ///
                            ///
                            ///
                            ///

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
                        fontSize: 30,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  Text("$month",
                    style: TextStyle(
                        color: Color(0xff3479C0),
                        fontSize: 20,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$slotType",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text("$time",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600
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

