import 'dart:math';

/// helper function for all math related
class MathHelper{

  /// round value to decimal place
  static double toPrecision(double value, int place) {
    return ((value * pow(10, place)).round()) / pow(10, place);
  }

  /// calculate progress return int 0 ~ 100
  static int intPercentage(int value, int total){
    if (value < 0)
      value *= -1;
    if (total < 0)
      total *= -1;
    return min(100, (value/total*100).toInt());
  }
}