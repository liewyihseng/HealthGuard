
import 'dart:io';

import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/home.dart';
import 'package:HealthGuard/model/user_medic_info_model.dart' as medic_info;
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';



/// Medical report screen page widget class
class EMedicalReport extends StatefulWidget{
  static const String id = "EMedicalReport";
  @override
  State createState() => _medicalPageState();
}

/// Medical Report screen page state class
class _medicalPageState extends State<EMedicalReport> {
  String height, weight, birthday, sex, healthCondition, currentMedication,
      address, emergencyContact, insuranceID;
  bool _validate = false;
  File _image;
  StorageReference storage = FirebaseStorage.instance.ref();


  GlobalKey<FormState> _key = new GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'E-Medical Report',
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: medicalReportForm(),

              /// Calling medical report form
            ),
          )
      ),
    );
  }

  /// Medical report form
  Widget medicalReportForm() {
    return new Column(
      children: <Widget>[

        /// Field for user's height input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  validator: validateHeight,
                  onSaved: (String val) {
                    setState(() {
                      height = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(
                          20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Height',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// Field for user's weight input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  validator: validateWeight,
                  onSaved: (String val) {
                    setState(() {
                      weight = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(
                          20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Weight',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// Field for user's health condition input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  validator: validateHealthCondition,
                  onSaved: (String val) {
                    setState(() {
                      healthCondition = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(
                          20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Health Condition',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// Field for user's current medication input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  validator: validateCurrentMedication,
                  onSaved: (String val) {
                    setState(() {
                      currentMedication = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(
                          20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Current Medication',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// Field for user's address input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  validator: validateAddress,
                  onSaved: (String val) {
                    setState(() {
                      address = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(
                          20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// Field for user's emergency contact input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  validator: validateMobile,
                  onSaved: (String val) {
                    setState(() {
                      emergencyContact = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(
                          20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Emergency Contact',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// Field for user's Insurance Id input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                  validator: validateInsurance,
                  onSaved: (String val) {
                    setState(() {
                      insuranceID = val;
                    });
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                      contentPadding: new EdgeInsets.fromLTRB(
                          20.0, 15.0, 20.0, 15.0),
                      fillColor: Colors.white,
                      hintText: 'Insurance ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      )
                  )
              )
          ),
        ),

        /// To handle submission of Medical Report in the form of an image
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
              child: RaisedButton(
                  child: Text(
                    'Submit your medical report?',
                    style: TextStyle(
                      fontFamily: Constants.FONTSTYLE,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  color: Constants.BUTTON_COLOUR,
                  textColor: Colors.white,
                  splashColor: Constants.BUTTON_SPLASH_COLOUR,
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPopupDialog(context),
                      );
                  }),
            ),
          ),
        ),


        /// Button to press after user has finished filling in their medical information
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              color: Constants.BUTTON_COLOUR,
              child: Text('Submit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: Constants.FONTSTYLE,),
              ),
              textColor: Colors.white,
              splashColor: Constants.BUTTON_SPLASH_COLOUR,
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Constants.BUTTON_COLOUR)
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Pop up dialog to ask if users want to scan or upload their medical report
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
        backgroundColor: Constants.BACKGROUND_COLOUR,
        title:  Text(
          'Select an option',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Constants.TEXT_DARK,
              fontFamily: Constants.FONTSTYLE,
              fontWeight: FontWeight.w900),
        ),
        content: Container(
          height: 150,
            width: 150,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity),
                    child: RaisedButton(
                      color: Constants.BUTTON_COLOUR,
                      child: Text('Scan report',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: Constants.FONTSTYLE,),
                      ),
                      textColor: Colors.white,
                      splashColor: Constants.BUTTON_SPLASH_COLOUR,
                      onPressed: _imgFromCamera,
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Constants.BUTTON_COLOUR)
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: double.infinity),
                    child: RaisedButton(
                      color: Constants.BUTTON_COLOUR,
                      child: Text('Import from gallery',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: Constants.FONTSTYLE,),
                      ),
                      textColor: Colors.white,
                      splashColor: Constants.BUTTON_SPLASH_COLOUR,
                      onPressed: _imageFromGallery,
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Constants.BUTTON_COLOUR)
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
    );

  }

  /// Method to upload the image into the database (Firestore)
  Future<String> uploadImageToFireStorage(File image, String userID) async {
    StorageReference upload = storage.child("medicalReport/$userID" + DateTime.now().toString() +".png");
    StorageUploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  /// Sending user's medical information to server (firebase)
  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, "Processing Submission", false);
      var medicalReportImage;
      if(_image != null){
        medicalReportImage = await uploadImageToFireStorage(_image, MyAppState.currentUser.userID);
      }

      /// Assigning all the user's input medical information to the user_medic_info instance
      medic_info.user_medic_info user_medic_info = medic_info.user_medic_info(
        height: height,
        weight: weight,
        healthCondition: healthCondition,
        currentMedication: currentMedication,
        address: address,
        emergencyContact: emergencyContact,
        insuranceID: insuranceID,
        uploadedDate: convertDateTimeDisplay(DateTime.now().toString()),
        medicalReportImage: medicalReportImage,

      );

      await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .doc(MyAppState.currentUser.userID)
          .collection(Constants.MED_INFO)
          .add(user_medic_info.toJson());
      hideProgress();
      pushAndRemoveUntil(context, home(), false);
    } else {
      print('false');
      setState(() {
        _validate = true;
      });
    }
  }

  /// Handles the image from the camera when users want to take a picture
  _imgFromCamera() async{
    File image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  /// Handles the selection of images from the gallery
  _imageFromGallery() async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  /// Converting dateTime that shows hours: minutes: seconds to date only
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormatter.parse(date);
    final String formatted = serverFormatter.format(displayDate);
    return formatted;
  }
}
