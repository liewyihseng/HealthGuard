import 'package:HealthGuard/helper/shared_preferences_services.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatwithdoctorname, name;
  ChatScreen(this.chatwithdoctorname, this.name);
  @override
  _ChatScreenState _chatScreenState() => _chatScreenState();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  String chatID, messageId = "";
  String myName, myProfilePic, myUserName, myEmail;

  getMyinfomation() async {
    myName = await SharedPrefService().getdisplayname();
    myProfilePic = await SharedPrefService().getUserprofile();
    myUserName = await SharedPrefService().getUserName();
    myEmail = await SharedPrefService().getUserEmail();

    chatID = getchatIDbyusername(widget.chatwithdoctorname, myUserName);
  }

  getchatIDbyusername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a/_$b";
    }
  }

  getAndsetMessages() async {}

  @override
  void iniState() {
    dothisonlaunch();
    super.initState();
  }

  dothisonlaunch() async {
    await getMyinfomation();
    getAndsetMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
    );
  }
}
