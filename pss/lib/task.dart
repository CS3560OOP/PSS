class Task {
  //class properties
  String _name;
  String _type;
  double _startTime;
  double _duration;

  //constructors
  Task(this._name, this._type, this._startTime, this._duration);
  Task.empty(); //empty constructor

  // Task.fromJson(Map<String, dynamic> json)
  //   : _name = json['Name'],
  //     _type = json['Type'],
  //     _startTime = json['StartTime'],
  //     _duration = json['Duration'];

  // Map<String, dynamic> toJson() => {
  //   'Name' : _name,
  //   'Type' : _type,
  //   'StartTime' : _startTime,
  //   'Duration': _duration,
  // };

  //class methods (accessors and mutators)
  void setName(String n) {
    _name = n;
  }

  String getName() {
    return _name;
  }

  void setType(String t) {
    _type = t;
  }

  String getType() {
    return _type;
  }

  void setStartTime(double t) {
    _startTime = t;
  }

  double getStartTime() {
    return _startTime;
  }

  void setDuration(double d) {
    _duration = d;
  }

  double getDuration() {
    return _duration;
  }

  //

}
