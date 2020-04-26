import 'package:flutter_test/flutter_test.dart';
import '../lib/recurring_task.dart';
import '../lib/create/task_generator.dart';

const Map<String, Object> data = {
  "Name": "Dinner",
  "Type": "Meal",
  "StartDate": 20200414,
  "StartTime": 17,
  "Duration": 1,
  "EndDate": 20200507,
  "Frequency": 1
};

main() {
  group("TaskGenerator class => ", () {
    test("generateTask() should return 'Instance of ReccuringTask'", () {
      final taskGenerator = TaskGenerator();
      expect(taskGenerator.generateTask(data).runtimeType, RecurringTask);
    });

    test("generateTask() should return 'Instance of ReccuringTask'", () {
      final taskGenerator = TaskGenerator();
      expect(taskGenerator.generateTask(data).runtimeType, RecurringTask);
    });
    test("generateTask() should return 'Instance of ReccuringTask'", () {
      final taskGenerator = TaskGenerator();
      expect(taskGenerator.generateTask(data).runtimeType, RecurringTask);
    });
  });
}
