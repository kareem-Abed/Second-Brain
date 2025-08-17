import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:system_tray/system_tray.dart';

class SideMenuController extends GetxController {
  var selectedIndex = 0.obs;
  // final AppWindow _appWindow = AppWindow();
  // final SystemTray _systemTray = SystemTray();
  // final Menu _menuMain = Menu();
  final windowsAudioPlayer = Player();

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void playSound() {
    // windowsAudioPlayer.setVolume(1.2);
    windowsAudioPlayer.open(Media("asset:///assets/sounds/bite.mp3"));
  }
}
