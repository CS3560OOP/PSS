import 'package:flutter/material.dart';
import 'package:pss/anti_task.dart';
import 'package:pss/recurring_task.dart';
import 'package:pss/transient_task.dart';
import 'create/dialog_renderer.dart';
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

  List<dynamic> _sched; // hold Task Objects
  CalendarController _calendarController;
  bool _isSearching; //bool if user is searching for a task
  DialogRenderer dialog;

  @override
  void initState() {
    super.initState();
    //initialize data for page
    scheduler = new Scheduler();
    dialog = new DialogRenderer(context);

    // calendar object
    this._calendarController = CalendarController();

    // initialize task to current day
    this._sched = scheduler.getDayEvents(DateTime.now());
    this._isSearching = false;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
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
        data = await dialog.getNewRecurringTaskData();
      else if (type == "anti")
        data = await dialog.getNewAntiTaskData();
      else
        data = await dialog.getNewTransientTaskData();
      await scheduler.createTask(data);
      _updateState();
    } catch (e) {
      dialog.showErrorDialog(e.toString());
    }
  }

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
              }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_buildReadButton(), _buildWriteButton()],
          ),
          _buildTableCalendar(),
          _sched.isNotEmpty
              ? _buildEventList()
              : Center(
                  child: Text(
                    "Nothing to do",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => dialog.showTaskTypesDialogBox(_createTask),
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
        CalendarFormat.month: "View Week",
        CalendarFormat.week: "View Month"
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
    );
  }

  Widget _buildWriteButton() {
    return RaisedButton(
      color: Colors.red[800],
      child: Text(
        "Write Schedule",
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      onPressed: () {
        dialog.showFilenameDialog().then((val) {
          scheduler.writeToFile(val);
        }).catchError((e) {
          dialog.showErrorDialog(e.toString());
        });
      },
    );
  }

  Widget _buildReadButton() {
    return RaisedButton(
      color: Colors.blue[800],
      child: Text(
        "Read Schedule",
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      onPressed: () {
        dialog.showFilenameDialog().then((val) {
          try {
            scheduler.readFromFile(val);
            _updateState();
          } catch (e) {
            dialog.showErrorDialog(e.toString());
          }
        }).catchError((e) {
          dialog.showErrorDialog(e.toString());
        });
      },
    );
  }

  /// build widgets to show events for selected day
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
                    onTap: () => dialog.showEditDialog(_editTask, event),
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

  //Searches for a task by name and sets controller to select the day of the found task
  void _searchTask(String name) {
    List<dynamic> task = scheduler.getNamedEvent(name);
    if (task.isNotEmpty) {
      setState(() {
        if (task[0] is TransientTask || task[0] is AntiTask) {
          DateTime dt = task[0].getDate().getDateTime();
          int st = task[0].getStartTime().floor();
          dt = new DateTime(dt.year, dt.month, dt.day, st);
          _calendarController.setFocusedDay(task[0].getDate().getDateTime());
          _calendarController.setSelectedDay(task[0].getDate().getDateTime());
        } else {
          DateTime dt = task[0].getStartDate().getDateTime();
          int st = task[0].getStartTime().floor();
          dt = new DateTime(dt.year, dt.month, dt.day, st);
          _calendarController
              .setFocusedDay(task[0].getStartDate().getDateTime());
          _calendarController
              .setSelectedDay(task[0].getStartDate().getDateTime());
        }
        this._sched = task;
      });
    } else {
      DialogRenderer(context).showErrorDialog("Task does not exist yet.");
    }
  }

  //Input: isEdit if editing the task
  //       oldTask task to be edited or deleted
  void _editTask(bool isDelete, bool isEdit, Task oldTask) async {
    //Delete task
    if (isDelete) {
      await _deleteTask(oldTask);
      _updateState();
    }
    //If isEdit then create new task with newly edited properties
    if (isEdit) {
      try {
        var data = await dialog.getEditTaskData(oldTask);
        if (data["Delete"] != null) {
          await _deleteTask(oldTask);
        }
        scheduler.createTask(data);
        _updateState();
      } catch (e) {
        dialog.showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _deleteTask(Task task) async {
    await scheduler.deleteTask(task);
  }
}
