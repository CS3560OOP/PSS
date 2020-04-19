import 'task.dart';

class RecurringTask extends Task {
  //class properties
  int _startDate;
  int _endDate;
  int _frequency;

  //constructor
  RecurringTask(String n, String t, int sD, double sT, double d, int e, int f) {
    this.setName(n);
    this.setType(t);
    _startDate = sD;
    this.setStartTime(sT);
    this.setDuration(d);
    _endDate = e;
    _frequency = f;
  }

  RecurringTask.fromJson(Map<String, dynamic> json){
    _startDate = json['StartDate'];
    _endDate = json['EndDate'];
    _frequency = json['Frequency'];
    this.setName(json['Name']);
    this.setType(json['Type']);
    this.setStartTime(json['StartTime']);
    this.setDuration(json['Duration']);
  }
    
  
  Map<String, dynamic> toJson() => {
    'Name' : this.getName(),
    'Type' : this.getType(),
    'StartDate' : _startDate,
    'StartTime' : this.getStartTime(),
    'Duration' : this.getDuration(),
    'EndDate' : _endDate,
    'Frequency' : _frequency,
  };


  //class methods (accessors and mutators)
  void setStartDate(int s) {
    _startDate = s;
  }

  int getStartDate() {
    return _startDate;
  }

  void setEndDate(int e) {
    _endDate = e;
  }

  int getEndDate() {
    return _endDate;
  }

  void setFrequency(int f) {
    _frequency = f;
  }

  int getFrequency() {
    return _frequency;
  }
}
