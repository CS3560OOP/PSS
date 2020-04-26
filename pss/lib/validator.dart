import 'package:intl/intl.dart';
import 'date.dart';
import 'type_matcher.dart';
import 'anti_task.dart';
import 'recurring_task.dart';
import 'transient_task.dart';
import 'task.dart';

class Validator {
  /// This function verifies if the Date exists
  bool isValidDate(Date d) {
    try {
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
    } catch (e) {
      print("Error: Invalid date input : $e");
      return false;
    }
  }

  bool isValidTask(Map<String, Object> task) {
    final matcher = new TypeMatcher();
    bool isValid;
    var name = task["Name"];
    var type = task["Type"];
    // TODO: need more checking??
    var sTime = double.parse(task["StartTime"].toString());
    var dur = double.parse(task["Duration"].toString());

    if ((name is String) &&
        (type is String) &&
        (sTime is double) &&
        (dur is double)) {
      // check additional fields
      if (matcher.getType(type) == "Recurring")
        isValid = isValidReccurringTask(task);
      else
        // Anti-Task or Transient Task
        isValid = isValidDate(Date(task["Date"]));
    } else {
      isValid = false;
    }
    return isValid;
  }

  bool isValidReccurringTask(Map<String, Object> task) {
    var sDate = new Date(task["StartDate"]);
    var eDate = new Date(task["EndDate"]);
    var freq = task["Frequency"];
    if ((isValidDate(sDate)) && (isValidDate(eDate)) && (freq is int)) {
      return true;
    } else {
      return false;
    }
  }

  bool isTimeAvailable(List<Task> existingTasks, Task newTask) {}
}
