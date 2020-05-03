import 'transient_task.dart';
import 'fileHandler.dart';
import 'recurring_task.dart';
import 'task.dart';
import 'anti_task.dart';
import 'dart:convert';
import 'date.dart';
import 'create/task_generator.dart';
import 'validator.dart';

// testing data
import 'testData/test_data.dart' as data;

class Scheduler {
  //class properties
  List<Task> _schedule;
  FileHandler fileIO;
  Validator validator;
  Map<int, List<dynamic>> _events; // hold a map of date keys for easy search

  //constructor
  Scheduler() {
    //start with empty schedule
    _schedule = new List<Task>();
    //create the fileHandler object
    fileIO = new FileHandler();

    validator = new Validator();

    //testing
    print(_schedule ?? "0");
    // RecurringTask temp2 = new RecurringTask(
    //     "CS3560-Tu", "Class", 19, 1.25, Date(20200414), Date(20200505), 7);

    // _schedule.add(temp2);
    setSchedule(data.TestData.set1);
    setEvents(this._schedule);
    writeToFile("test.json");
    readFromFile("test.json");
    // print(_schedule);
  }

  //Write the schedule to a file
  void writeToFile(String fileName) {
    // var temp = {"name": "CS4600", "type": "Class", "duration": 1.75};
    var jsonString = "[";
    for (var task in _schedule) {
      jsonString += jsonEncode(task);
    }
    // jsonString += jsonEncode(temp);
    //
    jsonString += "]";
    // print(jsonString);
    //write that string to a file
    fileIO.writeData(jsonString, fileName);
  }

  //Read the schedule from a file
  Future<void> readFromFile(String fileName) async {
    //read the json string from a file
    var jsonString = await fileIO.readData(fileName);
    //convert the jsonString to tasks in the schedule
    // var schedule = jsonDecode(jsonString);
    // print(schedule);
  }

  /// Returns processed schedule
  void setSchedule(List<Map<String, Object>> tasks) {
    this._schedule = tasks.map((item) {
      try {
        Task t;
        validator.validateTask(this.getSchedule(), item);
        t = TaskGenerator().generateTask(item);
        return t;
      } catch (e) {
        throw e;
      }
    }).toList();
  }

  List<Task> getSchedule() => this._schedule;

  /// Create a task
  /// Appends new task to global task list
  void createTask(Map<String, Object> data) {
    var newTask = TaskGenerator().generateTask(data);

    List sched = this.getSchedule();

    try {
      // check if user input is correct
      validator.validateTask(sched, data);
      if (newTask is TransientTask || newTask is RecurringTask) {
        // must no have overlaps to be added
        String type = newTask.runtimeType.toString();
        if (validator.hasNoTimeOverlap(sched, newTask)) {
          this._schedule.add(newTask);
        } else {
          throw Exception("$type Overlap!");
        }
      } else if (newTask is AntiTask) {
        // must have overlap to be added
        String type = newTask.runtimeType.toString();
        if (!validator.hasNoTimeOverlap(sched, newTask)) {
          this._schedule.add(newTask);
        } else {
          throw Exception("$type Overlap!");
        }
      }

      /// update schedule
      /// TODO: create separate update func
      setEvents(this._schedule);
    } catch (e) {
      throw e;
    }
  }

  /// set _events based on date/ date range provided
  ///
  void setEvents(List<Task> tasks) {
    Date date, sDate, eDate;
    this._events = Map<int, List<dynamic>>();
    tasks.forEach((t) {
      if (t is TransientTask) {
        date = t.getDate();
        this._events.update(date.getIntDate(), (listOfTasks) {
          listOfTasks.add(t);
          return listOfTasks;
        }, ifAbsent: () {
          var listOfTasks = new List<dynamic>();
          listOfTasks.add(t);
          return listOfTasks;
        });
      } else if (t is RecurringTask) {
        sDate = t.getStartDate();
        eDate = t.getEndDate();
        while (sDate.getIntDate() <= eDate.getIntDate()) {
          if (!Validator().isValidDate(sDate)) {
            /// date does not exist
            /// i.e. Feb 30
            Date altDate = sDate.getLastDateOfMonth();

            this._events.update(altDate.getIntDate(), (listOfTasks) {
              listOfTasks.add(t);
              return listOfTasks;
            }, ifAbsent: () {
              var listOfTasks = new List<dynamic>();
              listOfTasks.add(t);
              return listOfTasks;
            });
          }
          this._events.update(sDate.getIntDate(), (listOfTasks) {
            listOfTasks.add(t);
            return listOfTasks;
          }, ifAbsent: () {
            var listOfTasks = new List<dynamic>();
            listOfTasks.add(t);
            return listOfTasks;
          });
          sDate = t.getNextOccurance(sDate);
        }
      }
    });
  }

  Map<int, List<dynamic>> getEvents() => this._events;

  /// returns tasks on given day d
  List getDayEvents(DateTime d) {
    Date date = Date.dateTime(d);
    List tasks = List<dynamic>();
    var events = getEvents();
    tasks = events[date.getIntDate()] != null
        ? events[date.getIntDate()]
        : List<dynamic>();
    return tasks;
  }

  /// returns a list of task containing
  /// all tasks between s & e
  List getEventsBetween(DateTime s, DateTime e) {
    Date curr = Date.dateTime(s);
    Date end = Date.dateTime(e);
    List tasks = List<dynamic>();

    while (curr.getIntDate() <= end.getIntDate()) {
      var moreTasks = getDayEvents(curr.getDateTime());
      tasks = [...tasks, ...moreTasks];
      curr = curr.getNextDayDate();
    }
    return tasks;
  }

  ///TODO: Delete a task

  ///TODO: Edit a task

  ///TODO: Find a task
  //Returns singleton list of task of the given name if not found returns empty list
  List getNamedEvent(String name) {
    List<Task> task = new List<Task>();
    _schedule.forEach((t) {
      if(t.getName().compareTo(name) == 0) {
        task.add(t);
      }
    });
    return task;
  }

  // Helper function 
  //Searches list of tasks to find task by name if not found returns null
  Task _searchTaskByName(String name) {
    _schedule.forEach((task) {
      if(task.getName().compareTo(name) == 0) {
        return task;
      }
    });
    return null;
  }
}
