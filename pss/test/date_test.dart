import 'package:flutter_test/flutter_test.dart';
import 'package:pss/date.dart';

// Date Test Class
main() {
  group("Date Class => ", () {
    test("getYear() value should be 2020", () {
      var date = Date(20200313);
      var res = date.getYear();
      expect(res, 2020);
    });

    test("getMonth() value should be 3", () {
      final date = Date(20200313);
      var res = date.getMonth();
      expect(res, 3);
    });

    test("getDay() value should be 13", () {
      final date = Date(20200313);
      var res = date.getDay();
      expect(res, 13);
    });

    test("getMonthName() value should be March", () {
      final date = Date(20200313);
      var res = date.getMonthName();
      expect(res, "March");
    });

    test("getFormattedDate() value should be March 13, 2020", () {
      final date = Date(20250313);
      var res = date.getFormattedDate();
      expect(res, "March 13, 2025");
    });

    test("getIntDate() value should be 20200313", () {
      final date = Date(20200313);
      var res = date.getIntDate();
      expect(res, 20200313);
    });

    test("setYear(2013) year should change to 2013", () {
      final date = Date(20200313);
      date.setYear(2013);
      var res = date.getYear();
      expect(res, 2013);
    });
    test("setMonth(10) month should change to 3", () {
      final date = Date(20200313);
      date.setMonth(10);
      var res = date.getMonth();
      expect(res, 10);
    });

    test("setDay(11) day should change to 11", () {
      final date = Date(20200313);
      date.setDay(11);
      var res = date.getDay();
      expect(res, 11);
    });

    test("getNextDate() value should be 20200102", () {
      var date = Date(20200101);
      expect(date.getNextDayDate().getIntDate(), 20200102);
    });

    test("at last day of the year : getNextDate() value should be 20210101",
        () {
      var date = new Date(20201231);
      expect(date.getNextDayDate().getIntDate(), 20210101);
    });

    test("at last day of the month : getNextDate() should return 20190201", () {
      var date = new Date(20200131);
      expect(date.getNextDayDate().getIntDate(), 20200201);
    });

    test("Leap Year : getLastDateOfMonth() should return 20200229", () {
      var date = new Date(20200205);
      expect(date.getLastDateOfMonth().getIntDate(), 20200229);
    });

    test("NOT Leap year : getLastDateOfMonth() value should be 20210228", () {
      var date = Date(20210201);

      expect(date.getLastDateOfMonth().getIntDate(), 20210228);
    });

    test("getLastDateOfMonth() value should be 20200430", () {
      var date = Date(20200510);
      expect(date.getLastDateOfMonth().getIntDate(), 20200531);
    });

    test("isLastDayOfMonth() value should be true", () {
      var date = Date(20200131);
      expect(date.isLastDayOfMonth(), true);
    });

    test("Leap year : isLastDayOfMonth() value should be true", () {
      var date = Date(20200229);
      expect(date.isLastDayOfMonth(), true);
    });

    test("isLastDayOfMonth() value should be false", () {
      var date = Date(20210110);
      expect(date.isLastDayOfMonth(), false);
    });

    test("getNextWeekDate() value should be 20200303", () {
      var date = Date(20200225);
      expect(date.getNextWeekDate().getIntDate(), 20200303);
    });

    test("getNextWeekDate() leap year value should be 20200217", () {
      var date = Date(20200210);
      expect(date.getNextWeekDate().getIntDate(), 20200217);
    });

    test("getNextWeekDate() not leap year value should be 20200302", () {
      var date = Date(20210223);
      expect(date.getNextWeekDate().getIntDate(), 20210302);
    });

    test("getNextWeekDate() not leap year value should be 20210201", () {
      var date = Date(20210125);
      expect(date.getNextWeekDate().getIntDate(), 20210201);
    });

    test("getNextWeekDate() not leap year value should be 20210104", () {
      var date = Date(20201228);
      expect(date.getNextWeekDate().getIntDate(), 20210104);
    });

    test("getNextMonthDate() 20200425 value should be 20200525", () {
      var date = Date(20200425);
      expect(date.getNextMonthDate().getIntDate(), 20200525);
    });

    test("getNextMonthDate() 20201225 value should be 20210125", () {
      var date = Date(20201225);
      expect(date.getNextMonthDate().getIntDate(), 20210125);
    });
  });
}
