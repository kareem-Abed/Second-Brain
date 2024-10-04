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
