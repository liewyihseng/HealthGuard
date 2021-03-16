import 'dart:ui';
import 'dart:io';

import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/model/user_model.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/helper/string_helper.dart';

import 'package:HealthGuard/main.dart';
import 'package:smart_select/smart_select.dart';
import 'doctor_home_screen.dart';

File _image;

/// Doctor Sign up screen page widget class
class DoctorSignUp extends StatefulWidget {
  static const String id = 'DoctorSignUp';
  @override
  State createState() => _doctorSignUpPageState();
}

/// Doctor Sign up screen page state class
class _doctorSignUpPageState extends State<DoctorSignUp> {
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String firstName,
      lastName,
      email,
      mobile,
      password,
      confirmPassword,
      sex,
      workplace,
      doctorID,
      aboutYourself,
      speciality;
  DateTime _dateTime;
  List gender = ["Male", "Female", "Other"];
  List<Map<String, dynamic>> specialityType = [
    {'title': 'Cardiologist', 'value': 'Cardiologist'},
    {'title': 'Gynaecologist', 'value': 'Gynaecologist'},
    {'title': 'CT-Scan', 'value': 'CT-Scan'},
    {'title': 'MRI-Scan', 'value': 'MRI-Scan'},
    {'title': 'Dentist', 'value': 'Dentist'},
    {'title': 'Dermatologist', 'value': 'Dermatologist'},
    {'title': 'Emergency', 'value': 'Emergency'},
    {'title': 'ENT', 'value': 'ENT'},
    {'title': 'Gastroenterologist', 'value': 'Gastroenterologist'},
    {'title': 'Hepatologist', 'value': 'Hepatologist'},
    {'title': 'Nephrologist', 'value': 'Nephrologist'},
    {'title': 'Neurologist', 'value': 'Neurologist'},
    {'title': 'Nutritionist', 'value': 'Nutritionist'},
    {'title': 'Obsterician', 'value': 'Obsterician'},
    {'title': 'Orthopaedic', 'value': 'Orthopaedic'},
    {'title': 'Pharmacist', 'value': 'Pharmacist'},
    {'title': 'Psychologist', 'value': 'Psychologist'},
    {'title': 'Surgeon', 'value': 'Surgeon'},
  ];

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
          'Register as Panel Doctor',
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
          ),
        ),
      ),
    );
  }

  /// Radio button to handle the input of gender of doctors
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: gender[btnValue],
          groupValue: sex,
          onChanged: (value) {
            setState(() {
              sex = value;
            });
          },
        ),
        Text(
          title,
          style: TextStyle(fontFamily: Constants.FONTSTYLE, fontSize: 13.0),
        )
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

  /// Allows doctors to take a picture or to import an image from the gallery
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
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            var image = await ImagePicker.pickImage(source: ImageSource.camera);
            setState(() {
              _image = image;
            });
          },
          child: null,
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

  Widget signupForm() {
    return new Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 8.0, top: 20, right: 8.0, bottom: 8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
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
                  splashColor: Constants.BUTTON_SPLASH_COLOUR,
                  onPressed: _onCameraClick,
                ),
              ),
            ],
          ),
        ),

        /// Field for doctor's first name input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              validator: validateName,
              onSaved: (String val) {
                firstName = val;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for doctor's last name input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              validator: validateName,
              onSaved: (String val) {
                lastName = val;
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Calendar for doctor's birthday input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: RaisedButton(
              child: Text(
                _dateTime == null ? 'Select Birthday' : Jiffy(_dateTime).yMMMMd,
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
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2050))
                    .then((date) {
                  setState(() {
                    _dateTime = date;
                  });
                });
              },
            ),
          ),
        ),

        /// Radio button for doctor's gender input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Container(
            padding: EdgeInsets.only(bottom: 1.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Gender* :',
                    style: TextStyle(
                        fontFamily: Constants.FONTSTYLE,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500)),
                addRadioButton(0, 'Male'),
                addRadioButton(1, 'Female'),
                addRadioButton(2, 'Others'),
              ],
            ),
          ),
        ),

        /// Field for doctor's mobile number input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              validator: validateMobile,
              onSaved: (String val) {
                mobile = val;
              },
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for doctor's workplace input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onSaved: (String val) {
                workplace = val;
              },
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Workplace',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for doctor's speciality input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child:
          SmartSelect<String>.single(
            title: 'Speciality',
            value: speciality,
            choiceItems: S2Choice.listFrom<String, Map>
              (source: specialityType,
              value: (index, item) => item['value'],
              title: (index, item) => item['title'],
            ),
            modalTitle: 'Speciality',
            modalType: S2ModalType.popupDialog,
            choiceType: S2ChoiceType.chips,
            choiceGrouped: true,
            choiceDirection: Axis.vertical,
            onChange: (selected) => setState(() => speciality = selected.value),
            tileBuilder: (context, state) => S2Tile.fromState(
              state,
              onTap: state.showModal,
            ),
          ),
        ),

        /// Field for doctor's about yourself input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onSaved: (String val) {
                aboutYourself = val;
              },
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'About Yourself',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for doctor's ID input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onSaved: (String val) {
                doctorID = val;
              },
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Doctor ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for doctor's email address input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              validator: validateEmail,
              onSaved: (String val) {
                email = val;
              },
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for doctor's password input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
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
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Field for doctor's confirm password input
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, right: 8.0, left: 8.0),
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
                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                fillColor: Colors.white,
                hintText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),

        /// Button for the doctor to sign up their account
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
              splashColor: Constants.BUTTON_SPLASH_COLOUR,
              onPressed: _sendToServer,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(color: Constants.BUTTON_COLOUR)),
            ),
          ),
        ),
      ],
    );
  }

  /// Handles the submission of data into the database
  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();

      /// Alert box to show the doctor's account creation is under progress
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

        ///Assigning all the user's input information to the user instance
        OurUser.User user = OurUser.User(
          email: email,
          firstName: firstName.capitalize(),
          lastName: lastName.capitalize(),
          phoneNumber: mobile,
          userID: result.user.uid,
          active: true,
          settings: Settings(allowPushNotifications: true),
          profilePictureURL: profilePicUrl,
          userType: "Doctor",
          aboutYourself: aboutYourself.capitalize(),
          doctorID: doctorID,
          workPlace: workplace.capitalize(),
          speciality: speciality,
          sex: sex,
          birthday: convertDateTimeDisplay(_dateTime.toString()),
          chattingWith: '',
        );

        await FireStoreUtils.firestore
            .collection(Constants.USERS)
            .doc(result.user.uid)
            .set(user.toJson());

        hideProgress();
        MyAppState.currentUser = user;
        pushAndRemoveUntil(context, DoctorHome(doctor: user), false);
      } catch (error) {
        hideProgress();
        (error as FirebaseException).code != 'ERROR_EMAIL_ALREADY_IN_USE'
            ? showAlertDialog(context, 'Failed', 'Couldn\'t sign up')
            : showAlertDialog(context, 'Failed',
                'Email already in user. Please pick another email address');
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
