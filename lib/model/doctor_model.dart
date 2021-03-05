import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Acting as a frame for the creation of doctor instances (Extends User class)
class Doctor extends User{

  /// variables
  String workPlace = '';
  String speciality = '';
  String aboutYourself = "";
  String doctorID = "";

  /// Doctor class Constructor
  Doctor({String email, String firstName, String lastName, OurUser.Settings settings, String phoneNumber, bool active, Timestamp lastOnlineTimestamp, String userID, String profilePictureURL, String userType, String birthday, String sex, String chattingWith, this.workPlace, this.speciality, this.aboutYourself, this.doctorID,}) :
        super(email: email, firstName: firstName, lastName: lastName, settings: settings, phoneNumber: phoneNumber,
          active: active, lastOnlineTimestamp: lastOnlineTimestamp, userID: userType, profilePictureURL: profilePictureURL, userType: "Doctor", sex: sex, birthday: birthday);

  /// Passing doctor input data, then creating a new doctor containing these data
  factory Doctor.fromJson(Map<String, dynamic> parsedJson){
    return new Doctor(
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
      sex: parsedJson['sex'] ?? "",
      birthday: parsedJson['birthday'] ?? "",
      chattingWith: parsedJson['chattingWith'] ?? "",
      workPlace: parsedJson['workPlace'] ?? "",
      speciality: parsedJson['speciality'] ?? "",
      aboutYourself: parsedJson['aboutYourself'] ?? "",
      doctorID: parsedJson['doctorID'] ?? "",
    );
  }
  /// Convert to json
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
      "birthday": this.birthday,
      "sex": this.sex,
      "chattingWith": this.chattingWith,
      "userType": this.userType,
      "workPlace": this.workPlace,
      "speciality": this.speciality,
      "aboutYourself": this.aboutYourself,
      "doctorID": this.doctorID,
    };
  }

  /// helper function combining user's first name and last name to form full name
  String fullNameDr() {
    return 'Dr. '+ fullName();
  }
}



