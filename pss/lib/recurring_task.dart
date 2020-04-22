import 'task.dart';
import 'date.dart';

class RecurringTask extends Task {
  //class properties
  Date _startDate;
  Date _endDate;
  int _frequency;

  //constructor
  RecurringTask(String name, String type, double startTime, double duration,
      this._startDate, this._endDate, this._frequency)
      : super(name, type, startTime, duration);

  // constructor to take json file
  RecurringTask.fromJson(Map<String, dynamic> json) : super.empty() {
    this.setName(json['Name']);
    this.setType(json['Type']);
    _startDate = json['StartDate'];
    this.setStartTime(json['StartTime']);
    this.setDuration(json['Duration']);
    _endDate = json['EndDate'];
    _frequency = json['Frequency'];
  }

  Map<String, dynamic> toJson() => {
        'Name': this.getName(),
        'Type': this.getType(),
        'StartDate': _startDate.getIntDate(),
        'StartTime': this.getStartTime(),
        'Duration': this.getDuration(),
        'EndDate': _endDate.getIntDate(),
        'Frequency': _frequency,
      };

  //class methods (accessors and mutators)
  void setStartDate(Date s) {
    _startDate = s;
  }

  Date getStartDate() {
    return _startDate;
  }

  void setEndDate(Date e) {
    _endDate = e;
  }

  Date getEndDate() {
    return _endDate;
  }

  void setFrequency(int f) {
    _frequency = f;
  }

  int getFrequency() {
    return _frequency;
  }
}
