import 'package:jiffy/jiffy.dart';

///store pedometer result data and calculation data
class PedometerData {

  /// variables
  int previousSteps = 0;
  int previousDayNo = Jiffy(DateTime.now()).dayOfYear;
  int steps = 0;
  double calories = 0.0;
  int water = 0;

  /// constructor
  PedometerData({
    this.previousSteps,
    this.previousDayNo,
    this.calories,
    this.steps,
    this.water
  });

  ///convert from json
  factory PedometerData.fromJson(Map<dynamic, dynamic> parsedJson){
    return new PedometerData(
        previousSteps: parsedJson['previousSteps'] ?? 0,
        previousDayNo: parsedJson['previousDayNo'] ?? Jiffy(DateTime.now()).dayOfYear,
        calories: parsedJson['calories'] ?? 0,
        steps: parsedJson['steps'] ?? 0,
        water: parsedJson['water'] ?? 0.0
    );
  }

  ///convert to json
  Map<String, dynamic> toJson(){
    return {
      "previousSteps" : this.previousSteps,
      "previousDayNo" : this.previousDayNo,
      "calories" : this.calories,
      "steps" : this.steps,
      "water" : this.water
    };
  }
}