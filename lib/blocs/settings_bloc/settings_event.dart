part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ChangeSettings extends SettingsEvent {
  final Settings settings;

  const ChangeSettings(this.settings);
}
