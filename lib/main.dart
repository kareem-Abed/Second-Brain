import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:questly/app.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

import 'features/player/screens/flip_clock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    await windowManager.ensureInitialized();

    const minSize = Size(696, 608);
    WindowOptions windowOptions = const WindowOptions(
      size: minSize,
      minimumSize: minSize,
      backgroundColor: Colors.transparent,
      titleBarStyle: TitleBarStyle.hidden,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setMinimumSize(minSize);
      await windowManager.show();
      await windowManager.focus();
    });
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  MediaKit.ensureInitialized();

  await GetStorage.init();

  runApp(const App());
}
