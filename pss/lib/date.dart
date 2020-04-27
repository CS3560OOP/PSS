import 'package:intl/intl.dart';
import 'validator.dart';

class Date {
  int _year;
  int _month;
  int _day;
  DateTime _date;

  Date(int d) {
    this._year = d ~/ 10000;
    this._month = ((d % 10000) ~/ 100);
    this._day = d % 100;
    this._date = DateTime(this._year, this._month, this._day);
  }

  // setters and getters
  void setYear(int y) {
    this._year = y;
    _updateDate();
  }

  void setMonth(int m) {
    this._month = m;
    _updateDate();
  }

  void setDay(int d) {
    this._day = d;
    _updateDate();
  }

  void _updateDate() {
    this._date = DateTime(this._year, this._month, this._day);
  }

  int getYear() => this._year;

  int getMonth() => this._month;

  int getDay() => this._day;

  int getIntDate() {
    int y = this._year;
    int m = this._month;
    int d = this._day;
    return int.parse(y.toString().toString().padLeft(2, "0") +
        m.toString().toString().padLeft(2, "0") +
        d.toString().padLeft(2, "0"));
  }

  // formatted getters
  String getFormattedDate() => DateFormat.yMMMMd().format(this._date);

  String getWeekday() => DateFormat.EEEE().format(this._date);

  String getMonthName() => DateFormat.MMMM().format(this._date);

  /// returns a tomorrow's date
  /// if not a valid date
  /// returns the last day of that month
  Date getNextDay() {
    int y = getYear();
    int m = getMonth();
    Date newDate;
    if (isLastDayOfYear()) {
      y++;
      var date = int.parse(y.toString().padLeft(4, "0") + "0101");
      newDate = new Date(date);
    } else if (isLastDayOfMonth()) {
      m++;
      var date = int.parse(
          y.toString().padLeft(4, "0") + m.toString().padLeft(2, "0") + "01");
      newDate = new Date(date);
    } else {
      newDate = new Date(getIntDate() + 1);
    }
    return newDate;
  }

  bool isLastDayOfMonth() {
    var d = this.getDay();
    var last = this.getLastDateOfMonth().getDay();
    if (d == last)
      return true;
    else
      return false;
  }

  bool isLastDayOfYear() {
    var d = this.getDay();
    var m = this.getMonth();
    if ("$m$d" == "1231")
      return true;
    else
      return false;
  }

  Date getLastDateOfMonth() {
    var y = this.getYear().toString().padLeft(4, "0");
    var m = this.getMonth().toString().padLeft(2, "0");
    var d;

    if (this.getMonth() == 2) {
      // leap year
      d = this.getYear() % 4 == 0 ? 29 : 28;
    } else if ([4, 6, 9, 11].contains(m)) {
      // apr, june, sept, nov
      d = 30;
    } else {
      // remaining months
      d = 31;
    }
    d = d.toString().padLeft(2, "0");
    return new Date(int.parse("$y$m$d"));
  }
}
