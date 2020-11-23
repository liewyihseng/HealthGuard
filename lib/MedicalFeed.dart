import 'package:flutter/material.dart';

import 'Article.dart';

class MedicalFeed extends StatelessWidget {
  static const String id = "MedicalFeedPage";
  const MedicalFeed({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Article"),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Article();
        },
      ),
    );
  }
}
