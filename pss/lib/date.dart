import 'package:intl/intl.dart';
import 'package:pss/validator.dart';

class Date {
  int _year;
  int _month;
  int _day;
  DateTime _dateTime;

  Date(int d) {
    this._year = d ~/ 10000;
    this._month = ((d % 10000) ~/ 100);
    this._day = d % 100;
    this._dateTime = DateTime(this._year, this._month, this._day);
  }

  Date.dateTime(DateTime d) {
    this._year = d.year;
    this._month = d.month;
    this._day = d.day;
    this._dateTime = DateTime(this._year, this._month, this._day);
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
    this._dateTime = DateTime(this._year, this._month, this._day);
  }

  DateTime getDateTime() => this._dateTime;

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
  String getFormattedDate() => DateFormat.yMMMMd().format(this._dateTime);

  String getWeekday() => DateFormat.EEEE().format(this._dateTime);

  String getMonthName() => DateFormat.MMMM().format(this._dateTime);

  /// returns a tomorrow's date
  /// if not a valid date
  /// returns the last day of that month
  Date getNextDayDate() {
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

  Date getNextWeekDate() {
    int y = getYear();
    int m = getMonth();
    int d;
    Date newDate;

    if (isLastWeekOfTheYear()) {
      y++;
      d = 1 + (7 - ((getLastDateOfMonth().getDay() - getDay()) + 1));
      var date = int.parse(
          y.toString().padLeft(4, "0") + "01" + d.toString().padLeft(2, "0"));
      newDate = new Date(date);
    } else if (isLastWeekOfTheMonth()) {
      m++;
      // calculates the day overflowing next month
      d = 1 + (7 - ((getLastDateOfMonth().getDay() - getDay()) + 1));
      var date = int.parse(y.toString().padLeft(4, "0") +
          m.toString().padLeft(2, "0") +
          d.toString().padLeft(2, "0"));
      newDate = new Date(date);
    } else {
      newDate = new Date(getIntDate() + 7);
    }
    return newDate;
  }

  Date getNextMonthDate() {
    int y = getYear();
    int m = getMonth();
    int d = getDay();
    Date newDate;

    if (getMonth() == 12) {
      y++;
      m = 1;
      var date = int.parse(y.toString().padLeft(4, "0") +
          m.toString().padLeft(2, "0") +
          d.toString().padLeft(2, "0"));
      newDate = new Date(date);
    } else {
      m++;
      var date = int.parse(y.toString().padLeft(4, "0") +
          m.toString().padLeft(2, "0") +
          d.toString().padLeft(2, "0"));
      newDate = new Date(date);
    }

    return newDate;
  }

  bool isLastWeekOfTheMonth() {
    if (getLastDateOfMonth().getDay() == 28) {
      if (getDay() >= 22) return true;
    } else if (getLastDateOfMonth().getDay() == 29) {
      if (getDay() >= 23) return true;
    } else if (getLastDateOfMonth().getDay() == 30) {
      if (getDay() >= 24) return true;
    } else if (getLastDateOfMonth().getDay() == 31) {
      if (getDay() >= 25) return true;
    }
    return false;
  }

  bool isLastWeekOfTheYear() {
    if (getDay() > 24 && getMonth() == 12)
      return true;
    else
      return false;
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

  /// returns the last day of the month
  Date getLastDateOfMonth() {
    var y = this.getYear();
    var m = this.getMonth();
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

    return new Date(int.parse(
        y.toString().padLeft(4, "0") + m.toString().padLeft(2, "0") + d));
  }

  /// returns the first date of the month
  Date getFirstDateOfMonth() {
    var y = this.getYear().toString().padLeft(4, "0");
    var m = this.getMonth().toString().padLeft(2, "0");
    var d = "01";
    return new Date(int.parse("$y$m$d"));
  }

  /// returns the first day of this week
  Date getFirstDateOfWeek() {
    var date = new Date(this.getIntDate());
    if (this.getDay() <= 7)
      date.setDay(1);
    else if (this.getDay() <= 14)
      date.setDay(8);
    else if (this.getDay() <= 21)
      date.setDay(15);
    else
      date.setDay(22);
    return date;
  }

  /// returns the first day of this week
  Date getLastDayOfWeek() {
    var date = new Date(this.getIntDate());
    if (this.getDay() <= 7)
      date.setDay(7);
    else if (this.getDay() <= 14)
      date.setDay(14);
    else if (this.getDay() <= 21)
      date.setDay(21);
    else
      date = getLastDateOfMonth();
    return date;
  }
}
