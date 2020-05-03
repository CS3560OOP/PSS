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
  List<dynamic> _sched; // hold Task Objects
  CalendarController _calendarController;

  DialogRenderer createTaskDialog;
  @override
  void initState() {
    super.initState();
    //initialize data for page
    scheduler = new Scheduler();
    createTaskDialog = new DialogRenderer(context);

    // calendar object
    this._calendarController = CalendarController();
    this._sched = scheduler.getDayEvents(DateTime.now());
    this.taskList = _sched.map((item) => new TaskCard(item)).toList();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      _sched = this.scheduler.getSchedule();
      if (_calendarController.selectedDay != null) {
        this._sched = scheduler.getDayEvents(_calendarController.selectedDay);
      } else {
        var visibleDays = _calendarController.visibleDays;
        var start = visibleDays[0];
        var end = _calendarController.visibleDays[visibleDays.length];
        this._sched = scheduler.getEventsBetween(start, end);
      }
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
          _buildEventList(),
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
      availableCalendarFormats: {
        CalendarFormat.month: "View Month",
        CalendarFormat.week: "View Week"
      },
      onDaySelected: (date, events) {
        setState(() {
          this._sched = scheduler.getDayEvents(date);
        });
      },
      onVisibleDaysChanged: (start, end, format) {
        setState(() {
          this._sched = scheduler.getEventsBetween(start, end);
        });
      },
      // onCalendarCreated: _onCalendarCreated,
    );
  }

  /// build widgets to show events for selected day
  // TODO: need to specify what type of view (daily, weekly, monthly)
  Widget _buildEventList() {
    return Expanded(
      child: _sched.isNotEmpty
          ? ListView(
              children: _sched
                  .map((event) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.8),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(event.getName()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Type: " + event.getType()),
                              Text("Start Time: " +
                                  event.getStartTime().toString()),
                              Text("Duration: " +
                                  event.getDuration().toString()),
                              event is AntiTask || event is TransientTask
                                  ? Text("Date: " +
                                      event.getDate().getFormattedDate())
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
            )
          : Center(
              child: Text(
                "Nothing to do!",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
    );
  }
}
