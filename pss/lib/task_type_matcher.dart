class TaskTypeMatcher {
  static const _recurringTypes = ["Class", "Study", "Exercise", "Work", "Meal"];
  static const _transientTypes = ["Visit", "Shopping", "Appointment"];
  static const _antiTaskTypes = ["Cancellation"];

  String getType(String t) {
    if (_recurringTypes.contains(t)) {
      return "Recurring";
    } else if (_transientTypes.contains(t)) {
      return "Transient";
    } else if (_antiTaskTypes.contains(t)) {
      return "AntiTask";
    } else
      throw Exception("No matching type!"); // No type matched
  }
}
