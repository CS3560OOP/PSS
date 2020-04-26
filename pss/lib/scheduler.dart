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

  // TEST DATA ONLY
  var tasks = [...data.TestData.customSet].toList();

  //constructor
  Scheduler() {
    //start with empty schedule
    _schedule = new List<Task>();
    //create the fileHandler object
    fileIO = new FileHandler();

    //testing
    print(_schedule ?? "0");
    RecurringTask temp2 = new RecurringTask(
        "CS3560-Tu", "Class", 19, 1.25, Date(20200414), Date(20200505), 7);
    createSchedule();
    _schedule.add(temp2);

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
    print(jsonString);
    //write that string to a file
    fileIO.writeData(jsonString, fileName);
  }

  //Read the schedule from a file
  Future<void> readFromFile(String fileName) async {
    //read the json string from a file
    var jsonString = await fileIO.readData(fileName);
    //convert the jsonString to tasks in the schedule
    //var schedule = jsonDecode(jsonString);
    //print(schedule);
  }

  /// Returns processed schedule
  void createSchedule() {
    this._schedule = this.tasks.map((item) {
      Task t;
      if (Validator().isValidTask(item))
        t = TaskGenerator().generateTask(item);
      else
        throw Exception("Invalid Schedule");
      return t;
    }).toList();
  }

  List<Task> getSchedule() => this._schedule;

  /// Create a task
  /// Appends new task to global task list
  void createTask(Map<String, Object> data) {
    var newTask = TaskGenerator().generateTask(data);
    if (Validator().isValidTask(data) ||
        Validator().isTimeAvailable(this._schedule, newTask)) {
      /// check if Date and Time is available
      this._schedule.add(newTask);
    } else {
      throw Exception("Error: Invalid Task format!");
    }
  }

  ///TODO: View a task

  ///TODO: Delete a task

  ///TODO: Edit a task

}
