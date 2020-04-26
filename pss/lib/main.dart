import 'package:flutter/material.dart';
import 'scheduler.dart';
import 'components/task_card.dart';
import 'task.dart';
import 'create/create_task_dialog_renderer.dart';
import 'constants.dart';
import 'date.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PSS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'PSST'),
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
  List<TaskCard> taskList;
  List sched;

  CreateTaskDialogRenderer createTaskDialog;
  @override
  void initState() {
    super.initState();
    //initialize data for page
    scheduler = new Scheduler();
    createTaskDialog = new CreateTaskDialogRenderer(context);
    this.sched = scheduler.getSchedule();
    this.taskList = this.sched.map((item) => new TaskCard(item)).toList();
  }

  // generate task cards
  void _updateState() {
    setState(() {
      this.sched = scheduler.getSchedule();
      this.taskList = this.sched.map((item) => new TaskCard(item)).toList();
    });
  }

  void _createRecurringTask() async {
    // get input from user
    var data = await createTaskDialog.showAddRecurringTaskDialog();
    // create task
    scheduler.createTask(data);
    _updateState();
  }

  void _createTransientTask() async {
    // get input from user
    var data = await createTaskDialog.showAddTransientTaskDialog();
    // create task
    scheduler.createTask(data);
    _updateState();
  }

  void _createAntiTask() async {
    // get input from user
    var data = await createTaskDialog.showAddAntiTaskDialog();
    // create task
    scheduler.createTask(data);
    _updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(children: [
        Center(
          child: Text(
            Date(20210113).getNextDay().getIntDate().toString(),
          ),
        ),
        ...this.taskList,
      ])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => createTaskDialog.showTaskTypesDialogBox(
          () => _createRecurringTask(),
          () => _createTransientTask(),
          () => _createAntiTask(),
        ),
      ),
    );
  }
}
