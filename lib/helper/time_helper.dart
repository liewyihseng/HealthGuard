
class TimeHelper{
  /// Retrieving the current date
  static DateTime getLastMidnightDate(){
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
  /// Retrieving tomorrow's date
  static DateTime getNextMidnightDate(){
    return getLastMidnightDate().add(Duration(days: 1));
  }

  /// Retrieving yesterday's date
  static DateTime getYesterdayDate(){
    return getLastMidnightDate().subtract(Duration(seconds: 1));
  }
}