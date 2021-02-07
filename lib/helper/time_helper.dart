
import 'package:cloud_firestore/cloud_firestore.dart';

class TimeHelper{

  static DateTime getLastMidnightDate(){
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static DateTime getNextMidnightDate(){
    return getLastMidnightDate().add(Duration(days: 1));
  }

  static DateTime getYesterdayDate(){
    return getLastMidnightDate().subtract(Duration(seconds: 1));
  }
}