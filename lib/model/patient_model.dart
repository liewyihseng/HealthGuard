
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Acting as a frame for the creation of Patient instances
class Patient extends User{
  /// variables
  String insuranceID = '';

  /// Patient class Constructor
  Patient({String email, String firstName, String lastName, OurUser.Settings settings, String phoneNumber, bool active, Timestamp lastOnlineTimestamp, String userID, String profilePictureURL, String userType, String sex, String birthday, this.insuranceID}) :
        super(email: email, firstName: firstName, lastName: lastName, settings: settings, phoneNumber: phoneNumber,
          active: active, lastOnlineTimestamp: lastOnlineTimestamp, userID: userType, profilePictureURL: profilePictureURL, userType: "Patient", sex: sex, birthday: birthday);

  /// Passing user input data, then creating a new patient containing these data
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
      sex: parsedJson['sex'] ?? "",
      birthday: parsedJson['birthday'] ?? "",
      insuranceID: parsedJson['insuranceID'] ?? "",
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
      "userType": this.userType,
      "sex": this.sex,
      "birthday": this.birthday,
      "insuranceID": this.insuranceID,
    };
  }
}






