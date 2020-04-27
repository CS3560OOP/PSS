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

    // TODO: validate that the name is unique
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

  /// checks to see if there are no time conflicts
  /// potentialConflicts is assumed to have tasks which
  /// have the same or surrounding dates with the newTask
  bool hasNoTimeConflict(List<Map> potentialConflictList, Task newTask) {
    bool noConflict = true;
    double start = newTask.getStartTime();
    double end = start + newTask.getDuration();

    if (potentialConflictList.isEmpty) {
      noConflict = true;
    } else {
      potentialConflictList.forEach((t) {
        if (noConflict) {
          double tStart = t["StartTime"];
          double tEnd = t["EndTime"];
          if (start >= tEnd || end <= tStart) {
            noConflict = true;
          } else {
            noConflict = false;
          }
        }
      });
    }
    return noConflict;
  }

  /// Returns a list of all potential task
  /// that has the same date as the new task
  List getPotentialConflicts(List tasks, dynamic newTask) {
    int targetStartDate, targetEndDate, targetDate;
    List list;

    /// get relevant dates
    if (newTask is RecurringTask) {
      targetStartDate = newTask.getStartDate().getIntDate();
      targetEndDate = newTask.getEndDate().getIntDate();
    } else if (newTask is TransientTask || newTask is AntiTask) {
      targetDate = newTask.getDate().getIntDate();
    } else {
      throw Exception("New Task not valid");
    }

    // get potential conflicts
    if (newTask is RecurringTask) {
      /// TODO
    } else if (newTask is TransientTask) {
      list = tasks.map((t) {
        // recurring
        if (t is RecurringTask) {
          if (targetDate >= t.getStartDate().getIntDate() &&
              targetDate <= t.getEndDate().getIntDate()) {
            if (hasDateConflict(t, newTask)) {
              return {
                "Type": "Recurring",
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              };
            }
          }
        } else if (targetDate == t.getDate().getIntDate())
          return {
            "Type": "Transient",
            "StartTime": t.getStartTime(),
            "EndTime": t.getStartTime() + t.getDuration()
          };
      }).toList();
    } else {
      // TODO: Anti task
    }
    return list;
  }
}

/// check if a any of the dates covered by the recurring task
/// conflicts with a transient task
bool hasDateConflict(RecurringTask rTask, TransientTask tTask) {
  // TODO:
  var targetDate = tTask.getDate().getIntDate();
  var testDate = rTask.getStartDate().getIntDate();
  var freq = rTask.getFrequency();
  var hasConflict = false;
  while (targetDate < testDate) {
    if (targetDate == testDate) return true;
    testDate += freq;
  }
  return hasConflict;
}
