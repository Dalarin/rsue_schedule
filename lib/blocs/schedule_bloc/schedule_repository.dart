import 'package:rsue_schedule/models/schedule.dart';
import 'package:schedule_api/schedule_api.dart';

class ScheduleRepository {
  final ScheduleApi _api = ScheduleApi();

  Future<List<Schedule>?> getGroupSchedule(
    String group,
    String dateTime,
  ) async {
    final map = await _api.getGroupSchedule(group, dateTime);
    final list = map.map((schedule) => Schedule.fromMap(schedule)).toList();
    return list;
  }

  Future<List<Schedule>?> getTeacherSchedule(
    String teacher,
    String date,
  ) async {
    final map = await _api.getTeacherSchedule(teacher, date);
    return map.map((elem) => Schedule.fromMap(elem)).toList();
  }

  Future<List<Schedule>?> getAuditoriumSchedule(
    String auditorium,
    String dateTime,
  ) async {
    final map = await _api.getAuditoriumSchedule(auditorium, dateTime);
    final list = map.map((schedule) => Schedule.fromMap(schedule)).toList();
    return list;
  }

  Future<List<String>?> getTeachersForGroup(String group) async {
    final map = await _api.getTeachersForGroup(group);
    return map.map((element) => element.toString()).toList();
  }

  Future<List<String>?> getTeacherFromQuery(String query) async {
    final map = await _api.getTeachersByQuery(query);
    return map.map((element) => element.toString()).toList();
  }

  Future<List<String>?> getAuditoriumFromQuery(String query) async {
    final map = await _api.getAuditoriumByQuery(query);
    return map.map((element) => element.toString()).toList();
  }
}
