import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;

      const initialSize = Size(900, 500);
      win.minSize = initialSize;
      win.size = initialSize;

      win.alignment = Alignment.center;
      win.title = "Second Brain";
      win.show();
    });
    // await WindowManager.instance.ensureInitialized();
    // windowManager.waitUntilReadyToShow().then((_) async {
    //   await windowManager.setTitleBarStyle(
    //     TitleBarStyle.normal,
    //     windowButtonVisibility: true,
    //   );
    //   await windowManager.setTitle("Second Brain");
    //   await windowManager.setBackgroundColor(KColors.darkModeBackground);
    //   await windowManager.blur();
    //   await windowManager.setMinimumSize(const Size(900, 500));
    //   await windowManager.show();
    // });
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  await GetStorage.init();

  runApp(
    const App(),
  );
}
