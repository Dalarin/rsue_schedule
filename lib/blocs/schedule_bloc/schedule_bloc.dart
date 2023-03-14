import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_repository.dart';
import 'package:rsue_schedule/models/schedule.dart';
import 'package:schedule_api/schedule_api.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository _repository = ScheduleRepository();

  ScheduleBloc() : super(ScheduleInitial()) {
    on<GetScheduleForTeacher>(_onGetScheduleForTeacher);
    on<GetScheduleForGroup>(_onGetScheduleForGroup);
    on<GetScheduleForAuditorium>(_onGetScheduleForAuditorium);
    on<GetTeachersForGroup>(_onGetTeacherForGroup);
    on<GetTeachersFromQuery>(_onGetTeacherFromQuery);
    on<GetAuditoriumFromQuery>(_onGetAuditoriumFromQuery);
  }

  Future<void> _onGetScheduleForTeacher(
    GetScheduleForTeacher event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      if (event.dateTime.weekday != DateTime.sunday) {
        final schedule = await _repository.getTeacherSchedule(
          event.teacher,
          DateFormat('dd.MM.yyyy').format(event.dateTime),
        );
        if (schedule != null) {
          emit(ScheduleLoaded(
            schedule: schedule,
            selectedDate: event.dateTime,
          ));
        } else {
          emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
        }
      } else {
        emit(ScheduleLoaded(schedule: const [], selectedDate: event.dateTime));
      }
    } on ScheduleException catch (e) {
      emit(ScheduleError(message: e.toString()));
    } on Exception catch (_) {
      emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
    }
  }

  Future<void> _onGetScheduleForGroup(
    GetScheduleForGroup event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      if (event.dateTime.weekday == DateTime.sunday) {
        emit(ScheduleLoaded(schedule: const [], selectedDate: event.dateTime));
      } else {
        final schedule = await _repository.getGroupSchedule(
          event.group,
          DateFormat('dd.MM.yyyy').format(event.dateTime),
        );
        if (schedule != null) {
          emit(ScheduleLoaded(
            schedule: schedule,
            selectedDate: event.dateTime,
          ));
        } else {
          emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
        }
      }
    } on ScheduleException catch (e) {
      emit(ScheduleError(message: e.toString()));
    } on Exception catch (_) {
      emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
    }
  }

  Future<void> _onGetScheduleForAuditorium(
    GetScheduleForAuditorium event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      final schedule = await _repository.getAuditoriumSchedule(
        event.auditorium,
        DateFormat('dd.MM.yyyy').format(event.dateTime),
      );
      if (schedule != null) {
        emit(ScheduleLoaded(schedule: schedule, selectedDate: event.dateTime));
      } else {
        emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
      }
    } on ScheduleException catch (e) {
      emit(ScheduleError(message: e.toString()));
    } on Exception catch (_) {
      emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
    }
  }

  FutureOr<void> _onGetTeacherForGroup(
    GetTeachersForGroup event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      var teachers = await _repository.getTeachersForGroup(event.group);
      if (teachers != null) {
        teachers.sort();
        final regex = RegExp(r'[А-Яа-я]');
        teachers.removeWhere((element) => !regex.hasMatch(element));
        emit(ScheduleTeacherLoaded(teachers: teachers));
      } else {
        emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
      }
    } on ScheduleException catch (e) {
      emit(ScheduleError(message: e.toString()));
    } on Exception catch (_) {
      emit(const ScheduleError(message: 'Ошибка загрузки расписания'));
    }
  }

  FutureOr<void> _onGetTeacherFromQuery(
    GetTeachersFromQuery event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      var teachers = await _repository.getTeacherFromQuery(event.query);
      if (teachers != null) {
        teachers.sort();
        final regex = RegExp(r'[А-Яа-я]');
        teachers.removeWhere((element) => !regex.hasMatch(element));
        emit(ScheduleTeacherLoaded(teachers: teachers));
      } else {
        emit(const ScheduleError(message: 'Ошибка загрузки преподавателей'));
      }
    } on ScheduleException catch (e) {
      emit(ScheduleError(message: e.toString()));
    } on Exception catch (_) {
      emit(const ScheduleError(message: 'Ошибка загрузки преподавателей'));
    }
  }

  FutureOr<void> _onGetAuditoriumFromQuery(
    GetAuditoriumFromQuery event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      emit(ScheduleLoading());
      var auditorium = await _repository.getAuditoriumFromQuery(event.query);
      if (auditorium != null) {
        auditorium.sort();
        emit(ScheduleAuditoriumLoaded(auditorium: auditorium));
      } else {
        emit(const ScheduleError(message: 'Ошибка загрузки преподавателей'));
      }
    } on ScheduleException catch (e) {
      emit(ScheduleError(message: e.toString()));
    } on Exception catch (_) {
      emit(const ScheduleError(message: 'Ошибка загрузки преподавателей'));
    }
  }
}
