import 'package:dio/dio.dart';
import 'package:schedule_api/src/api_repository.dart';

import 'cache_interceptor.dart';

class ScheduleApi {
  late ApiRepository _apiRepository;
  late Dio _dio;

  ScheduleApi() {
    _dio = Dio();
    _dio.interceptors.add(CacheInterceptor());
    _dio.options = BaseOptions(validateStatus: (code) => code! < 500);
    _apiRepository = ApiRepository(_dio);
  }

  /// Возвращает расписание [teacher] для указанного [dateTime]
  ///
  /// [teacher] должна быть полной, выбрана из поиска, или возвращена методом [getTeacherByQuery]
  Future<List<dynamic>> getTeacherSchedule(
    String teacher,
    String dateTime,
  ) async {
    return await _apiRepository.getTeacherSchedule(teacher, dateTime);
  }

  /// Возвращает расписание [group] для указанного [dateTime]
  Future<List<dynamic>> getGroupSchedule(
    String group,
    String dateTime,
  ) async {
    return await _apiRepository.getGroupSchedule(group, dateTime);
  }

  /// Возвращает расписание [auditorium] для указанного [dateTime]
  Future<List<Map<String, dynamic>>> getAuditoriumSchedule(
    String auditorium,
    String dateTime,
  ) async {
    return await _apiRepository.getAuditoriumSchedule(auditorium, dateTime);
  }

  /// Возвращает список преподавателей для указанной [group]
  Future<List<String>> getTeachersForGroup(String group) async {
    return await _apiRepository.getTeachersForGroup(group);
  }

  /// Возвращает список преподавателей для запроса, введенного пользователем
  Future<List<String>> getTeachersByQuery(String query) async {
    return await _apiRepository.getTeachersByQuery(query);
  }
}
