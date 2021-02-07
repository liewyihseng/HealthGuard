import 'package:cloud_firestore/cloud_firestore.dart';

///store pedometer result data and calculation data
class PedometerData {

  /// variables
  int goal = 10000;
  int steps = 0;
  int water = 0;
  double calories = 0.0;
  Timestamp lastUpdate = Timestamp.now();

  /// constructor
  PedometerData({
    this.goal,
    this.steps,
    this.water,
    this.calories,
    this.lastUpdate
  });

  ///convert from json
  factory PedometerData.fromJson(Map<dynamic, dynamic> parsedJson){
    return new PedometerData(
        goal: parsedJson['goal'] ?? 10000,
        steps: parsedJson['steps'] ?? 0,
        water: parsedJson['water'] ?? 0.0,
        calories: parsedJson['calories'] ?? 0,
        lastUpdate: parsedJson['lastUpdate'] ?? Timestamp.now()
    );
  }

  ///convert to json
  Map<String, dynamic> toJson(){
    return {
      "goal" : this.goal,
      "steps" : this.steps,
      "water" : this.water,
      "calories" : this.calories,
      "lastUpdate" : this.lastUpdate
    };
  }
}