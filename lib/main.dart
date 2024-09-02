import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:al_maafer/app.dart';
import 'package:window_manager/window_manager.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.normal,
      windowButtonVisibility: true,
    );
    await windowManager.setMinimumSize(const Size(900, 500));
    await windowManager.show();
    // await windowManager.setPreventClose(true);
    // await windowManager.setSkipTaskbar(false);
  });

  await GetStorage.init();

  runApp(
    const App(),
  );
}


