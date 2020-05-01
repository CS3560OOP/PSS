import 'package:flutter_test/flutter_test.dart';
import 'package:pss/recurring_task.dart';
import 'package:pss/date.dart';

main() {
  group("RECURRING TASK CLASS", () {
    final taskDate = 20200429;
    final weeklyTask = new RecurringTask(
        "CS3650", "Class", 19.0, 1.25, Date(taskDate), Date(20200507), 7);
    final dailyTask = new RecurringTask(
        "Dinner", "Meal", 17.0, 1.0, Date(taskDate), Date(20200507), 1);
    final monthlyTask = new RecurringTask(
        "Pay Rent", "Meal", 13.0, 0.5, Date(taskDate), Date(20200507), 30);

    test("getNextOcurrence() daily value shout be 20200430", () {
      var res = dailyTask.getNextOccurance(Date(taskDate));
      expect(res.getIntDate(), 20200430);
    });

    test("getNextOcurrence() weekly value shout be", () {
      var res = weeklyTask.getNextOccurance(Date(taskDate));
      expect(res.getIntDate(), 20200506);
    });

    test("getNextOcurrence() monthly value shout be", () {
      var res = monthlyTask.getNextOccurance(Date(taskDate));
      expect(res.getIntDate(), 20200529);
    });
  });
}
