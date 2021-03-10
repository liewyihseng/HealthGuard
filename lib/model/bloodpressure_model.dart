class BloodPressure{
  String systolic;
  String diastolic;
  String pulse;
  String submittedDate;

  BloodPressure({
    this.systolic,
    this.diastolic,
    this.pulse,
    this.submittedDate,
  });

  Map<String, dynamic> toJson(){
    return{
      "systolic": this.systolic,
      "diastolic": this.diastolic,
      "pulse": this.pulse,
      "submittedDate": this.submittedDate,
    };
  }


  factory BloodPressure.fromJson(Map<int,dynamic>parsedJson){
    return BloodPressure(
      systolic: parsedJson['systolic'] ?? "",
      diastolic: parsedJson['diastolic'] ?? "",
      pulse: parsedJson['pulse'] ?? "",
      submittedDate: parsedJson['submittedDate'] ?? "",
    );
  }
}