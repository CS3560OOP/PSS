import '../task.dart';
import '../transient_task.dart';
import '../recurring_task.dart';
import '../anti_task.dart';
import '../date.dart';
import '../create/type_matcher.dart';

/// This class helps generates an object
/// with the correct task class
/// using map input
/// Call only after validating that user inputs are correct
class TaskGenerator {
  Task generateTask(Map<String, Object> task) {
    final matcher = TypeMatcher();
    if (matcher.getType(task["Type"]) == "Recurring")
      return _generateRecurringTask(task);
    else if (matcher.getType(task["Type"]) == "Transient")
      return _generateTransientTask(task);
    else if (matcher.getType(task["Type"]) == "AntiTask")
      return _generateAntiTask(task);
    else {
      throw Exception("No matching task type found!");
    }
  }

  RecurringTask _generateRecurringTask(Map<String, Object> task) {
    String name = task["Name"];
    String type = task["Type"];
    double sTime = double.parse(task["StartTime"].toString());
    double dur = double.parse(task["Duration"].toString());
    Date sDate = Date(task["StartDate"]);
    Date eDate = Date(task["EndDate"]);
    int freq = int.parse(task["Frequency"].toString());

    return RecurringTask(name, type, sTime, dur, sDate, eDate, freq);
  }

  TransientTask _generateTransientTask(Map<String, Object> task) {
    String name = task["Name"];
    String type = task["Type"];
    double sTime = double.parse(task["StartTime"].toString());
    double dur = double.parse(task["Duration"].toString());
    Date date = Date(task["Date"]);

    return TransientTask(name, type, sTime, dur, date);
  }

  AntiTask _generateAntiTask(Map<String, Object> task) {
    String name = task["Name"];
    String type = task["Type"];
    double sTime = double.parse(task["StartTime"].toString());
    double dur = double.parse(task["Duration"].toString());
    Date date = Date(task["Date"]);

    return AntiTask(name, type, sTime, dur, date);
  }
}
