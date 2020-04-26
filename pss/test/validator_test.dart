import 'package:flutter_test/flutter_test.dart';
import 'package:pss/validator.dart';
import 'package:pss/date.dart';

main() {
  final validator = Validator();

  group("Validator Class : validating Date Class => ", () {
    test("isValidDate() value should be TRUE", () {
      final date = 20200313;
      expect(validator.isValidDate(Date(date)), true);
    });

    test("isValidDate() invalid day : value should be FALSE", () {
      final date = 20200350;
      expect(validator.isValidDate(Date(date)), false);
    });

    test("isValidDate() invalid month : value should be FALSE", () {
      final date = 20201410;
      expect(validator.isValidDate(Date(date)), false);
    });

    test("isValidDate() invalid year : value should be FALSE", () {
      final date = 550350;
      expect(validator.isValidDate(Date(date)), false);
    });

    test("isValidDate() leap year : value should be TRUE", () {
      final date = 20200229;
      expect(validator.isValidDate(Date(date)), true);
    });

    test("isValidDate() not leap year : value should be FALSE", () {
      final date = 20210229;
      expect(validator.isValidDate(Date(date)), false);
    });

    test("isValidTask() valid task : value should be true", () {
      final task = {
        "Name": "CS3560-Tu",
        "Type": "Class",
        "StartDate": 20200414,
        "StartTime": 19,
        "Duration": 1.25,
        "EndDate": 20200505,
        "Frequency": 7
      };
      expect(validator.isValidTask(task), true);
    });
  });
}