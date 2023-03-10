class ScheduleException implements Exception {
  final String message;

  ScheduleException(this.message);

  @override
  String toString() {
    return message;
  }
}


