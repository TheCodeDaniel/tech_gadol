import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol/core/theme/dark_theme.dart';
import 'package:tech_gadol/core/theme/light_theme.dart';
import 'package:tech_gadol/features/posts/presentation/bloc/posts_bloc.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => PostsBloc())],
      child: MaterialApp(
        title: 'Tech Gadol',
        locale: Locale('en-US'),
        debugShowCheckedModeBanner: false,
        theme: LightTheme.themeData,
        darkTheme: DarkTheme.themeData,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
