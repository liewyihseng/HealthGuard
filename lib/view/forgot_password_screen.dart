import 'dart:ui';

import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// Forgot password screen page widget class
class ForgotPassword extends StatefulWidget{
  static const String id = "ForgotPasswordPage";
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

/// Forgot password screen page state class
class _ForgotPasswordPageState extends State<ForgotPassword>{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Forgot your password?',
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
      body: SingleChildScrollView(
        child: new Container(
            margin: new EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: new Form(
              key : _key,
              autovalidate: _validate,
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
                    child: Text('Please enter your email, a verification email will be sent to update your password.',
                      style: TextStyle(
                        color: Constants.TEXT_LIGHT,
                        fontFamily: Constants.FONTSTYLE,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10, right: 8, bottom: 8),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[

                        SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: BoxConstraints(minWidth: double.infinity),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                              validator: validateEmail,
                              onSaved: (String val){
                                email = val;
                              },
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                fillColor: Colors.white,
                                hintText: 'Email Address',
                                icon: Icon(
                                    Icons.mail,
                                    color:Constants.TEXT_LIGHT
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: double.infinity),
                      child: RaisedButton(
                        color: Constants.BUTTON_COLOUR,
                        child: Text('Login',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              fontFamily: Constants.FONTSTYLE,)),
                        textColor: Colors.white,
                        splashColor: Constants.BUTTON_SPLASH_COLOUR,
                        onPressed: () async {
                          resetPassword(email);
                          //await onClick(_emailController.text, _passwordController.text);
                        },
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Constants.BUTTON_COLOUR)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  Future<void> resetPassword(String email) async{
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
