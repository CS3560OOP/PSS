import 'package:intl/intl.dart';
import 'package:pss/create/task_generator.dart';
import 'date.dart';
import 'type.dart';
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

  /// TASK FORMAT VALIDATORS ********************************************************
  void validateTask(List sched, Map<String, Object> task) {
    final matcher = new Type();
    try {
      var type = task["Type"];
      if (!isValidTaskName(sched, task["Name"])) {
        throw Exception("Task already exists");
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

  /// check if dates in between sDate and eDate given freq
  /// are valid dates
  bool allValidDates(Map<String, Object> data) {
    RecurringTask task = TaskGenerator().generateTask(data);
    Date date = task.getStartDate();
    Date eDate = task.getEndDate();
    while (date.getIntDate() <= eDate.getIntDate()) {
      if (!isValidDate(date)) return false;
      date = task.getNextOccurance(date);
    }
    return true;
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
      if ((time <= 23.75) && (time > 0) && (time % 0.25 == 0.0))
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

  /// TASK TIME/DATE OVERLAP VALIDATORS *************************************************
  ///
  /// checks to see if there are no time conflicts
  /// calls getDateOverlaps() to get potentialConflictsList
  /// that contain all tasks that overlap dates
  /// this function will then check time conflicts
  /// if not time conflicts, returns true, false otherwise
  bool hasNoTimeOverlap(List sched, Task newTask) {
    double start = newTask.getStartTime();
    double end = start + newTask.getDuration();
    List conflictList = getDateOverlaps(sched, newTask);
    // conflictList.forEach((task){print(task.getName());});
    print("New Task: " + " " + start.toString() + " " + end.toString());
    if (conflictList.isNotEmpty) {
      if (newTask is TransientTask || newTask is RecurringTask) {
        for (var t in conflictList) {
          print(t);
          //Starts during and ends during or after
          if ((start > t["StartTime"] && start < t["EndTime"])) return false;
          //Starts before it and ends during it
          if (start < t["StartTime"] &&
              (end > t["StartTime"] && end < t["EndTime"])) return false;
          //Starts before it and ends after it
          if (start < t["StartTime"] && end > t["EndTime"]) {
            return false;
          }
          if (start < t["EndTime"] && end > t["StartTime"]) return false;
        }
      } else if (newTask is AntiTask) {
        /// Overlap for an antitask
        /// means both start and end times
        /// are the equal
        for (var t in conflictList) {
          if (start == t["StartTime"] && end == t["EndTime"]) return false;
        }
      }
    } else {
      print("im empty");
    }
    return true;
  }

  /// Returns a list of all potential task
  /// that has the same date as the new task
  /// eliminates all recurring task instances that
  /// have corresponding anti-tasks
  List getDateOverlaps(List sched, dynamic newTask) {
    Date newTaskDate;
    List antiTasks = new List();
    List recurringTasks = new List();
    List transientTasks = new List();

    // get potential conflicts
    // returns List<Map> of all tasks
    // have have overlapping dates
    if (newTask is RecurringTask) {
      Date newTaskDate = newTask.getStartDate();
      Date newTaskEndDate = newTask.getEndDate();
      while (newTaskDate.getIntDate() <= newTaskEndDate.getIntDate()) {
        sched.forEach((t) {
          // add all tasks that have a date equal
          // to any of the dates covered by the
          // recurring task
          if (t is RecurringTask) {
            if (hasDateOverlap(t, newTask)) {
              recurringTasks.add({
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              });
            }
          } else if (t is TransientTask) {
            if (t.getDate().getIntDate() == newTaskDate.getIntDate()) {
              transientTasks.add({
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              });
            }
          } else if (t is AntiTask) {
            if (newTaskDate.getIntDate() == t.getDate().getIntDate()) {
              antiTasks.add({
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              });
            }
          } else {
            throw Exception("No Type found for Existing Task");
          }
        });
        newTaskDate = newTask.getNextOccurance(newTaskDate);
      }
    } else if (newTask is TransientTask || newTask is AntiTask) {
      newTaskDate = newTask.getDate();
      sched.forEach((t) {
        print(newTask.getName() + " compare " + t.getName());
        if (t is RecurringTask) {
          if (hasDateOverlap(t, newTask)) {
            recurringTasks.add({
              "StartTime": t.getStartTime(),
              "EndTime": t.getStartTime() + t.getDuration()
            });
          }
        } else if (t is TransientTask || t is AntiTask) {
          if (t is TransientTask) {
            if (newTaskDate.getIntDate() == t.getDate().getIntDate()) {
              transientTasks.add({
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              });
            }
          } else if (t is AntiTask) {
            if (t.getDate().getIntDate() == newTaskDate.getIntDate()) {
              antiTasks.add({
                "StartTime": t.getStartTime(),
                "EndTime": t.getStartTime() + t.getDuration()
              });
            } else {
              print(" IM FALSE");
            }
          }
        } else {
          throw Exception("No Type found for Existing Task");
        }
      });
    } else {
      throw Exception("No type match.");
    }
    List filteredTasks;
    print(recurringTasks.toString());
    if (!(newTask is AntiTask)) {
      filteredTasks = _filterRecurringTasks(recurringTasks, antiTasks);
    } else {
      filteredTasks = [...recurringTasks, ...antiTasks];
    }
    print(filteredTasks.toString());
    return [...transientTasks, ...filteredTasks];
  }

  List<dynamic> _filterRecurringTasks(List recurTasks, List antiTasks) {
    List filtered = new List();
    if (antiTasks.isEmpty) {
      print("Anti is empty");
      filtered = recurTasks;
    } else {
      for (var rTask in recurTasks) {
        for (var aTask in antiTasks) {
          if (aTask["StartTime"] != rTask["StartTime"]) {
            if (aTask["EndTime"] != rTask["Endtime"]) {
              filtered.add(rTask);
            }
          }
        }
      }
    }
    return filtered;

    // var anti = List<dynamic>();
    // var recur = List<dynamic>();

    // tasks.forEach((val) {
    //   if (val is RecurringTask)
    //     recur.add(val);
    //   else if (val is AntiTask) anti.add(val);
    // });

    // var itemsToRemove = new List<int>();

    // if (anti.isNotEmpty) {
    //   if (anti.length <= recur.length) {
    //     anti.forEach((a) {
    //       for (int i = 0; i < recur.length; i++) {
    //         if (a.getStartTime() == recur[i].getStartTime() &&
    //             a.getDuration() == recur[i].getDuration()) {
    //           itemsToRemove.add(i);
    //         }
    //       }
    //     });
    //     itemsToRemove.forEach((index) {
    //       recur.removeAt(index);
    //     });
    //   } else {
    //     throw Exception("Found Antitasks without Recurring Tasks");
    //   }
    // }
    // return recur;
  }

  /// check if a any of the dates covered by the recurring task
  /// conflicts with a transient task
  bool hasDateOverlap(RecurringTask existingTask, dynamic newTask) {
    Date existingDate = existingTask.getStartDate();
    Date existingEndDate = existingTask.getEndDate();
    bool hasOverlap = false;

    if (newTask is RecurringTask) {
      Date newDate = newTask.getStartDate();
      Date newEndDate = newTask.getEndDate();
      // check for any possible conflict on dates
      if (newDate.getIntDate() >= existingDate.getIntDate() ||
          newEndDate.getIntDate() <= existingEndDate.getIntDate() ||
          (newDate.getIntDate() <= existingDate.getIntDate() &&
              newEndDate.getIntDate() >= existingEndDate.getIntDate())) {
        while (newDate.getIntDate() <= newEndDate.getIntDate()) {
          while (existingDate.getIntDate() <= existingEndDate.getIntDate() &&
              hasOverlap != true) {
            if (newDate.getIntDate() == existingDate.getIntDate()) {
              hasOverlap = true;
            } else {
              hasOverlap = false;
            }
            // get next occurence of existing task
            existingDate = existingTask.getNextOccurance(existingDate);
          }
          // get next occurence of new task
          newDate = newTask.getNextOccurance(newDate);
        }
      } else {
        // no possible date conflicts
        hasOverlap = false;
      }
    } else {
      Date newTaskDate = newTask.getDate();
      if (newTaskDate.getIntDate() >= existingDate.getIntDate() &&
          newTaskDate.getIntDate() <= existingEndDate.getIntDate()) {
        while (existingDate.getIntDate() <= existingEndDate.getIntDate() &&
            !hasOverlap) {
          if (newTaskDate.getIntDate() == existingDate.getIntDate()) {
            hasOverlap = true;
          } else {
            hasOverlap = false;
          }
          // get next occurence of existing task
          existingDate = existingTask.getNextOccurance(existingDate);
        }
      } else {
        // no possible date conflicts
        hasOverlap = false;
      }
    }
    return hasOverlap;
  }
}
