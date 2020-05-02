
String decToHours(String number){
    var hour,min;
    var dubNumber = double.parse(number);
    hour = (dubNumber.floor()).toString();
    min = ((dubNumber - dubNumber.floor()) *60).toInt().toString();
    if(min == '0' && hour == '1'){
      return hour+' hour';
    }else if(int.parse(hour) > 1 && min == '0'){
      return hour+' hours';
    }else{
      return hour+' hour and '+ min +' minutes';
    }
}
String convertTimeToString(String time) {
  var hour = '';
  var min = '';
  var meridian = '';
  var dubtime = double.parse(time);
  //Get meridian
  if(dubtime < 13.0) {
    meridian = "am";
  }
  else {
    meridian = 'pm';
  }
  //Get hours
  if(dubtime < 12.0) {
    hour = dubtime.toInt().toString();
    if(0 == dubtime.toInt()) {
      hour = '0';
    }
  }
  else {
    hour = (dubtime.toInt() - 12).toString();
  }
  //Get minutes
  double percent = dubtime - dubtime.round();
  if(percent < 0){
    percent *= -1;
  }
  min = ((percent * 60.0).round()).toString();
  if(min.toString().length == 1){
    min = '0'+min.toString();
  }
  return hour + ':' + min + ' ' + meridian;
}