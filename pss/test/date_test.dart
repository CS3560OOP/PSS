import 'package:flutter_test/flutter_test.dart';
import 'package:pss/date.dart';

// Date Test Class
main() {
  final date = Date(20200313);
  group("Date Class => ", () {
    test("getYear() value should be 2020", () {
      var res = date.getYear();
      expect(res, 2020);
    });

    test("getMonth() value should be 3", () {
      var res = date.getMonth();
      expect(res, 3);
    });

    test("getDay() value should be 13", () {
      var res = date.getDay();
      expect(res, 13);
    });

    test("getMonthName() value should be March", () {
      var res = date.getMonthName();
      expect(res, "March");
    });

    test("getFormattedDate() value should be March 13, 2020", () {
      var res = date.getFormattedDate();
      expect(res, "March 13, 2020");
    });

    test("getIntDate() value should be 20200313", () {
      var res = date.getIntDate();
      expect(res, 20200313);
    });

    test("setYear(2013) year should change to 2013", () {
      date.setYear(2013);
      var res = date.getYear();
      expect(res, 2013);
    });
    test("setMonth(10) month should change to 3", () {
      date.setMonth(10);
      var res = date.getMonth();
      expect(res, 10);
    });

    test("setDay(11) day should change to 11", () {
      date.setDay(11);
      var res = date.getDay();
      expect(res, 11);
    });
  });
}
