
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Patient extends User{

  String insuranceID = '';

  Patient({String email, String firstName, String lastName, OurUser.Settings settings, String phoneNumber, bool active, Timestamp lastOnlineTimestamp, String userID, String profilePictureURL, String userType, this.insuranceID}) :
        super(email: email, firstName: firstName, lastName: lastName, settings: settings, phoneNumber: phoneNumber,
          active: active, lastOnlineTimestamp: lastOnlineTimestamp, userID: userType, profilePictureURL: profilePictureURL, userType: "Patient");

  factory Patient.fromJson(Map<String, dynamic> parsedJson){
    return new Patient(
      email: parsedJson['email'] ?? "",
      firstName: parsedJson['firstName'] ?? '',
      lastName: parsedJson['lastName'] ?? '',
      active: parsedJson['active'] ?? false,
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      settings: OurUser.Settings.fromJson(
          parsedJson['settings'] ?? {'allowPushNotifications': true}),
      phoneNumber: parsedJson['phoneNumber'] ?? "",
      userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
      profilePictureURL: parsedJson['profilePictureURL'] ?? "",
      userType: parsedJson['userType'] ?? "",
      insuranceID: parsedJson['insuranceID'] ?? "",
    );
  }

  Map<String, dynamic> toJson(){
    return{
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
      "userType": this.userType,
      "insuranceID": this.insuranceID,
    };
  }
}






