import 'dart:ui';

import 'package:al_maafer/side_menu.dart';
import 'package:al_maafer/utils/theme/theme.dart';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'trello_bord/presentation/pages/kaban_set_state_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      title: 'week',
      themeMode: ThemeMode.dark,
      theme: KAppTheme.lightTheme,
      darkTheme: KAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      // home:  const WeeklyCalendarScreen(),
      // home: Kanban(),
      home: EasySideMenu(),

      scrollBehavior: const ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.trackpad,
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
    );
  }
}
