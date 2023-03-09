import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsue_schedule/models/settings.dart';
import 'package:rsue_schedule/services/storage.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
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
    _loadSettings();
  }

  FutureOr<void> _onChangeSettings(
    ChangeSettings event,
    Emitter<SettingsState> emit,
  ) {
    emit(SettingsInitial());
    emit(SettingsLoaded(settings));
    Storage().saveSettings(settings);
  }
}
