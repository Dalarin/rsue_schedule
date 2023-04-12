import 'package:rsue_schedule/models/homework.dart';
import 'package:rsue_schedule/models/schedule.dart';
import 'package:rsue_schedule/services/database.dart';

class HomeworkRepository {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<List<Homework>> getHomeworkForSchedule(
    Schedule schedule,
    DateTime dateTime,
  ) async {
    return await _helper.getRecords(schedule.lesson, schedule.group, dateTime);
  }

  Future<Homework?> insertHomeworkForSchedule(Homework homework) async {
    return await _helper.insertRecord(homework);
  }

  Future<bool> deleteHomework(int id) async {
    return await _helper.deleteRecord(id);
  }

  Future<Homework?> updateHomework(Homework homework) async {
    return await _helper.updateRecord(homework);
  }
}
