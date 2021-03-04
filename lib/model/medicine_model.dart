///  Acting as a frame for the creation of medicine instances
class Medicine{

  /// variables
  final List<dynamic> notificationIDs;
  String medicineName = "";
  String dosage;
  String medicineType = "";
  int interval;
  String startTime = "";

  /// Medicine class Constructor
  Medicine({
    this.notificationIDs,
    this.medicineName,
    this.dosage,
    this.medicineType,
    this.startTime,
    this.interval,
  });

  /// Convert to json
  Map<String, dynamic> toJson(){
    return{
      "id": this.notificationIDs,
      "medicineName": this.medicineName,
      "dosage": this.dosage,
      "medicineType": this.medicineType,
      "interval": this.interval,
      "startTime": this.startTime,
    };
  }

  /// Passing user input data, then creating a new medicine object containing these data
  factory Medicine.fromJson(Map<String, dynamic>parsedJson){
    return Medicine(
      notificationIDs: parsedJson['id'] ?? "",
      medicineName: parsedJson['medicineName'] ?? "",
      dosage: parsedJson['dosage'] ?? "",
      medicineType: parsedJson['medicineType'] ?? "",
      interval: parsedJson['interval'] ?? "",
      startTime: parsedJson['startTime'] ?? "",
    );
  }


}