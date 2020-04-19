import 'package:intl/intl.dart';

class Date {
  int _year;
  int _month;
  int _day;
  DateTime _date;

  Date(int date) {
    this._year = date ~/ 10000;
    this._month = (date % 100000) ~/ 100;
    this._day = date % 100;
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

  int getYear() => this._year;

  int getMonth() => this._month;

  int getDay() => this._day;

  int getIntDate() => this._year * 10000 + this._month * 100 + this._day;

  void _updateDate() {
    this._date = DateTime(this._year, this._month, this._day);
  }

  // formatted getters
  String getFormattedDate() => DateFormat.yMMMMd().format(this._date);

  String getWeekday() => DateFormat.EEEE().format(this._date);

  String getMonthName() => DateFormat.MMMM().format(this._date);
}
