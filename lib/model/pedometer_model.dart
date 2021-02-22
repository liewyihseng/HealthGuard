import 'package:HealthGuard/helper/time_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

///store pedometer result data and calculation data
class PedometerData {

  /// variables
  int goal;
  int steps;
  int water;
  double calories;
  Timestamp date;

  PedometerData({int goal, int steps, int water, double calories, Timestamp date}){
    this.goal = goal ?? 10000;
    this.steps = steps ?? 0;
    this.water = water ?? 0;
    this.calories = calories ?? 0;
    this.date = date ?? Timestamp.fromDate(TimeHelper.getYesterdayDate());
  }

  ///convert from json
  factory PedometerData.fromJson(Map<dynamic, dynamic> parsedJson){
    return new PedometerData(
        goal: parsedJson['goal'] ?? 10000,
        steps: parsedJson['steps'] ?? 0,
        water: parsedJson['water'] ?? 0,
        calories: parsedJson['calories'] ?? 0,
        date: parsedJson['date'] ?? Timestamp.fromDate(TimeHelper.getYesterdayDate())
    );
  }

  ///convert to json
  Map<String, dynamic> toJson(){
    return {
      "goal" : this.goal,
      "steps" : this.steps,
      "water" : this.water,
      "calories" : this.calories,
      "date" : this.date
    };
  }
}