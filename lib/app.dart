import 'dart:ui';

import 'package:second_brain/side_menu.dart';
import 'package:second_brain/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';



class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      title: 'Second Brain',
      themeMode: ThemeMode.dark,
      theme: KAppTheme.lightTheme,
      darkTheme: KAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      home: CustomSideMenu(),


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
