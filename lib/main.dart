import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:al_maafer/app.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    // await windowManager.setTitleBarStyle(
    //   TitleBarStyle.hidden,
    //   windowButtonVisibility: false,
    // );
    await windowManager.setMinimumSize(const Size(800, 500));
    // await windowManager.show();
    // await windowManager.setPreventClose(true);
    // await windowManager.setSkipTaskbar(false);
  });

  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
// FirebaseApi().initNotification();

  runApp(
    const App(),
  );
}
