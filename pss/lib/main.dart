import 'package:flutter/material.dart';
import 'transient_task.dart';
import 'recurring_task.dart';
import 'scheduler.dart';
import 'components/task_card.dart';
import 'date.dart';
import 'testData/test_data.dart' as data;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Scheduler scheduler;

  @override
  void initState() {
    super.initState();
    //initialize data for page
    scheduler = new Scheduler();
  }

  // TEST DATA ONLY
  final tasks = data.TestData.set1;

  // types
  static const recurring = ["Class", "Study", "Exercise", "Work", "Meal"];
  static const transient = ["Visit", "Shopping", "Appointment"];
  static const antiTask = ["Cancellation"];
// generate task cards
  List<TaskCard> _getTaskCards() {
    return tasks.map((item) {
      var type = item["Type"];
      TaskCard widget;
      if (recurring.contains(type))
        widget = TaskCard(
          RecurringTask(
            item["Name"].toString(),
            item["Type"].toString(),
            Date(item["StartDate"]),
            double.parse(item["StartTime"].toString()),
            double.parse(item["Duration"].toString()),
            Date(item["EndDate"]),
            item["Frequency"],
          ),
        );
      else if (transient.contains(type) || antiTask.contains(type)) {
        var t = TransientTask();
        t.setName(item["Name"]);
        t.setType(item["Type"]);
        t.setDate(Date(item["Date"]));
        t.setStartTime(double.parse(
            item["StartTime"].toString())); // test is data is an int
        t.setDuration(double.parse(item["Duration"].toString()));
        widget = TaskCard(t);
      }
      return widget;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: _getTaskCards(),
        ),
      ),
    );
  }
}
