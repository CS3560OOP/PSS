import 'task.dart';
import 'transient_task.dart';
import 'recurring_task.dart';
import 'anti_task.dart';
import 'date.dart';
import 'validator.dart';

/// This class helps generates an object
/// with the correct task class
/// using map input
class TaskObjectGenerator {
  static const recurringType = ["Class", "Study", "Exercise", "Work", "Meal"];
  static const transientType = ["Visit", "Shopping", "Appointment"];
  static const antiTaskType = ["Cancellation"];

  Task generateTask(Map<String, Object> task) {
    String type = task["Type"];
    if (recurringType.contains(type))
      return _generateRecurringTask(task);
    else if (transientType.contains(type))
      return _generateTransientTask(task);
    else
      return _generateAntiTask(task);
  }

  RecurringTask _generateRecurringTask(Map<String, Object> task) {
    String name, type;
    double sTime, dur;
    Date sDate, eDate;
    int freq;
    name = task["Name"];
    type = task["Type"];
    sTime = task["StartTime"];
    dur = task["Duration"];
    sDate = Date(task["StartDate"]);
    eDate = Date(task["EndDate"]);
    freq = task["Frequency"];
    return RecurringTask(name, type, sTime, dur, sDate, eDate, freq);
  }

  TransientTask _generateTransientTask(Map<String, Object> task) {
    String name, type;
    double sTime, dur;
    Date date;

    name = task["Name"];
    type = task["Type"];
    sTime = task["StartTime"];
    dur = task["Duration"];
    date = Date(task["Date"]);

    return TransientTask(name, type, sTime, dur, date);
  }

  AntiTask _generateAntiTask(Map<String, Object> task) {
    String name, type;
    double sTime, dur;
    Date date;

    name = task["Name"];
    type = task["Type"];
    sTime = task["StartTime"];
    dur = task["Duration"];
    date = Date(task["Date"]);

    return AntiTask(name, type, sTime, dur, date);
  }
}
