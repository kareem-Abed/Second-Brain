import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:system_tray/system_tray.dart';

class SideMenuController extends GetxController {
  // Observable property to track the selected menu index
  var selectedIndex = 0.obs;
  // RxInt iconIndex = 0.obs;
  PageController pageController = PageController();
  final AppWindow _appWindow = AppWindow();
  final SystemTray _systemTray = SystemTray();
  final Menu _menuMain = Menu();
  final windowsAudioPlayer = Player();
  // Method to update the selected menu index
  void updateSelectedIndex(int index) {
    pageController.jumpToPage(index);
    selectedIndex.value = index;
  }

  Future<void> initSystemTray() async {
    await _systemTray.initSystemTray(iconPath: 'assets/images/app_icon.ico');
    _systemTray.setTitle("Second Brain");
    _systemTray.setToolTip("Second Brain");
    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        if (!appWindow.isVisible) {
          _appWindow.show();
        }
      } else if (eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu();
      }
    });
    await _menuMain.buildFrom(
      [
        MenuItemLabel(
          label: 'اخفاء',
          onClicked: (menuItem) {
            _appWindow.hide();
          },
        ),
        MenuSeparator(),
        MenuItemCheckbox(
          label: "إظهار الإخطارات",
          name: "إظهار الإخطارات",
          checked: true,
          onClicked: (menuItem) async {
            debugPrint("click 'Checkbox 1'");

            MenuItemCheckbox? checkbox1 =
                _menuMain.findItemByName<MenuItemCheckbox>("إظهار الإخطارات");
            await checkbox1?.setCheck(!checkbox1.checked);
          },
        ),
        MenuSeparator(),
        MenuItemLabel(
            label: 'Quit Second Brain',
            onClicked: (menuItem) => _appWindow.close()),
      ],
    );
    _systemTray.setContextMenu(_menuMain);
  }

  void playSound() {
    // windowsAudioPlayer.setVolume(1.2);

    windowsAudioPlayer.open(Media("asset:///assets/sounds/bite.mp3"));
  }

  // Method to handle exit action
  void handleExit() {
    exit(0);
  }

  @override
  void onInit() {
    super.onInit();
    initSystemTray();
  }
}
