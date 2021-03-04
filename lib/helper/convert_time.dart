/// Checking the form of the minutes to promote standardization
String convertTime(String minutes){
  if(minutes.length == 1){
    return "0" + minutes;
  }else{
    return minutes;
  }
}


