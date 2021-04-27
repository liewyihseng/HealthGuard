import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class DrawerListTile extends StatelessWidget {
  final String text;
  final Widget icon;
  final Function onTap;

  DrawerListTile({@required this.text,@required this.icon, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: FontWeight.w900),
      ),
      leading: icon,
      onTap: onTap,
    );
  }
}
