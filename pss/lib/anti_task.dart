import 'task.dart';
import 'date.dart';

class AntiTask extends Task {
  //class properties
  Date _date;

  //class methods (accessors and mutators)
  void setDate(Date d) {
    _date = d;
  }

  Date getDate() {
    return _date;
  }
}
