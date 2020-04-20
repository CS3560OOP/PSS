import 'task.dart';
import 'date.dart';

class RecurringTask extends Task {
  //class properties
  Date _startDate;
  Date _endDate;
  int _frequency;

  //constructor
  RecurringTask(
      String n, String t, Date sD, double sT, double d, Date eD, int f) {
    _startDate = sD;
    _endDate = eD;
    _frequency = f;
    this.setName(n);
    this.setType(t);
    this.setStartTime(sT);
    this.setDuration(d);
  }

  RecurringTask.fromJson(Map<String, dynamic> json) {
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _frequency = json['Frequency'];
    this.setName(json['Name']);
    this.setType(json['Type']);
    this.setStartTime(json['StartTime']);
    this.setDuration(json['Duration']);
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
