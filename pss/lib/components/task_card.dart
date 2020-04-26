import 'package:flutter/material.dart';
import '../anti_task.dart';
import '../recurring_task.dart';
import '../task.dart';

class TaskCard extends StatefulWidget {
  final Task _task;
  TaskCard(this._task);
  @override
  _TaskCardState createState() => _TaskCardState(_task);
}

class _TaskCardState extends State<TaskCard> {
  final _task;
  String _name;
  String _type;
  String _startTime;
  String _duration;
  String _date;

  String _startDate;
  String _endDate;
  String _frequency;

  Color _color;

  _TaskCardState(this._task) {
    _name = _task.getName().toString();
    _type = _task.getType().toString();
    _startTime = _task.getStartTime().toString();
    _duration = _task.getDuration().toString();
    _color = Colors.amberAccent;
    if (_task is RecurringTask) {
      _startDate = _task.getStartDate().getFormattedDate().toString();
      _endDate = _task.getEndDate().getFormattedDate().toString();
      _frequency = _task.getFrequency().toString();
    } else {
      _task is AntiTask
          ? _color = Colors.redAccent
          : _color = Colors.tealAccent;
      // Anti-Task or Transient-Task
      _date = _task.getDate().getFormattedDate().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      color: _color,
      child: Column(
        children: <Widget>[
          Text("Name: $_name"),
          Text("Type: $_type"),
          Text("Start Time : $_startTime"),
          Text("Duration : $_duration"),
          _date != null ? Text("Date : $_date") : SizedBox(),
          _startDate != null ? Text("Start Date : $_startDate") : SizedBox(),
          _endDate != null ? Text("End Date : $_endDate") : SizedBox(),
          _frequency != null ? Text("Frequency : $_frequency") : SizedBox(),
        ],
      ),
    );
  }
}
