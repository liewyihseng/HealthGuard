import 'package:jiffy/jiffy.dart';

///store pedometer result data and calculation data
class PedometerData {

  /// variables
  int steps = 0;
  double calories = 0.0;
  int water = 0;
  int goal = 10000;

  /// constructor
  PedometerData({
    this.calories,
    this.steps,
    this.water,
    this.goal
  });

  ///convert from json
  factory PedometerData.fromJson(Map<dynamic, dynamic> parsedJson){
    return new PedometerData(
        calories: parsedJson['calories'] ?? 0,
        steps: parsedJson['steps'] ?? 0,
        water: parsedJson['water'] ?? 0.0,
        goal: parsedJson['goal'] ?? 10000
    );
  }

  ///convert to json
  Map<String, dynamic> toJson(){
    return {
      "calories" : this.calories,
      "steps" : this.steps,
      "water" : this.water,
      "goal" : this.goal
    };
  }
}