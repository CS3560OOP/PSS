import 'package:intl/intl.dart';
import 'date.dart';
import 'type_matcher.dart';
import 'anti_task.dart';
import 'recurring_task.dart';
import 'transient_task.dart';
import 'task.dart';

class Validator {
  /// DATE VALIDATORS ***************************************************************
  ///
  /// verifies if the Date exists
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

  /// DATE VALIDATORS ***************************************************************

  /// TASK FORMAT VALIDATORS *********************************************************
  void validateTask(List sched, Map<String, Object> task) {
    final matcher = new TypeMatcher();
    try {
      var type = task["Type"];

      if (!isValidTaskName(sched, task["Name"])) {
        throw Exception("Task name already exists");
      }

      if (!isValidTaskTime(task["StartTime"])) {
        throw Exception("Invalid Start time");
      }

      if (!isValidTaskDuration(task["Duration"])) {
        throw Exception("Invalid Duration");
      }

      // check additional fields
      if (matcher.getType(type) == "Recurring") {
        var sDate = new Date(task["StartDate"]);
        var eDate = new Date(task["EndDate"]);
        var freq = task["Frequency"];

        if (!isValidDate(sDate)) {
          throw Exception("Invalid Start Date");
        }

        if (!isValidDate(eDate)) {
          throw Exception("Invalid End Date");
        }

        if (!isValidTaskFrequency(freq)) {
          throw Exception("Invalid Frequency");
        }
      } else {
        // Anti-Task or Transient Task
        if (!isValidDate(Date(task["Date"]))) {
          throw Exception("Invalid Date");
        }
      }
    } catch (e) {
      throw e;
    }
  }

  /// checks to see if name of new task
  /// is valid string and
  /// is not duplicate
  bool isValidTaskName(List sched, String newTaskName) {
    for (var task in sched) {
      if (task.getName().toUpperCase() == newTaskName.toUpperCase())
        return false;
    }
    return true;
  }

  bool isValidTaskTime(dynamic t) {
    double time;
    try {
      time = double.parse(t.toString());
      // check if input is parsable to double
      if ((time <= 24) && (time > 0) && (time % 0.25 == 0.0))
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  bool isValidTaskDuration(dynamic t) {
    double time;
    try {
      time = double.parse(t.toString()); // check if input is parsable to double
      if (time % 0.25 == 0.0)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  bool isValidTaskFrequency(dynamic f) {
    int freq;
    try {
      freq = int.parse(f.toString()); // check if input is parsable to double
      if (freq == 1 || freq == 7 || freq == 30)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  /// TASK FORMAT VALIDATORS *********************************************************

  /// TASK OVERLAP VALIDATORS *********************************************************
  ///
  /// checks to see if there are no time conflicts
  /// calls getDateOverlaps() to get potentialConflictsList
  /// that contain all tasks that overlap dates
  /// this function will then check time conflicts
  /// if not time conflicts, returns true, false otherwise
  bool hasNoTimeOverlap(List sched, Task newTask) {
    bool noOverlap = true;
    double start = newTask.getStartTime();
    double end = start + newTask.getDuration();
    List conflictList = getDateOverlaps(sched, newTask);

    if (conflictList.isEmpty) {
      noOverlap = true;
    } else if (newTask is TransientTask) {
      for (var t in conflictList) {
        // existing task times
        double tStart = t["StartTime"];
        double tEnd = t["EndTime"];
        if (start >= tEnd || end <= tStart) {
          noOverlap = true;
        } else {
          return false;
        }
      }
    } else if (newTask is AntiTask) {
      /// Overlap for an antitask
      /// means both start and end times
      /// are the equal
      for (var t in conflictList) {
        // existing task times
        double tStart = t["StartTime"];
        double tEnd = t["EndTime"];
        if (start != tStart || end != tEnd) {
          noOverlap = true;
        } else {
          return false;
        }
      }
    } else if (newTask is RecurringTask) {
      // TODO: need to implement
    }
    return noOverlap;
  }

  /// Returns a list of all potential task
  /// that has the same date as the new task
  /// eliminates all recurring task instances that
  /// have corresponding anti-tasks
  List getDateOverlaps(List tasks, dynamic newTask) {
    int targetStartDate, targetEndDate, targetDate;
    List antiTasksTimes = new List();
    List recurringTasks = new List();
    List transientTasks = new List();

    // get potential conflicts
    if (newTask is RecurringTask) {
      targetStartDate = newTask.getStartDate().getIntDate();
      targetEndDate = newTask.getEndDate().getIntDate();

      /// TODO
    } else if (newTask is TransientTask) {
      targetDate = newTask.getDate().getIntDate();
      tasks.map((t) {
        // recurring
        if (t is RecurringTask) {
          if (targetDate >= t.getStartDate().getIntDate() &&
              targetDate <= t.getEndDate().getIntDate()) {
            if (hasDateOverlap(t, newTask)) {
              recurringTasks.add({
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              });
            }
          }
        } else if (t is TransientTask) {
          if (targetDate == t.getDate().getIntDate()) {
            transientTasks.add({
              "StartTime": t.getStartTime(),
              "EndTime": t.getStartTime() + t.getDuration()
            });
          }
        } else {
          // AntiTask
          if (targetDate == t.getDate().getIntDate()) {
            antiTasksTimes.add(t.getStartTime());
          }
        }
      }).toList();
    } else if (newTask is AntiTask) {
      targetDate = newTask.getDate().getIntDate();
      tasks.map((t) {
        if (t is RecurringTask) {
          if (targetDate >= t.getStartDate().getIntDate() &&
              targetDate <= t.getEndDate().getIntDate()) {
            if (hasDateOverlap(t, newTask)) {
              recurringTasks.add({
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              });
            }
          }
        }
      }).toList();
    } else {
      throw Exception("No type match.");
    }
    // remove recurring tasks that have anti-tasks
    if (antiTasksTimes.isNotEmpty) {
      antiTasksTimes.forEach((time) {
        for (int i = 0; i < recurringTasks.length; i++) {
          if (time == recurringTasks[i]["StartTime"]) {
            recurringTasks.removeAt(i);
          }
        }
      });
    }
    return [...transientTasks, ...recurringTasks];
  }

  /// check if a any of the dates covered by the recurring task
  /// conflicts with a transient task
  bool hasDateOverlap(RecurringTask rTask, dynamic tTask) {
    var targetDate = tTask.getDate().getIntDate();
    var testDate = rTask.getStartDate().getIntDate();
    var freq = rTask.getFrequency();
    var hasOverlap = false;

    while (testDate < rTask.getEndDate().getIntDate()) {
      if (targetDate == testDate) {
        return true;
      } else {
        hasOverlap = false;
      }
      testDate += freq;
    }
    return hasOverlap;
  }

  /// TASK OVERLAP VALIDATORS *********************************************************
}
