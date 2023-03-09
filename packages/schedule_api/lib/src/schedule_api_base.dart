import 'package:dio/dio.dart';
import 'package:schedule_api/src/api_repository.dart';

import 'cache_interceptor.dart';

class ScheduleApi {
  late ApiRepository _apiRepository;
  late Dio _dio;

  ScheduleApi() {
    _dio = Dio();
    _dio.interceptors.add(CacheInterceptor());
    _apiRepository = ApiRepository(_dio);
  }

  Future<List<dynamic>> getTeacherSchedule(
    String teacher,
    String dateTime,
  ) async {
    return await _apiRepository.getTeacherSchedule(teacher, dateTime);
  }

  Future<List<dynamic>> getGroupSchedule(
    String group,
    String dateTime,
  ) async {
    return await _apiRepository.getGroupSchedule(group, dateTime);
  }

  Future<List<Map<String, dynamic>>> getAuditoriumSchedule(
    String auditorium,
    String dateTime,
  ) async {
    return await _apiRepository.getAuditoriumSchedule(auditorium, dateTime);
  }

  Future<List<String>> getTeachersForGroup(String group) async {
    return await _apiRepository.getTeachersForGroup(group);
  }
}
