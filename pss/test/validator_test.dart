import 'package:flutter_test/flutter_test.dart';
import 'package:pss/anti_task.dart';
import 'package:pss/recurring_task.dart';
import 'package:pss/transient_task.dart';
import 'package:pss/validator.dart';
import 'package:pss/date.dart';

main() {
  final validator = Validator();
  group("\nVALIDATOR CLASS : ", () {
    group("isValidDate()", () {
      test(" value should be TRUE", () {
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
      test("valid task : value should be TRUE", () {
        final task = {
          "Name": "CS3560-Tu",
          "Type": "Class",
          "StartDate": 20200414,
          "StartTime": 19,
          "Duration": 1.25,
          "EndDate": 20200505,
          "Frequency": 7
        };

        try {
          validator.validateTask(sched, task);
          expect(() => validator.validateTask(sched, task), returnsNormally);
        } catch (e) {}
      });
      test("invalid name : value should be FALSE", () {
        final task = {
          "Name": "intern interview",
          "Type": "Appointment",
          "StartDate": 20200414,
          "StartTime": 19,
          "Duration": 1.25,
          "EndDate": 20200505,
          "Frequency": 7
        };

        try {
          validator.validateTask(sched, task);
        } catch (e) {
          expect(e.toString(), "Exception: Task already exists");
        }
      });
    });

    group("\nisValidTaskName() ", () {
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

      test("value should be TRUE", () {
        expect(Validator().isValidTaskName(sched, "going to school backyard"),
            true);
      });
      test("value should be FALSE", () {
        expect(Validator().isValidTaskName(sched, "Intern Interview"), false);
      });
    });

    group("\nisValidTaskFrequency() ", () {
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

    group("\nisValidTaskTime() ", () {
      test("value should be TRUE", () {
        expect(Validator().isValidTaskTime(23.25), true);
      });
      test("value should be FALSE", () {
        expect(Validator().isValidTaskTime(12.60), false);
      });
    });

    group("\nisValidTaskDuration() ", () {
      test("value should be TRUE", () {
        expect(Validator().isValidTaskDuration(3.25), true);
      });
      test("value should be FALSE", () {
        expect(Validator().isValidTaskDuration(2.60), false);
      });
    });

    group("\nhasNoTimeOverlap() ", () {
      final newTaskDate = 20200429;

      final sched = [
        new RecurringTask("Breakfast", "Meal", 10.0, 1.0, Date(newTaskDate),
            Date(20200507), 7),
        new RecurringTask("Dinner", "Meal", 12.0, 2.0, Date(newTaskDate - 5),
            Date(20200510), 1),
        new RecurringTask(
            "Dinner", "Meal", 8.0, 1.0, Date(newTaskDate), Date(20200507), 7),
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
            "Cancel Dinner", "Cancellation", 8.0, 1.0, Date(newTaskDate))
      ].toList();

      test("new Transient task : value should be TRUE", () {
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 14.0, 1.0, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), true);
      });

      test("new Anti task, no matching recurring task : value should be TRUE",
          () {
        // start = 1:00, end = 3:30
        final newTask =
            new AntiTask("Cancel", "Cancellation", 8.0, 3.0, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), true);
      });

      test(
          "new Transient task with conflict recurring task : value should be FALSE",
          () {
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), false);
      });

      test("new Transient task : value should be FALSE", () {
        // start = 1:00, end = 3:30
        final newTask = new TransientTask(
            "Intern Interview", "Appointment", 13.0, 2.5, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), false);
      });

      test("new Anti task no match Recur task: value should be FALSE", () {
        final newTask = new AntiTask(
            "Cancel Dinner", "Cancellation", 10.0, 1.0, Date(newTaskDate));
        expect(Validator().hasNoTimeOverlap(sched, newTask), false);
      });

      test("new daily Recurring task : value should be FALSE", () {
        final newTask = new RecurringTask(
            "Dinner", "Meal", 10.0, 1.0, Date(newTaskDate), Date(20200531), 1);
        expect(Validator().hasNoTimeOverlap(sched, newTask), false);
      });

      test("new daily Recurring task : value should be TRUE", () {
        final newTask = new RecurringTask(
            "Dinner", "Meal", 23.0, 0.75, Date(newTaskDate), Date(20200531), 1);
        expect(Validator().hasNoTimeOverlap(sched, newTask), true);
      });

      test("new daily Recurring task : value should be TRUE", () {
        final newTask = new RecurringTask(
            "Dinner", "Meal", 1.75, 0.75, Date(newTaskDate), Date(20200531), 1);
        expect(Validator().hasNoTimeOverlap(sched, newTask), true);
      });
    });

    group("\ngetDateOverlaps() ", () {
      test(
          "adding new Transient task : value should be list of all existing tasks",
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

      test("adding new Transient task : value should be 3", () {
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

      test(
          "new Daily Recurring task : no time conflict, all dates conflict, value should be 3",
          () {
        final newTaskDate = 20200429;
        // start = 1:00, end = 2:00
        final newTask = new RecurringTask("Breakfast", "Meal", 1.0, 1.0,
            Date(newTaskDate), Date(20200510), 1);

        var sched = [
          new TransientTask(
              "Going to Mall", "Shopping", 0.5, 0.5, Date(newTaskDate)),
          new TransientTask(
              "Going to School", "Visit", 2.0, 1.0, Date(newTaskDate + 1)),
          new TransientTask("Going Home", "Visit", 3.0, 1.0, Date(20200508)),
        ].toList();

        var res = Validator().getDateOverlaps(sched, newTask);
        expect(res.length, 3);
      });

      test("new Daily Recurring task : conflicts present value should be 2",
          () {
        final newTaskDate = 20200429;
        // start = 1:00, end = 2:00
        final newTask = new RecurringTask("Breakfast", "Meal", 1.0, 1.0,
            Date(newTaskDate), Date(20205010), 1);

        var sched = [
          new TransientTask(
              "Going to Mall", "Shopping", 0.5, 0.5, Date(newTaskDate - 1)),
          new TransientTask(
              "Going to School", "Visit", 2.0, 1.0, Date(newTaskDate - 5)),
          new TransientTask("Going Home", "Visit", 3.0, 1.0, Date(20200508)),
          new TransientTask("Going Home", "Visit", 3.0, 1.0, Date(20200510)),
        ].toList();
        var res = Validator().getDateOverlaps(sched, newTask);
        expect(res.length, 2);
      });

      test("new Weekly Recurring task : conflict dates value should be 3", () {
        final newTaskDate = 20200401;
        // start = 1:00, end = 2:00
        final newTask = new RecurringTask("Breakfast", "Meal", 1.0, 1.0,
            Date(newTaskDate), Date(20205010), 7);

        var sched = [
          new TransientTask(
              "Going to Mall", "Shopping", 0.5, 0.5, Date(newTaskDate)),
          new TransientTask(
              "Going to School", "Visit", 2.0, 1.0, Date(newTaskDate + 7)),
          new TransientTask(
              "Going Home", "Visit", 3.0, 1.0, Date(newTaskDate + 14)),
          new TransientTask("Going Home", "Visit", 3.0, 1.0, Date(20200510)),
        ].toList();
        var res = Validator().getDateOverlaps(sched, newTask);
        expect(res.length, 3);
      });

      test("new Monthly Recurring task : conflict dates value should be 1", () {
        final newTaskDate = 20200401;
        // start = 1:00, end = 2:00
        final newTask = new RecurringTask("Breakfast", "Meal", 1.0, 1.0,
            Date(newTaskDate), Date(20205010), 30);
        var sched = [
          new TransientTask(
              "Going to Mall", "Shopping", 0.5, 0.5, Date(20200501)),
          new TransientTask(
              "Going to School", "Visit", 2.0, 1.0, Date(newTaskDate + 7)),
          new TransientTask(
              "Going Home", "Visit", 3.0, 1.0, Date(newTaskDate + 14)),
          new TransientTask("Going Home", "Visit", 3.0, 1.0, Date(20200510)),
        ].toList();
        var res = Validator().getDateOverlaps(sched, newTask);
        expect(res.length, 1);
      });

      test("new Monthly Recurring task : conflict dates value should be 1", () {
        final newTaskDate = 20201231;
        // start = 1:00, end = 2:00
        final newTask = new RecurringTask("Breakfast", "Meal", 1.0, 1.0,
            Date(newTaskDate), Date(20210510), 30);
        var sched = [
          new TransientTask(
              "Going to Mall", "Shopping", 0.5, 0.5, Date(20210131)),
          new TransientTask(
              "Going to School", "Visit", 2.0, 1.0, Date(newTaskDate + 7)),
          new TransientTask(
              "Going Home", "Visit", 3.0, 1.0, Date(newTaskDate + 14)),
          new TransientTask("Going Home", "Visit", 3.0, 1.0, Date(20200510)),
        ].toList();
        var res = Validator().getDateOverlaps(sched, newTask);
        expect(res.length, 1);
      });
    });
  });
}
