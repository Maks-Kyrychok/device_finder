import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_themes.dart';
import 'core/theme/theme_cubit.dart';
import 'features/devices/presentation/devices_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BLE Devices',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            home: const DevicesListScreen(),
          );
        },
      ),
    );
  }
}
