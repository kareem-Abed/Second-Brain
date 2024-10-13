import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:second_brain/app.dart';
import 'package:media_kit/media_kit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(900, 500);
      win.minSize = initialSize;
      win.title = "Second Brain";
      win.show();
    });

    // Enable launch at startup
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('Platform.resolvedExecutable: ${Platform.resolvedExecutable}');
    print('packageInfo.appName: ${packageInfo.appName}');
    print('packageInfo.appName: ${packageInfo.packageName}');
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      packageName: packageInfo.packageName,
    );
    await launchAtStartup.enable();
      MediaKit.ensureInitialized();

    // bool isEnabled = await launchAtStartup.isEnabled();
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
