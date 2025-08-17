import 'dart:ui';
import 'package:get/get.dart';
import 'package:questly/features/side_menu/screens/side_menu.dart';
import 'package:questly/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'features/player/screens/flip_clock.dart';
import 'features/side_menu/controller/side_menu_binding.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      title: 'Questly',
      themeMode: ThemeMode.dark,
      theme: KAppTheme.lightTheme,
      darkTheme: KAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      home: const CustomSideMenu(),
      initialBinding: SideMenuBinding(),
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
