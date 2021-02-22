import 'package:HealthGuard/widgets/text_icon_card.dart';
import 'package:flutter/material.dart';

class NavigatingCard extends StatelessWidget {

  final String imageName, text, screenID;

  NavigatingCard({this.imageName, this.text, this.screenID});

  @override
  Widget build(BuildContext context) {
    return TextIconCard(
        text: text,
        imageName: imageName,
        onTap: () {
          Navigator.pushNamed(context, screenID);
        });
    // return GestureDetector(
    //     child: Card(
    //       elevation: 3.0,
    //       margin: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
    //       child: Container(
    //         padding: EdgeInsets.all(5),
    //         child: Column(
    //           children: <Widget>[
    //             Image.asset(
    //               imageName,
    //               alignment: Alignment.center,
    //               width: 30.0,
    //               height: 30.0,
    //             ),
    //             Padding(
    //               padding: EdgeInsets.all(13.0),
    //               child: Text(
    //                 text,
    //                 style: TextStyle(
    //                   fontSize: 20.0,
    //                   color: Colors.black,
    //                   fontFamily: Constants.FONTSTYLE,
    //                   fontWeight: FontWeight.w600,
    //                 ),
    //                 textAlign: TextAlign.center,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     onTap: () {
    //       Navigator.pushNamed(context, screenID);
    //     });
  }
}
