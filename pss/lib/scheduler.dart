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
    _events = new Map<int, List<dynamic>>();
    //create the fileHandler object
    fileIO = new FileHandler();

    validator = new Validator();

      // setSchedule(data.TestData.set1);
      //_seedData();
    writeToFile("Set1.json");
    readFromFile("Set1.json");
    
    //print(_schedule);
  }



  //Write the schedule to a file
  void writeToFile(String fileName) {
    //The array is not directly encoded but calls and encodes each item individually
    String jsonString = jsonEncode(_schedule);
    //write that string to a file
    fileIO.writeData(jsonString, fileName);
    //
    print(fileName + " has been written to");
  }

  //Read the schedule from a file
  Future<void> readFromFile(String fileName) async {
    //read the json string from the file
    var jsonString = await fileIO.readData(fileName);
    //convert the jsonString to a List<dynamic>
    List<dynamic> map = jsonDecode(jsonString);
    //Take each dynamic object in the List and cast it to <Map<String, Object>>
    List<Map<String, Object>> tasks = List<Map<String, Object>>();
    for(var task in map){
      Map<String, Object> newTask = task;    
      tasks.add(newTask);
    }
    //Set the Schedule with the data read from the file
    setSchedule(tasks);
    //Set the Events with the schedule
    setEvents(_schedule);
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

  Future<void> deleteTask(Task task) async {
    await _schedule.remove(task);
    //await _schedule.removeWhere((task) => task.getName().compareTo(name) == 0);
  }

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

  // Seed the device with test data
  Future<void> _seedData(){
    _schedule.clear();
    //Set the schedule with the test data, write the file, delete schedule
    setSchedule(data.TestData.set1);
    writeToFile("Set1.json");
    _schedule.clear();
    // Set 2
    setSchedule(data.TestData.set2);
    writeToFile("Set2.json");
    _schedule.clear();
    // Custom Set 1
    setSchedule(data.TestData.customSet1);
    writeToFile("CustomSet1.json");
    _schedule.clear();
    // Custom Set 2
    setSchedule(data.TestData.customSet2);
    writeToFile("CustomSet2.json");
    _schedule.clear();
  }
}
