import 'dart:ui';
import 'dart:io';

import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:HealthGuard/model/user_model.dart';
import 'package:HealthGuard/view/pedometer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:HealthGuard/home.dart';
import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:intl/intl.dart';

import 'package:jiffy/jiffy.dart';

File _image;



/// Sign up screen page widget class
class signup_page extends StatefulWidget {
  @override
  State createState() => _signupPageState();
}



/// Sign up screen page state class
class _signupPageState extends State<signup_page> {
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String firstName, lastName, email, mobile, password, confirmPassword, sex;
  DateTime _dateTime;
  List gender = ["Male", "Female", "Other"];


  /// build
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Create new account',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
            fontFamily: Constants.FONTSTYLE,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.blue),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: new Form(
            key: _key,
            autovalidate: _validate,
            child: signupForm(),
            /// Calling sign up form
          ),
        ),
      ),
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: sex,
          onChanged: (value){
            setState(() {
              sex = value;
            });
          },
        ),
        Text(title, style: TextStyle(fontFamily: Constants.FONTSTYLE, fontSize: 13.0),)
      ],
    );
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = response.file;
      });
    }
  }

  /// Serving the user after user clicked on the button to add profile picture
  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            var image =
            await ImagePicker.pickImage(source: ImageSource.gallery);
            setState(() {
              _image = image;
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            var image = await ImagePicker.pickImage(source: ImageSource.camera);
            setState(() {
              _image = image;
            });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  /// Sign up form
  Widget signupForm() {
    return new Column(
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 8.0, top: 20, right: 8.0, bottom: 8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              /// Circle to hold user profile picture
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade400,
                child: ClipOval(
                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: _image == null
                        ? Image.asset(
                      'assets/placeholder.jpg',
                      fit: BoxFit.cover,
                    )
                        : Image.file(
                      _image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 80,
                right: 0,
                child: FloatingActionButton(
                    backgroundColor: Constants.BUTTON_COLOUR,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    mini: true,
                    splashColor: Colors.blue,
                    onPressed: _onCameraClick),
              )
            ],
          ),
        ),

        /// Field for user's first name input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              validator: validateName,
              onSaved: (String val) {
                firstName = val;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for user's last name input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              validator: validateName,
              onSaved: (String val) {
                lastName = val;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Calendar for user's birthday input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: RaisedButton(
              child: Text(_dateTime == null? 'Select Birthday': Jiffy(_dateTime).yMMMMd,
                style: TextStyle(
                  fontFamily: Constants.FONTSTYLE,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              color: Constants.BUTTON_COLOUR,
              textColor: Colors.white,
              splashColor: Colors.blue,
              padding: EdgeInsets.all(10),
              onPressed: (){
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2050)
                ).then((date){
                  setState((){
                    _dateTime = date;
                  });
                });
              },
            ),
          ),
        ),

        /// Radio button for user's gender input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Container(
            padding: EdgeInsets.only(bottom: 1.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Gender* :', style: TextStyle(fontFamily: Constants.FONTSTYLE, fontSize: 15.0, fontWeight: FontWeight.w500)),
                addRadioButton(0, 'Male'),
                addRadioButton(1, 'Female'),
                addRadioButton(2, 'Others'),
              ],
            ),
          ),
        ),

        /// Field for user's mobile number input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              validator: validateMobile,
              onSaved: (String val) {
                mobile = val;
              },
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for user's email address input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              validator: validateEmail,
              onSaved: (String val) {
                email = val;
              },
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for user's password input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              obscureText: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              controller: _passwordController,
              validator: validatePassword,
              onSaved: (String val) {
                password = val;
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for user's confirm password input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                _sendToServer();
              },
              obscureText: true,
              validator: (val) =>
                  validateConfirmPassword(_passwordController.text, val),
              onSaved: (String val) {
                confirmPassword = val;
              },
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding:
                new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),
        /// Button to press after user has finished filling in their account information
        Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: double.infinity),
            child: RaisedButton(
              color: Constants.BUTTON_COLOUR,
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: Constants.FONTSTYLE,
                ),
              ),
              textColor: Colors.white,
              splashColor: Colors.blue,
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Colors.blue)),
            ),
          ),
        ),
      ],
    );
  }

  /// Sending user input information to server (firebase)
  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      /// Alert box to show the user's account creation is under progress
      showProgress(context, 'Creating new account...', false);
      var profilePicUrl =
          'https://firebasestorage.googleapis.com/v0/b/healthguard-2c4ac.appspot.com/o/images%2Fplaceholder.jpg?alt=media&token=158e23bd-54ed-425e-bac5-c4694214bb3c';
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (_image != null) {
          updateProgress('Uploading image...');
          profilePicUrl = await FireStoreUtils()
              .uploadUserImageToFireStorage(_image, result.user.uid);
        }

        await result.user.sendEmailVerification();

        /// Assigning all the user's input information to the user instance
        OurUser.User user = OurUser.User(
          email: email,
          firstName: firstName,
          phoneNumber: mobile,
          userID: result.user.uid,
          active: true,
          lastName: lastName,
          settings: Settings(allowPushNotifications: true),
          profilePictureURL: profilePicUrl,
          userType: "Patient",
          sex: sex,
          birthday: convertDateTimeDisplay(_dateTime.toString()),
          ///This page by default will allow users to create only patient account
        );

        await FireStoreUtils.firestore
            .collection(Constants.USERS)
            .doc(result.user.uid)
            .collection(Constants.ACC_INFO)
            .add(user.toJson());

        // init pedometer essential skeleton
        PedometerData pedometerSkeleton = PedometerData();
        await FireStoreUtils.firestore
            .collection(Constants.USERS)
            .doc(result.user.uid)
            .collection(Constants.PEDOMETER_INFO)
            .doc(PedometerScreen.documentID)
            .set(pedometerSkeleton.toJson());

        hideProgress();
        MyAppState.currentUser = user;
        pushAndRemoveUntil(context, home(), false);
      } catch (error) {
        hideProgress();
        (error as FirebaseException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'Failed', 'Couldn\'t sign up')
            : showAlertDialog(context, 'Failed',
            'Email already in use. Please pick another email address');
        print(error.toString());
      }
    } else {
      print('false');
      setState(() {
        _validate = true;
      });
    }
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
