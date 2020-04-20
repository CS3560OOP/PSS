import 'package:flutter/material.dart';
import 'task_object_generator.dart';
import 'scheduler.dart';
import 'components/task_card.dart';
import 'task.dart';
import 'testData/test_data.dart' as data;
import 'validator.dart';

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
  Widget taskList;
  @override
  void initState() {
    super.initState();
    //initialize data for page
    scheduler = new Scheduler();
  }

  // TEST DATA ONLY
  final tasks = data.TestData.set1;

  // generate task cards
  List<TaskCard> _getTaskCards() {
    final generator = TaskObjectGenerator();
    final validator = Validator();
    var list = tasks.map((item) {
      Task task;
      if (validator.isValidReccurringTask(item)) {
        task = generator.generateTask(item);
      } else {
        print("Invalid Task : $item");
      }
      return TaskCard(task);
    }).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(children: _getTaskCards()),
      ),
    );
  }
}
