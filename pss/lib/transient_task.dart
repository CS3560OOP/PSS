import 'task.dart';
import 'date.dart';

class TransientTask extends Task {
  //class properties
  Date _date;
  TransientTask(
      String name, String type, double startTime, double duration, this._date)
      : super(name, type, startTime, duration);

  //class methods (accessors and mutators)
  void setDate(Date d) {
    _date = d;
  }

  Date getDate() {
    return _date;
  }
}
