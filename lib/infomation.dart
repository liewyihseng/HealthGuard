import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class infomation {
  String birthday = '';
  String sex = '';
  String healthCondition = '';
  String currentMedication = '';
  String address = '';
  String emergencyContact = '';
  String appIdentifier = 'HealthGuard ${Platform.operatingSystem}';

  infomation(
      {this.birthday,
      this.sex,
      this.healthCondition,
      this.currentMedication,
      this.address,
      this.emergencyContact});

  factory infomation.fromJson(Map<String, dynamic> parsedJson) {
    return new infomation(
        birthday: parsedJson['birthday'] ?? "",
        sex: parsedJson['sex'] ?? '',
        healthCondition: parsedJson['healthCondition'] ?? '',
        currentMedication: parsedJson['currentMedication'] ?? '',
        address: parsedJson['address'] ?? '',
        emergencyContact: parsedJson['emergencyContact'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      "birthday": this.birthday,
      "sex": this.sex,
      "healthCondition": this.healthCondition,
      "currenMedication": this.currentMedication,
      "address": this.address,
      'emergencyContact': this.emergencyContact,
    };
  }
}
