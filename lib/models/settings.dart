import 'package:flutter/material.dart';

class Settings {
  ThemeMode themeMode;
  String group;

  static Settings defaultSettings = Settings(ThemeMode.light, 'ПРИ-331');

  Settings(this.themeMode, this.group);

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
      'group': group,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      ThemeMode.values[map['themeMode']],
      map['group'],
    );
  }
}
