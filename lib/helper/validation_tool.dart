import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

/// Validate if name contains invalid characters or null input
String validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Name is required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

/// Validate if mobile number contains invalid characters or null input
String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Mobile phone number is required";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile phone number must contain only digits";
  }
  return null;
}

/// Validate if password contains insufficient number of characters
String validatePassword(String value) {
  if (value.length < 8)
    return 'Password must be more than 8 alphanumerical characters';
  else
    return null;
}

/// Validate if email contains invalid characters or symbols
String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter a valid email address';
  else
    return null;
}

/// Validate if both the password and confirm password input by users are the same
String validateConfirmPassword(String password, String confirmPassword) {
  print("$password $confirmPassword");
  if (password != confirmPassword) {
    return 'Password doesn\'t match';
  } else if (confirmPassword.length == 0) {
    return 'Confirm password is required';
  } else {
    return null;
  }
}

/// Validate if the height contains only integers
String validateHeight(String value){
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if(value.length == 0){
    return "Height is required";
  }else if(!regExp.hasMatch(value)){
    return "Height must contain only digits";
  }
  return null;
}

/// Validate if the weight contains only integers
String validateWeight(String value){
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if(value.length == 0){
    return "Weight is required";
  }else if(!regExp.hasMatch(value)){
    return "Weight must contain only digits";
  }
  return null;
}

/// Validate if the health condition is empty
String validateHealthCondition(String value){
  if(value.length == 0){
    return "Health Condition is required";
  }
  return null;
}

/// Validate if the current medication is empty
String validateCurrentMedication(String value){
  if(value.length == 0){
    return "Current Medication is required";
  }
  return null;
}

/// Validate if the address is empty
String validateAddress(String value){
  if(value.length == 0){
    return "Address is required";
  }
  return null;
}

/// Validate if the insurance id is empty
String validateInsurance(String value){
  if(value.length == 0){
    return "Insurance ID is required";
  }
  return null;
}

/// Validate if the medication name is empty
String validateMedicationName(String value){
  if(value.length == 0){
    return "Medication Name is required";
  }
  return null;
}

/// Validate if the medication name is empty
String validateDosage(String value){
  if(value.length == 0){
    return "Dosage is required";
  }else if(int.parse(value) > 10000){
    return "This Dosage is too large";
  }
  return null;
}

/// Validate if the systolic is empty
String validateSystolic(String value){
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if(value.length == 0){
    return "Systolic is required";
  }else if (!regExp.hasMatch(value)) {
    return "Systolic must contain only digits";
  }
  return null;
}

/// Validate if the diastolic is empty
String validateDiastolic(String value){
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if(value.length == 0){
    return "Diastolic is required";
  }else if (!regExp.hasMatch(value)) {
    return "Diastolic must contain only digits";
  }
  return null;
}

/// Validate if the Pulse is empty
String validatePulse(String value){
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if(value.length == 0){
    return "Pulse is required";
  }else if (!regExp.hasMatch(value)) {
    return "Pulse must contain only digits";
  }
  return null;
}

/// validate int number
String numberValidator(String value) {
  if(value == null) {
    return 'input cannot be empty';
  }
  final n = num.tryParse(value);
  if(n == null) {
    return '"$value" is not a valid number';
  }
  return null;
}

ProgressDialog progressDialog;

showProgress(BuildContext context, String message, bool isDismissible) async {
  progressDialog = new ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  progressDialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          )),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
  await progressDialog.show();
}

updateProgress(String message) {
  progressDialog.update(message: message);
}

hideProgress() async {
  await progressDialog.hide();
}

///helper method to show alert dialog
showAlertDialog(BuildContext context, String title, String content) {
  /// set up the AlertDialog
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  /// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


/// Directing to next page
push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(new MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => predict);
}

/// To display user uploaded profile image in a circle
Widget displayCircleImage(String picUrl, double size, hasBorder) =>
    CachedNetworkImage(
        imageBuilder: (context, imageProvider) =>
            _getCircularImageProvider(imageProvider, size, false),
        imageUrl: picUrl,
        placeholder: (context, url) =>
            _getPlaceholderOrErrorImage(size, hasBorder),
        errorWidget: (context, url, error) =>
            _getPlaceholderOrErrorImage(size, hasBorder));


/// Display a placeholder image in the Oval Clip
Widget _getPlaceholderOrErrorImage(double size, hasBorder) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    color: const Color(0xff7c94b6),
    borderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
    border: new Border.all(
      color: Colors.white,
      width: hasBorder ? 2.0 : 0.0,
    ),
  ),
      child: ClipOval(
          child: Image.asset(
        'assets/placeholder.jpg',
        fit: BoxFit.cover,
        height: size,
        width: size,
      )),
    );

/// Gets the latest image that users have set as the profile picture
Widget _getCircularImageProvider(
    ImageProvider provider, double size, bool hasBorder) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xff7c94b6),
      borderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
      border: new Border.all(
        color: Colors.white,
        width: hasBorder ? 2.0 : 0.0,
      ),
    ),
    child: ClipOval(
        child: FadeInImage(
            fit: BoxFit.cover,
            placeholder: Image.asset(
              'assets/placeholder.jpg',
              fit: BoxFit.cover,
              height: size,
              width: size,
            ).image,
            image: provider)),
  );
}
