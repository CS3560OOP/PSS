import 'package:intl/intl.dart';
import "date.dart";

class Validator {
  bool isValidDate(Date d) {
    // format to a valid date
    String comparatorStr = DateFormat.yMd()
        .format(DateTime(d.getYear(), d.getMonth(), d.getDay()));
    // manual concatenate format
    String originalStr = d.getMonth().toString() +
        "/" +
        d.getDay().toString() +
        "/" +
        d.getYear().toString();
    return originalStr == comparatorStr;
  }

  bool isValidReccurringTask(Map<String, Object> task) {
    var name = task["Name"];
    var type = task["Type"];
    // TODO: start time input is invalid. int instead of double,
    // convert to double for now
    var sTime = double.parse(task["StartTime"].toString());
    var dur = task["Duration"];
    var sDate = Date(task["StartDate"]);
    var eDate = Date(task["EndDate"]);
    var freq = task["Frequency"];

    return (name is String) &&
        (type is String) &&
        (sTime is double) &&
        (dur is double) &&
        (isValidDate(sDate)) &&
        (isValidDate(eDate)) &&
        (freq is int);
  }

  bool isValidTransientTask(Map<String, Object> task) {
    var name = task["Name"];
    var type = task["Type"];
    // TODO: start time input is invalid. int instead of double,
    // convert to double for now
    var sTime = double.parse(task["StartTime"].toString());
    var dur = task["Duration"];
    var date = Date(task["Date"]);
    return (name is String) &&
        (type is String) &&
        (sTime is double) &&
        (dur is double) &&
        isValidDate(date);
  }

  bool isValidAntiTask(Map<String, Object> task) {
    var name = task["Name"];
    var type = task["Type"];
    // TODO: start time input is invalid. int instead of double,
    // convert to double for now
    var sTime = double.parse(task["StartTime"].toString());
    var dur = task["Duration"];
    var date = Date(task["Date"]);
    return (name is String) &&
        (type is String) &&
        (sTime is double) &&
        (dur is double) &&
        isValidDate(date);
  }
}
