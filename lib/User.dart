import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

/// Acting as a frame for the creation of user instances
class User {

  ///variables
  String email = '';
  String firstName = '';
  String lastName = '';
  Settings settings = Settings(allowPushNotifications: true);
  String phoneNumber = '';
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String userID;
  String profilePictureURL = '';
  bool selected = false;
  String appIdentifier = 'HealthGuard ${Platform.operatingSystem}';
  PedometerData pedometerData = PedometerData();

  /// User class Constructor
  User(
      {this.email,
        this.firstName,
        this.phoneNumber,
        this.lastName,
        this.active,
        this.lastOnlineTimestamp,
        this.settings,
        this.userID,
        this.profilePictureURL,}
        );

  /// helper function combining user's first name and last name to form full name
  String fullName() {
    return '$firstName $lastName';
  }

  /// Passing user input data, then creating a new user containing these data
  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? "",
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        settings: Settings.fromJson(
            parsedJson['settings'] ?? {'allowPushNotifications': true}),
        phoneNumber: parsedJson['phoneNumber'] ?? "",
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "settings": this.settings.toJson(),
      "phoneNumber": this.phoneNumber,
      "id": this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      "profilePictureURL": this.profilePictureURL,
      'appIdentifier': this.appIdentifier,
    };
  }
}

class Settings {
  bool allowPushNotifications = true;
  Settings({this.allowPushNotifications});

  factory Settings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Settings(
        allowPushNotifications: parsedJson['allowPushNotifications'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {'allowPushNotifications': this.allowPushNotifications};
  }
}


///store pedometer result data and calculation data
class PedometerData {

  /// variables
  int previousSteps = 0;
  int previousDayNo = Jiffy(DateTime.now()).dayOfYear;
  int steps = 0;
  double calories = 0.0;
  int water = 0;

  /// constructor
  PedometerData({
    this.previousSteps,
    this.previousDayNo,
    this.calories,
    this.steps,
    this.water
  });

  ///convert from json
  factory PedometerData.fromJson(Map<dynamic, dynamic> parsedJson){
    return new PedometerData(
      previousSteps: parsedJson['previousSteps'] ?? 0,
      previousDayNo: parsedJson['previousDayNo'] ?? Jiffy(DateTime.now()).dayOfYear,
      calories: parsedJson['calories'] ?? 0,
      steps: parsedJson['steps'] ?? 0,
      water: parsedJson['water'] ?? 0.0
    );
  }

  ///convert to json
  Map<String, dynamic> toJson(){
    return {
      "previousSteps" : this.previousSteps,
      "previousDayNo" : this.previousDayNo,
      "calories" : this.calories,
      "steps" : this.steps,
      "water" : this.water
    };
  }
}
