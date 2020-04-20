import 'task.dart';
import 'date.dart';

class AntiTask extends Task {
  //class properties
  Date _date;
  AntiTask(
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
