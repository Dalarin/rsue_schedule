import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:schedule_api/src/exceptions.dart';

class ApiRepository {
  final Dio _dio;
  late final String _apiLink;

  ApiRepository(this._dio) {
    _apiLink = 'https://rsuecomrades.pythonanywhere.com/api';
  }

  Future<List<dynamic>> getGroupSchedule(
    String group,
    String dateTime,
  ) async {
    try {
      Response response = await _dio.get(
        '$_apiLink/schedule_group',
        queryParameters: {
          'date': dateTime,
          'group': group,
        },
      );
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw ScheduleException(response.data);
      }
      throw ScheduleException('Ошибка получения данных с сервера');
    } on DioError catch (error) {
      log(error.message, error: error.message);
      rethrow;
    }
  }

  Future<List<dynamic>> getAuditoriumSchedule(
    String auditorium,
    String dateTime,
  ) async {
    try {
      Response response = await _dio.get(
        '$_apiLink/schedule_auditorium',
        queryParameters: {
          'date': dateTime,
          'auditorium': auditorium,
        },
      );
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw ScheduleException(response.data);
      }
      throw ScheduleException('Ошибка получения данных с сервера');
    } on DioError catch (error) {
      log(error.message, error: error.message);
      rethrow;
    }
  }

  Future<List<dynamic>> getTeacherSchedule(
    String teacher,
    String dateTime,
  ) async {
    try {
      Response response = await _dio.get(
        '$_apiLink/schedule_teacher',
        queryParameters: {'date': dateTime, 'teacher': teacher},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw ScheduleException(response.data);
      }
      throw ScheduleException('Ошибка получения данных с сервера');
    } on SocketException {
      throw ScheduleException('Отсутствует интернет соединение');
    }
  }

  Future<List<dynamic>> getTeachersByQuery(String query) async {
    try {
      Response response = await _dio.get(
        '$_apiLink/find_teachers',
        queryParameters: {'teacher': query},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw ScheduleException(response.data);
      }
      throw ScheduleException('Ошибка получения данных с сервера');
    } on DioError catch (error) {
      log(error.message, error: error.message);
      rethrow;
    }
  }

  Future<List<dynamic>> getTeachersForGroup(String group) async {
    try {
      Response response = await _dio.get(
        '$_apiLink/teachers',
        queryParameters: {'group': group},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw ScheduleException(response.data);
      }
      throw ScheduleException('Ошибка получения данных с сервера');
    } on DioError catch (error) {
      log(error.message, error: error.message);
      rethrow;
    }
  }

  Future<List<dynamic>> getAuditoriumByQuery(String query) async {
    try {
      Response response = await _dio.get(
        '$_apiLink/find_auditorium',
        queryParameters: {'auditorium': query},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 400) {
        throw ScheduleException(response.data);
      }
      throw ScheduleException('Ошибка получения данных с сервера');
    } on DioError catch (error) {
      log(error.message, error: error.message);
      rethrow;
    }
  }
}
