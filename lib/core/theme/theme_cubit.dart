import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/services/local_storage_services/theme_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final ThemeService _themeService;

  ThemeCubit({
    required ThemeService themeService,
    ThemeMode initialMode = ThemeMode.system,
  })  : _themeService = themeService,
        super(initialMode);

  void setThemeMode(ThemeMode mode) {
    _themeService.saveThemeMode(mode);
    emit(mode);
  }

  void toggleTheme(BuildContext context) {
    final brightness =
        MediaQuery.platformBrightnessOf(context);
    final isCurrentlyDark = state == ThemeMode.dark ||
        (state == ThemeMode.system &&
            brightness == Brightness.dark);

    setThemeMode(
      isCurrentlyDark ? ThemeMode.light : ThemeMode.dark,
    );
  }

  bool isDark(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) ==
          Brightness.dark;
    }
    return state == ThemeMode.dark;
  }
}
