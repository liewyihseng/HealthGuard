import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'main.dart';
import 'valtool.dart';
import 'package:flutter/cupertino.dart';
import 'auth.dart';
import 'package:flutter/material.dart';
import 'User.dart';
import 'constants.dart' as Constants;
import 'User.dart' as OUser;

import 'dart:io';

// Define a custom Form widget.
class EmedicReport extends StatefulWidget {
  static const String id = "EmedicalReport";
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<EmedicReport> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("emediacal_reprot"),
      ),
      body: Container(
        child: Form(
            child: Column(
          children: [
            TextFormField(),
          ],
        )),
      ),
    );
  }
}
