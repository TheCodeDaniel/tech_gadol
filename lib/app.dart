import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/routing/app_router.dart';
import 'package:tech_gadol/core/services/local_storage_services/theme_service.dart';
import 'package:tech_gadol/core/theme/dark_theme.dart';
import 'package:tech_gadol/core/theme/light_theme.dart';
import 'package:tech_gadol/core/theme/theme_cubit.dart';
import 'package:tech_gadol/features/products/presentation/bloc/products_bloc.dart';

class App extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const App({
    super.key,
    this.initialThemeMode = ThemeMode.system,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductsBloc()),
        BlocProvider(
          create: (_) => ThemeCubit(
            themeService: ThemeService(),
            initialMode: initialThemeMode,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Tech Gadol',
            locale: const Locale('en', 'US'),
            debugShowCheckedModeBanner: false,
            theme: LightTheme.themeData,
            darkTheme: DarkTheme.themeData,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
