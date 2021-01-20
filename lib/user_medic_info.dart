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


/// user_medic_info class constructor
user_medic_info(
    {this.height,
      this.weight,
      this.birthday,
      this.sex,
      this.healthCondition,
      this.currentMedication,
      this.address,
      this.emergencyContact,
    });

  factory user_medic_info.fromJson(Map<String, dynamic> parsedJson){
    return new user_medic_info(
      height: parsedJson['height'] ?? "",
      weight: parsedJson['weight'] ?? "",
      birthday: parsedJson['birthday'] ?? "",
      sex: parsedJson['sex'] ?? "",
      healthCondition: parsedJson['healthCondition'] ?? "",
      currentMedication: parsedJson['currentMedication'] ?? "",
      address: parsedJson['address'] ?? "",
      emergencyContact: parsedJson['emergencyContact'] ?? ""
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "height": this.height,
      "weight": this.weight,
      "birthday": this.birthday,
      "sex": this.sex,
      "healthCondition": this.healthCondition,
      "currentMedication": this.currentMedication,
      "address": this.address,
      "emergencyContact": this.emergencyContact,
    };
  }
}