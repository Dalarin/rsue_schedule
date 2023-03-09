import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:schedule_api/src/database.dart';

class CacheInterceptor extends Interceptor {
  late final DBHelper _dbHelper;

  // ignore: prefer_typing_uninitialized_variables
  final _cachingPeriod;

  CacheInterceptor([this._cachingPeriod = 7]) {
    _dbHelper = DBHelper(_cachingPeriod);
  }

  _handleRequestGroup(
    RequestOptions options,
    RequestInterceptorHandler handler,
    Map<String, dynamic> parameters,
  ) async {
    var date = parameters['date'].toString().split('.').reversed;
    final formattedDate = DateTime.parse(date.join('-'));
    final group = parameters['group'];
    final data = await _dbHelper.getGroupScheduleFromDB(group, formattedDate);
    if (data.isNotEmpty) {
      var response = Response(
        requestOptions: options,
        statusCode: 200,
        data: data,
      );
      return handler.resolve(response);
    } else {
      handler.next(options);
    }
  }

  _handleRequestAuditorium(
    RequestOptions options,
    RequestInterceptorHandler handler,
    Map<String, dynamic> parameters,
  ) async {
    var date = parameters['date'].toString().split('.').reversed;
    final dates = DateTime.parse(date.join('-'));
    final aud = options.uri.queryParameters['auditorium'];
    final data = await _dbHelper.getAuditoriumScheduleFromDB(aud!, dates);
    if (data.isNotEmpty) {
      var response = Response(
        requestOptions: options,
        statusCode: 200,
        data: data,
      );
      return handler.resolve(response);
    } else {
      handler.next(options);
    }
  }

  _handleRequestTeacher(
    RequestOptions options,
    RequestInterceptorHandler handler,
    Map<String, dynamic> parameters,
  ) {}

  _handleResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final decodedJson = jsonDecode(response.data);
    for (var json in decodedJson) {
      await _dbHelper.insertRecord(json);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final segments = response.realUri.pathSegments;
    final methods = [
      'schedule_group',
      // 'schedule_teacher',
      // 'schedule_auditorium'
    ];
    if (segments.every((element) => methods.contains(element))) {
      _handleResponse(response, handler);
    }
    return handler.next(response);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final segments = options.uri.pathSegments;
    final parameters = options.uri.queryParameters;
    if (segments.contains('schedule_group')) {
      _handleRequestGroup(options, handler, parameters);
    } else {
      handler.next(options);
    }
    // } else if (segments.contains('schedule_teacher')) {
    //   _handleRequestAuditorium(options, handler, parameters);
    // } else if (segments.contains('schedule_auditorium')) {
    //   _handleRequestTeacher(options, handler, parameters);
    // } else {
  }
}
