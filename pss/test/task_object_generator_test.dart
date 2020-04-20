import 'package:flutter_test/flutter_test.dart';
import '../lib/recurring_task.dart';
import '../lib/task_object_generator.dart';

const Map<String, Object> data = {
  "Name": "Dinner",
  "Type": "Meal",
  "StartDate": 20200414,
  "StartTime": 17.0,
  "Duration": 1.0,
  "EndDate": 20200507,
  "Frequency": 1
};

main() {
  group("TaskObjectGenerator class => ", () {
    test("generateTask() should return 'Instance of ReccuringTask'", () {
      final taskObjectGenerator = TaskObjectGenerator();
      expect(taskObjectGenerator.generateTask(data).runtimeType, RecurringTask);
    });

    test("generateTask() should return 'Instance of ReccuringTask'", () {
      final taskObjectGenerator = TaskObjectGenerator();
      expect(taskObjectGenerator.generateTask(data).runtimeType, RecurringTask);
    });
    test("generateTask() should return 'Instance of ReccuringTask'", () {
      final taskObjectGenerator = TaskObjectGenerator();
      expect(taskObjectGenerator.generateTask(data).runtimeType, RecurringTask);
    });
  });
}
