import 'fileHandler.dart';
import 'recurring_task.dart';
import 'task.dart';
import 'dart:convert';
import 'date.dart';

class Scheduler {
  //class properties
  List<Task> schedule;
  FileHandler fileIO;

  //constructor
  Scheduler() {
    //start with empty schedule
    schedule = new List<Task>();
    //create the fileHandler object
    fileIO = new FileHandler();

    //testing
    print(schedule ?? "0");
    RecurringTask temp2 = new RecurringTask(
        "CS3560-Tu", "Class", Date(20200414), 19, 1.25, Date(20200505), 7);

    schedule.add(temp2);

    writeToFile("test.json");
    readFromFile("test.json");

    // print(schedule);
  }

  //Create a task

  //View a task

  //Delete a task

  //Edit a task

  //Write the schedule to a file
  void writeToFile(String fileName) {
    // var temp = {"name": "CS4600", "type": "Class", "duration": 1.75};

    var jsonString = "[";
    for (var task in schedule) {
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
    var schedule = jsonDecode(jsonString);
    //print(schedule);
  }
}
