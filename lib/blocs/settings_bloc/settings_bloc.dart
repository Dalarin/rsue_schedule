import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_bloc.dart';
import 'package:rsue_schedule/blocs/schedule_bloc/schedule_repository.dart';
import 'package:rsue_schedule/models/settings.dart';
import 'package:rsue_schedule/services/storage.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ScheduleRepository _repository = ScheduleRepository();
  late final Settings settings;

  void _loadSettings() async {
    emit(SettingsLoading());
    final loadedInfo = await Storage().readSettings();
    if (loadedInfo != null) {
      settings = loadedInfo;
    } else {
      settings = Settings.defaultSettings;
    }
    emit(SettingsLoaded(settings));
  }

  SettingsBloc() : super(SettingsInitial()) {
    on<ChangeSettings>(_onChangeSettings);
    on<ClearCache>(_onClearCache);
    _loadSettings();
  }

  FutureOr<void> _onChangeSettings(
    ChangeSettings event,
    Emitter<SettingsState> emit,
  ) {
    try {
      if (event.group.trim().isNotEmpty) {
        emit(SettingsInitial());
        settings.group = event.group;
        settings.themeMode = event.themeMode;
        emit(SettingsLoaded(settings));
        Storage().saveSettings(settings);
      } else {
        emit(const SettingsError('Заполните все поля и попробуйте снова'));
      }
    } catch (_) {
      emit(const SettingsError('Произошла непредвиденная ошибка'));
    }
  }

  FutureOr<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsInitial());
    await _repository.clearCachedData();
    emit(const CachedDataDeleted('Кэшированые данные были удалены'));
    emit(SettingsLoaded(settings));
  }
}
