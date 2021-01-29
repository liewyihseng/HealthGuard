class Medicine{
  final List<dynamic> notificationIDs;
  String medicineName = "";
  String dosage;
  String medicineType = "";
  int interval;
  String startTime = "";

  Medicine({
    this.notificationIDs,
    this.medicineName,
    this.dosage,
    this.medicineType,
    this.startTime,
    this.interval,
  });

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