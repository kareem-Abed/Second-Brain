import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:second_brain/app.dart';
import 'package:simple_audio/simple_audio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SimpleAudio.init();

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

    // Enable launch at startup
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      packageName: packageInfo.packageName,
    );
    await launchAtStartup.enable();
    bool isEnabled = await launchAtStartup.isEnabled();
    print(isEnabled);
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
