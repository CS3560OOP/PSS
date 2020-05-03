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
import 'dec_convert.dart';

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
  Map<DateTime, List> _events; // list of events on a certain day
  bool _isSearching; //bool if user is searching for a task

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

    this._sched = scheduler.getSchedule();
    this.taskList = _sched.map((item) => new TaskCard(item)).toList();

    this._isSearching = false;
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
      this.taskList = _sched.map((item) => new TaskCard(item)).toList();
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
        //If user is searching make title be a search bar
        title: !this._isSearching ? Text(widget.title) : _buildSearchBar(),
        actions: <Widget>[
          IconButton(
            icon: Icon(this._isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                this._isSearching = !this._isSearching;
              });
            },
          )
        ],
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
      child: ListView(
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
                            convertTimeToString(
                                event.getStartTime().toString())),
                        Text("Duration: " +
                            decToHours(event.getDuration().toString())),
                        event is AntiTask || event is TransientTask
                            ? Text(
                                "Type: " + event.getDate().getFormattedDate())
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
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(15.0),
        color: Color(0xA0ffffff),
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: "Search by task name",
        ),
        autofocus: false,
        onSubmitted: (String value) {
          _searchTask(value);
        },
      ),
    );
  }

  //TODO: If task not found alert user that task dne
  //Searches for a task by name and sets controller to select the day of the found task
  void _searchTask(String name) {
    List<dynamic> task = scheduler.getNamedEvent(name);
          print(task[0].getName());
          if(task[0] is TransientTask || task[0] is AntiTask) {
            DateTime dt = task[0].getDate().getDateTime();
            int st = task[0].getStartTime().floor();
            dt = new DateTime(dt.year, dt.month, dt.day, st);
            _calendarController.setFocusedDay(task[0].getDate().getDateTime());
            _calendarController.setSelectedDay(task[0].getDate().getDateTime());
          }
          else {
            DateTime dt = task[0].getStartDate().getDateTime();
            double st = task[0].getStartTime();
            double dur = task[0].getDuration();
            _calendarController.setFocusedDay(task[0].getStartDate().getDateTime());
            _calendarController.setSelectedDay(task[0].getStartDate().getDateTime());
          }
          _updateState();
  }
}
