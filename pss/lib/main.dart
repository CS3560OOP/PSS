import 'package:flutter/material.dart';
import 'package:pss/anti_task.dart';
import 'package:pss/recurring_task.dart';
import 'package:pss/transient_task.dart';
import 'scheduler.dart';
import 'components/task_card.dart';
import 'task.dart';
import 'create/dialog_renderer.dart';
import 'constants.dart';
import 'date.dart';
import 'package:table_calendar/table_calendar.dart';

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
  List<dynamic> sched; // hold Task Objects
  CalendarController _calendarController;
  Map<DateTime, List> _events; // list of events on a certain day

  DialogRenderer createTaskDialog;
  @override
  void initState() {
    super.initState();
    //initialize data for page
    scheduler = new Scheduler();
    createTaskDialog = new DialogRenderer(context);

    // calendar object
    this._calendarController = CalendarController();

    this.sched = scheduler.getSchedule();
    this.taskList = sched.map((item) => new TaskCard(item)).toList();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      sched = this.scheduler.getSchedule();
      this.taskList = sched.map((item) => new TaskCard(item)).toList();
    });
  }

  /// CREATE
  void _createTask(String type) async {
    try {
      var data;
      // get input from user
      if (type == "recur")
        data = await createTaskDialog.getNewRecurringTaskData();
      else if (type == "anti")
        data = await createTaskDialog.getNewAntiTaskData();
      else
        data = await createTaskDialog.getNewTransientTaskData();

      scheduler.createTask(data);
      _updateState();
    } catch (e) {
      createTaskDialog.showErrorDialog(e.toString());
    }
  }

  /// TODO: VIEW
  /// Fetch all events for the week
  /// where given day belongs
  List _fetchDayEvents(Date d) {
    return this.sched;
  }

  /// Fetch all events in which this
  List _fetchWeekEvents(Date d) {
    Date start = d.getFirstDateOfWeek();
    Date end = d.getLastDayOfWeek();
    // TODO
    return this.sched;
  }

  /// Fetch all events for the month
  /// where the day day belongs
  List _fetchMonthEvents(Date d) {
    Date start = d.getFirstDateOfMonth();
    Date end = d.getLastDateOfMonth();
    // TODO
    return this.sched;
  }

  /// TODO: EDIT

  /// TODO: DELETE

  /// TODO: FIND

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          _buildTableCalendar(),
          Expanded(child: _buildEventList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => createTaskDialog.showTaskTypesDialogBox(_createTask),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      // onVisibleDaysChanged: _onVisibleDaysChanged,
      // onCalendarCreated: _onCalendarCreated,
    );
  }

  /// build widgets to show events for selected day
  // TODO: need to specify what type of view (daily, weekly, monthly)
  Widget _buildEventList() {
    return ListView(
      children: sched
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.getName()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Type: " + event.getType()),
                      Text("Start Time: " + event.getStartTime().toString()),
                      Text("Duration: " + event.getDuration().toString()),
                      event is AntiTask || event is TransientTask
                          ? Text("Type: " + event.getDate().getFormattedDate())
                          : SizedBox(),
                      event is RecurringTask
                          ? Text("Start Date: " +
                              event.getStartDate().getFormattedDate())
                          : SizedBox(),
                      event is RecurringTask
                          ? Text("End Date: " +
                              event.getEndDate().getFormattedDate())
                          : SizedBox(),
                    ],
                  ),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  /// Fetch all events in which this
  void _onDaySelected(DateTime d, List events) {
    Date date = new Date(int.parse(d.year.toString().padLeft(4, "0") +
        d.month.toString().padLeft(2, "0") +
        d.day.toString().padLeft(2, "0")));
    if (_calendarController.calendarFormat == CalendarFormat.month) {
      setState(() {
        this.sched = _fetchMonthEvents(date);
      });
    } else if (_calendarController.calendarFormat == CalendarFormat.week) {
      setState(() {
        this.sched = _fetchWeekEvents(date);
      });
    } else {
      if (events.isEmpty) {
        setState(() {
          this.sched = _fetchDayEvents(date);
        });
      }
    }
  }
}
