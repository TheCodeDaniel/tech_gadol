import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeService {
  static const String _boxName = 'theme_prefs';
  static const String _themeModeKey = 'theme_mode';

  ThemeService._internal();
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;

  Box? _box;

  Future<Box> _getBox() async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  Future<ThemeMode> getThemeMode() async {
    try {
      final box = await _getBox();
      final value = box.get(_themeModeKey) as String?;
      switch (value) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    } catch (e, stack) {
      debugPrintStack(
        stackTrace: stack,
        label: 'ThemeService.getThemeMode',
      );
      return ThemeMode.system;
    }
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final box = await _getBox();
      final value = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => null,
      };
      if (value != null) {
        await box.put(_themeModeKey, value);
      } else {
        await box.delete(_themeModeKey);
      }
    } catch (e, stack) {
      debugPrintStack(
        stackTrace: stack,
        label: 'ThemeService.saveThemeMode',
      );
    }
  }
}
