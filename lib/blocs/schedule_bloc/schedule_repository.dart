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

  Future<List<Schedule>?> getAuditoriumSchedule(
    String auditorium,
    String dateTime,
  ) async {
    final map = await _api.getAuditoriumSchedule(auditorium, dateTime);
    final list = map.map((schedule) => Schedule.fromMap(schedule)).toList();
    return list;
  }

  Future<List<String>?> getTeachersForGroup(String group) async {
    return await _api.getTeachersForGroup(group);
  }
}
