
/// Acting as the class for the creation of Blood Pressure instances
class BloodPressure{
  String systolic;
  String diastolic;
  String pulse;
  String submittedDate;

  /// Blood Pressure Class Constructor
  BloodPressure({
    this.systolic,
    this.diastolic,
    this.pulse,
    this.submittedDate,
  });

  /// convert to json
  Map<String, dynamic> toJson(){
    return{
      "systolic": this.systolic,
      "diastolic": this.diastolic,
      "pulse": this.pulse,
      "submittedDate": this.submittedDate,
    };
  }

  /// Passing user input data, then creating a new Blood Pressure containing these data
  factory BloodPressure.fromJson(Map<int,dynamic>parsedJson){
    return BloodPressure(
      systolic: parsedJson['systolic'] ?? "",
      diastolic: parsedJson['diastolic'] ?? "",
      pulse: parsedJson['pulse'] ?? "",
      submittedDate: parsedJson['submittedDate'] ?? "",
    );
  }
}