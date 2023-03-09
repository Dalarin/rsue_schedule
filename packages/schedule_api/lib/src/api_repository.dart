import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

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
        if (response.data.runtimeType.toString() != 'QueryResultSet') {
          return jsonDecode(response.data);
        }
        return response.data;
      } else {
        throw Exception('Ошибка получения данных с сервера');
      }
    } on DioError catch (error) {
      log(error.message, error: error.message);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAuditoriumSchedule(
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
      }
      throw Exception('Ошибка получения данных с сервера');
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
      if (response.statusCode == 200) return json.decode(response.data);
      throw Exception('Ошибка получения данных с сервера');
    } on SocketException {
      throw Exception('Отсутствует интернет соединение');
    }
  }

  Future<List<String>> getTeachersForGroup(String group) async {
    try {
      Response response = await _dio.get(
        '$_apiLink/teachers',
        queryParameters: {'group': group},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.data) as List;
        return decoded.map((element) => element.toString()).toList();
      }
      throw Exception('Ошибка получения данных с сервера');
    } on DioError catch (error) {
      log(error.message, error: error.message);
      rethrow;
    }
  }
}
