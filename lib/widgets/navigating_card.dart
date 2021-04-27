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
  }
}
