import 'dart:ui';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/weekly_calendar.dart';
import 'package:al_maafer/main.dart';
import 'package:al_maafer/side_menu.dart';
import 'package:al_maafer/utils/theme/theme.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:al_maafer/utils/constants/text_strings.dart';
// import 'package:al_maafer/utils/theme/theme.dart';

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
