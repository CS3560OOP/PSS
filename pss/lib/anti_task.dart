import 'task.dart';
import 'date.dart';

class AntiTask extends Task {
  //class properties
  Date _date;
  AntiTask(
      String name, String type, double startTime, double duration, this._date)
      : super(name, type, startTime, duration);

  // constructor to take json file
  AntiTask.fromJson(Map<String, dynamic> json) : super.empty() {
    this.setName(json['Name']);
    this.setType(json['Type']);
    _date = json['Date'];
    this.setStartTime(json['StartTime']);
    this.setDuration(json['Duration']);
  }

  Map<String, dynamic> toJson() => {
        'Name': this.getName(),
        'Type': this.getType(),
        'Date': _date.getIntDate(),
        'StartTime': this.getStartTime(),
        'Duration': this.getDuration(),
      };

  //class methods (accessors and mutators)
  void setDate(Date d) {
    _date = d;
  }

  Date getDate() {
    return _date;
  }
}
