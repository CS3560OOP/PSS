import 'package:flutter_test/flutter_test.dart';
import 'package:pss/anti_task.dart';
import 'package:pss/recurring_task.dart';
import 'package:pss/transient_task.dart';
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
      final newTaskDate = 20200429;
      final sched = [
        new RecurringTask(
            "Dinner", "Meal", 8.0, 1.0, Date(newTaskDate), Date(20200507), 7),
        new TransientTask(
            "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
        new TransientTask(
            "Intern Interview", "Appointment", 12.0, 1.0, Date(newTaskDate)),
        new TransientTask(
            "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
        new TransientTask(
            "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
      ].toList();
      final task = {
        "Name": "CS3560-Tu",
        "Type": "Class",
        "StartDate": 20200414,
        "StartTime": 19,
        "Duration": 1.25,
        "EndDate": 20200505,
        "Frequency": 7
      };
      expect(validator.isValidTask(sched, task), true);
    });
  });

  test("isValidTask() invalid task : invalid name : value should be false", () {
    final newTaskDate = 20200429;
    final sched = [
      new RecurringTask(
          "Dinner", "Meal", 8.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 1.0, Date(newTaskDate)),
      new TransientTask(
          "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    final task = {
      "Name": "intern interview",
      "Type": "Appointment",
      "StartDate": 20200414,
      "StartTime": 19,
      "Duration": 1.25,
      "EndDate": 20200505,
      "Frequency": 7
    };
    expect(validator.isValidTask(sched, task), false);
  });

  test("isValidTaskName() value should be true", () {
    final newTaskDate = 20200429;
    final sched = [
      new RecurringTask(
          "Dinner", "Meal", 8.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 1.0, Date(newTaskDate)),
      new TransientTask(
          "Going to School", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    expect(
        Validator().isValidTaskName(sched, "going to school backyard"), true);
  });

  test("isValidTaskName() value should be false", () {
    final newTaskDate = 20200429;
    final sched = [
      new RecurringTask(
          "Dinner", "Meal", 8.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 1.0, Date(newTaskDate)),
      new TransientTask(
          "Going to School", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    expect(Validator().isValidTaskName(sched, "Intern Interview"), false);
  });

  test("isValidTaskFrequency() value should be true", () {
    expect(Validator().isValidTaskFrequency(1), true);
  });
  test("isValidTaskFrequency() value should be true", () {
    expect(Validator().isValidTaskFrequency(7), true);
  });
  test("isValidTaskFrequency() value should be true", () {
    expect(Validator().isValidTaskFrequency(30), true);
  });
  test("isValidTaskFrequency() value should be false", () {
    expect(Validator().isValidTaskFrequency(128), false);
  });

  test("isValidTaskTime() value should be true", () {
    expect(Validator().isValidTaskTime(23.25), true);
  });
  test("isValidTaskTime() value should be false", () {
    expect(Validator().isValidTaskTime(12.60), false);
  });

  test("isValidTaskDuration() value should be true", () {
    expect(Validator().isValidTaskDuration(3.25), true);
  });
  test("isValidTaskDuration() value should be false", () {
    expect(Validator().isValidTaskDuration(2.60), false);
  });

  test("hasNoTimeOverlap() adding new Transient task : value should be true",
      () {
    final newTaskDate = 20200429;
    // start = 1:00, end = 3:30
    final newTask = new TransientTask(
        "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
    final sched = [
      new RecurringTask(
          "Dinner", "Meal", 8.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 1.0, Date(newTaskDate)),
      new TransientTask(
          "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    expect(Validator().hasNoTimeOverlap(sched, newTask), true);
  });

  test(
      "hasNoTimeOverlap() adding new Transient task with conflict recurring task : value should be false",
      () {
    final newTaskDate = 20200429;
    // start = 1:00, end = 3:30
    final newTask = new TransientTask(
        "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
    final sched = [
      new RecurringTask("Dinner", "Meal", 12.0, 2.0, Date(newTaskDate - 10),
          Date(20200510), 1), // conflict task
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 1.0, Date(newTaskDate)),
      new TransientTask(
          "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    expect(Validator().hasNoTimeOverlap(sched, newTask), false);
  });

  test("hasNoTimeOverlap() adding new Transient task : value should be false",
      () {
    final newTaskDate = 20200429;
    // start = 1:00, end = 3:30
    final newTask = new TransientTask(
        "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
    final sched = [
      new RecurringTask(
          "Dinner", "Meal", 10.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    expect(Validator().hasNoTimeOverlap(sched, newTask), false);
  });

  test("hasNoTimeOverlap() adding new Anti task : value should be false", () {
    final newTaskDate = 20200429;
    // start = 1:00, end = 3:30
    final newTask = new AntiTask(
        "Cancel Dinner", "Cancellation", 10.0, 1.0, Date(newTaskDate));
    final sched = [
      new RecurringTask(
          "Dinner", "Meal", 10.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    expect(Validator().hasNoTimeOverlap(sched, newTask), false);
  });

  test("hasNoTimeOverlap() adding new Anti task : value should be false", () {
    final newTaskDate = 20200429;
    // start = 1:00, end = 3:30
    final newTask = new AntiTask(
        "Cancel Dinner", "Cancellation", 10.0, 1.0, Date(newTaskDate));
    final sched = [
      new RecurringTask("Dinner", "Meal", 10.0, 1.0, Date(newTaskDate - 3),
          Date(20200507), 1),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 12.0, 2.0, Date(newTaskDate)),
      new TransientTask(
          "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate))
    ].toList();
    expect(Validator().hasNoTimeOverlap(sched, newTask), false);
  });

  test(
      "getDateOverlaps() adding new Transient task : value should be list of all existing tasks",
      () {
    final newTaskDate = 20200429;

    // start = 1:00, end = 3:30
    final newTask = new TransientTask(
        "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));

    var sched = [
      new RecurringTask(
          "Dinner", "Meal", 10.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new RecurringTask("Dinner", "Meal", 17.0, 1.0, Date(newTaskDate - 7),
          Date(20200507), 7),
      new RecurringTask(
          "Homework", "Study", 15.0, 1.0, Date(20200428), Date(20200507), 1),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 1.5, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 17.0, 2.5, Date(newTaskDate)),
    ].toList();

    var res = Validator().getDateOverlaps(sched, newTask);
    expect(res.length, 5);
  });

  test("getDateOverlaps() adding new Transient task : value should be 3", () {
    final newTaskDate = 20200429;
    // start = 1:00, end = 3:30
    final newTask = new TransientTask(
        "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));

    var sched = [
      new RecurringTask("Dinner", "Meal", 17.0, 1.0, Date(newTaskDate - 7),
          Date(20200507), 7),
      new RecurringTask("Homework", "Study", 15.0, 1.0, Date(newTaskDate - 1),
          Date(20200507), 1),
      new AntiTask(
          "Cancel Dinner", "Cancellation", 17.0, 1.0, Date(newTaskDate)),
      new AntiTask(
          "Cancel Homework", "Cancellation", 15.0, 1.0, Date(newTaskDate)),
      new RecurringTask(
          "Dinner", "Meal", 10.0, 1.0, Date(newTaskDate), Date(20200507), 7),
      new TransientTask(
          "Going to Mall", "Shopping", 10.0, 1.5, Date(newTaskDate)),
      new TransientTask(
          "Intern Interview", "Appointment", 17.0, 2.5, Date(newTaskDate)),
    ].toList();

    var res = Validator().getDateOverlaps(sched, newTask);
    expect(res.length, 3);
  });
}
