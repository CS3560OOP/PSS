import 'package:flutter_test/flutter_test.dart';
import 'package:pss/transient_task.dart';
import '../lib/recurring_task.dart';
import '../lib/create/task_generator.dart';
import 'package:pss/anti_task.dart';

main() {
  test("generateTask() should return 'Instance of ReccuringTask'", () {
    const Map<String, Object> data = {
      "Name": "Dinner",
      "Type": "Meal",
      "StartDate": 20200414,
      "StartTime": 17,
      "Duration": 1,
      "EndDate": 20200507,
      "Frequency": 1
    };
    final taskGenerator = TaskGenerator();
    expect(taskGenerator.generateTask(data).runtimeType.toString(),
        "RecurringTask");
  });

  test("generateTask() should return 'Instance of Anti'", () {
    const Map<String, Object> data = {
      "Name": "Cancel Dinner",
      "Type": "Cancellation",
      "Date": 20200414,
      "StartTime": 17,
      "Duration": 1,
    };
    final taskGenerator = TaskGenerator();
    expect(taskGenerator.generateTask(data).runtimeType.toString(), "AntiTask");
  });

  test("generateTask() should return 'Instance of Transient'", () {
    const Map<String, Object> data = {
      "Name": "Visiting",
      "Type": "Visit",
      "Date": 20200414,
      "StartTime": 17,
      "Duration": 1,
    };
    final taskGenerator = TaskGenerator();

    expect(taskGenerator.generateTask(data).runtimeType.toString(),
        "TransientTask");
  });
}
