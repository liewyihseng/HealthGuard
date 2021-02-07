import 'dart:io';
import 'package:HealthGuard/chat/database.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:firebase_auth/firebase_auth.dart';

class Chatroom extends StatefulWidget {
  @override
  _ChatroomState createState() => _ChatroomState();
  static const String id = "Chatroom";
}

class _ChatroomState extends State<Chatroom> {
  ///variable
  bool isSearching = false;
  Stream usersStream;
  TextEditingController searchUsernameEditingController =
      TextEditingController();

  onSearchBtnClick() async {
    isSearching = true;
    usersStream = await DatabaseMethods()
        .getUserByName(searchUsernameEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Chatroom',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
            fontFamily: Constants.FONTSTYLE,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                isSearching
                    ? GestureDetector(
                        onTap: () {
                          isSearching = false;
                          searchUsernameEditingController.text = "";
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(Icons.arrow_back)),
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
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: searchUsernameEditingController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "username"),
                        )),
                        GestureDetector(
                            onTap: () {
                              if (searchUsernameEditingController.text != "") {
                                onSearchBtnClick();
                              }
                            },
                            child: Icon(Icons.search))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // }
// }

// class Chatroom extends StatefulWidget {
//   @override
//   _RoomState createState() => _RoomState();

// }

// class _RoomState extends State<Chatroom> {
//   bool isSearching = false;

//   Stream usersStream;

//   TextEditingController searchUsernameEditingController =
//       TextEditingController();

//   onSearchBtnClick() async {
//     isSearching = true;
//     usersStream = await DatabaseMethods()
//         .getUserByName(searchUsernameEditingController.text);

//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text("chatroom"),
//           actions: [],
//         ),
//         body: Container(
//           margin: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   isSearching
//                       ? GestureDetector(
//                           onTap: () {
//                             isSearching = false;
//                             searchUsernameEditingController.text = "";
//                           },
//                           child: Padding(
//                               padding: EdgeInsets.only(right: 12),
//                               child: Icon(Icons.arrow_back)),
//                         )
//                       : Container(),
//                   Expanded(
//                     child: Container(
//                       margin: EdgeInsets.symmetric(vertical: 16),
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                               color: Colors.grey,
//                               width: 1,
//                               style: BorderStyle.solid),
//                           borderRadius: BorderRadius.circular(24)),
//                       child: Row(
//                         children: [
//                           Expanded(
//                               child: TextField(
//                             controller: searchUsernameEditingController,
//                             decoration: InputDecoration(
//                                 border: InputBorder.none, hintText: "username"),
//                           )),
//                           GestureDetector(
//                               onTap: () {
//                                 if (searchUsernameEditingController.text !=
//                                     "") {
//                                   onSearchBtnClick();
//                                 }
//                               },
//                               child: Icon(Icons.search))
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     }

    // throw UnimplementedError();
  }
}
