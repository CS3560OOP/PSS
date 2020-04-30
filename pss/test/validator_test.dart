import 'package:flutter_test/flutter_test.dart';
import 'package:pss/anti_task.dart';
import 'package:pss/recurring_task.dart';
import 'package:pss/transient_task.dart';
import 'package:pss/validator.dart';
import 'package:pss/date.dart';

main() {
  final validator = Validator();
  group("Validator Class => ", () {
    group("isValidDate()", () {
      test("value should be TRUE", () {
        final date = 20200313;
        expect(validator.isValidDate(Date(date)), true);
      });

      test("invalid day : value should be FALSE", () {
        final date = 20200350;
        expect(validator.isValidDate(Date(date)), false);
      });

      test("invalid month : value should be FALSE", () {
        final date = 20201410;
        expect(validator.isValidDate(Date(date)), false);
      });

      test("invalid year : value should be FALSE", () {
        final date = 550350;
        expect(validator.isValidDate(Date(date)), false);
      });

      test("leap year : value should be TRUE", () {
        final date = 20200229;
        expect(validator.isValidDate(Date(date)), true);
      });

      test("not leap year : value should be FALSE", () {
        final date = 20210229;
        expect(validator.isValidDate(Date(date)), false);
      });
    });

    group("isValidTask() ", () {
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
      test("isValidTask() valid task : value should be TRUE", () {
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
      test("isValidTask() invalid name : value should be FALSE", () {
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
    });

    group("isValidTask() ", () {
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

      test("isValidTaskName() value should be TRUE", () {
        expect(Validator().isValidTaskName(sched, "going to school backyard"),
            true);
      });
      test("isValidTaskName() value should be FALSE", () {
        expect(Validator().isValidTaskName(sched, "Intern Interview"), false);
      });
    });

    group("isValidTaskFrequency()  testing", () {
      test("value should be TRUE", () {
        expect(Validator().isValidTaskFrequency(1), true);
      });
      test("value should be TRUE", () {
        expect(Validator().isValidTaskFrequency(7), true);
      });
      test("value should be TRUE", () {
        expect(Validator().isValidTaskFrequency(30), true);
      });
      test("value should be FALSE", () {
        expect(Validator().isValidTaskFrequency(128), false);
      });
    });

    group("isValidTaskTime() ", () {
      test("isValidTaskTime() value should be TRUE", () {
        expect(Validator().isValidTaskTime(23.25), true);
      });
      test("isValidTaskTime() value should be FALSE", () {
        expect(Validator().isValidTaskTime(12.60), false);
      });

      test("isValidTaskDuration() value should be TRUE", () {
        expect(Validator().isValidTaskDuration(3.25), true);
      });
      test("isValidTaskDuration() value should be FALSE", () {
        expect(Validator().isValidTaskDuration(2.60), false);
      });
    });

    group("hasNoTimeOverlap() => ", () {
      final newTaskDate = 20200429;
      // start = 1:00, end = 3:30
      final sched = [
        new RecurringTask("Breakfast", "Meal", 10.0, 1.0, Date(newTaskDate),
            Date(20200507), 7),
        new RecurringTask("Dinner", "Meal", 12.0, 2.0, Date(newTaskDate - 5),
            Date(20200510), 1), // conflict task
        new RecurringTask(
            "Dinner", "Meal", 8.0, 1.0, Date(newTaskDate), Date(20200507), 7),
        new TransientTask(
            "Going to Mall", "Shopping", 10.0, 2.0, Date(newTaskDate)),
        new TransientTask(
            "Intern Interview", "Appointment", 12.0, 1.0, Date(newTaskDate)),
        new TransientTask(
            "Going to Mall", "Shopping", 16.5, 3.0, Date(newTaskDate)),
        new TransientTask(
            "Intern Interview", "Appointment", 20.5, 2.5, Date(newTaskDate)),
        new AntiTask(
            "Cancel Dinner", "Cancellation", 20.5, 2.5, Date(newTaskDate + 1))
      ].toList();

      test("new Transient task : value should be TRUE", () {
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 14.0, 2.0, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), true);
      });

      test(
          "add Transient task with conflict recurring task : value should be FALSE",
          () {
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), false);
      });

      test("adding new Transient task : value should be FALSE", () {
        // start = 1:00, end = 3:30
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), false);
      });

      test("adding new Anti task no match Recur task: value should be FALSE",
          () {
        // start = 1:00, end = 3:30
        final newTask = new AntiTask(
            "Cancel Dinner", "Cancellation", 10.0, 1.0, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), false);
      });

      test(
          "adding new Anti task, no matching recurring task : value should be TRUE",
          () {
        // start = 1:00, end = 3:30
        final newTask =
            new AntiTask("Cancel", "Cancellation", 8.0, 3.0, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), true);
      });
    });

    group("getDateOverlaps() testing", () {
      test(
          "getDateOverlaps() adding new Transient task : value should be list of all existing tasks",
          () {
        final newTaskDate = 20200429;
        // start = 1:00, end = 3:30
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
        var sched = [
          new RecurringTask("Dinner", "Meal", 10.0, 1.0, Date(newTaskDate),
              Date(20200507), 7),
          new RecurringTask("Dinner", "Meal", 17.0, 1.0, Date(newTaskDate - 7),
              Date(20200507), 7),
          new RecurringTask("Homework", "Study", 15.0, 1.0, Date(20200428),
              Date(20200507), 1),
          new TransientTask(
              "Going to Mall", "Shopping", 10.0, 1.5, Date(newTaskDate)),
          new TransientTask(
              "Intern Interview", "Appointment", 17.0, 2.5, Date(newTaskDate)),
        ].toList();

        var res = Validator().getDateOverlaps(sched, newTask);
        expect(res.length, 5);
      });

      test("getDateOverlaps() adding new Transient task : value should be 3",
          () {
        final newTaskDate = 20200429;
        // start = 1:00, end = 3:30
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));

        var sched = [
          new RecurringTask("Dinner", "Meal", 17.0, 1.0, Date(newTaskDate - 7),
              Date(20200507), 7),
          new RecurringTask("Homework", "Study", 15.0, 1.0,
              Date(newTaskDate - 1), Date(20200507), 1),
          new AntiTask(
              "Cancel Dinner", "Cancellation", 17.0, 1.0, Date(newTaskDate)),
          new AntiTask(
              "Cancel Homework", "Cancellation", 15.0, 1.0, Date(newTaskDate)),
          new RecurringTask("Dinner", "Meal", 10.0, 1.0, Date(newTaskDate),
              Date(20200507), 7),
          new TransientTask(
              "Going to Mall", "Shopping", 10.0, 1.5, Date(newTaskDate)),
          new TransientTask(
              "Intern Interview", "Appointment", 17.0, 2.5, Date(newTaskDate)),
        ].toList();

        var res = Validator().getDateOverlaps(sched, newTask);
        expect(res.length, 3);
      });
    });
  });
}
