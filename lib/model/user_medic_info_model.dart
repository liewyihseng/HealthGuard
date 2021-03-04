/// Acting as a frame for the creation of user's medical information instances
class user_medic_info{
  String height = "";
  String weight = "";
  String birthday = '';
  String sex = '';
  String healthCondition = '';
  String currentMedication = '';
  String address = '';
  String emergencyContact = '';
  String insuranceID = '';
  String uploadedDate = '';



/// user_medic_info class constructor
user_medic_info(
    {this.height,
      this.weight,
      this.sex,
      this.healthCondition,
      this.currentMedication,
      this.address,
      this.emergencyContact,
      this.insuranceID,
      this.uploadedDate,
    });

  /// Passing user input data, then creating a new user medic info object containing these data
  factory user_medic_info.fromJson(Map<String, dynamic> parsedJson){
    return new user_medic_info(
      height: parsedJson['height'] ?? "",
      weight: parsedJson['weight'] ?? "",
      healthCondition: parsedJson['healthCondition'] ?? "",
      currentMedication: parsedJson['currentMedication'] ?? "",
      address: parsedJson['address'] ?? "",
      emergencyContact: parsedJson['emergencyContact'] ?? "",
      insuranceID: parsedJson['insuranceID'] ?? "",
      uploadedDate: parsedJson['uploadedDate'] ?? "",
    );
  }

  /// Convert to json
  Map<String, dynamic> toJson(){
    return{
      "height": this.height,
      "weight": this.weight,
      "sex": this.sex,
      "healthCondition": this.healthCondition,
      "currentMedication": this.currentMedication,
      "address": this.address,
      "emergencyContact": this.emergencyContact,
      "insuranceID": this.insuranceID,
      "uploadedDate": this.uploadedDate,
    };
  }
}