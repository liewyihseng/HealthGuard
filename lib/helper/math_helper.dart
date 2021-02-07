import 'dart:math';

/// helper function for all math related
class MathHelper{

  /// round value to decimal place
  static double toPrecision(double value, int place) {
    return ((value * pow(10, place)).round()) / pow(10, place);
  }

}