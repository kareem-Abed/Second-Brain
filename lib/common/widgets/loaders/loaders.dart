import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:elegant_notification/resources/stacked_options.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:media_kit/media_kit.dart';
import 'package:second_brain/utils/constants/colors.dart';

class TLoaders {
  final windowsAudioPlayer = Player();

  static hideSnackBar() {
    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  }

  void successSnackBar(
      {required String title, message = '', duration = 1, required context}) {
    windowsAudioPlayer.open(Media("asset:///assets/sounds/timesup.mp3"));
    ElegantNotification(
      displayCloseButton: true,
      width: 360,
      height: 100,
      background: KColors.darkModeSubCard,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: 'MontserratArabic',
          color: KColors.white,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'MontserratArabic',
          color: KColors.white,
        ),
      ),
      icon: const Icon(
        FontAwesomeIcons.check,
        color: Colors.green,
      ),
      progressIndicatorColor: Colors.green,
    ).show(context);
  }

  void warningSnackBar(
      {required String title, message = '', required context}) {
    windowsAudioPlayer.open(Media("asset:///assets/sounds/error.mp3"));
    ElegantNotification(
      displayCloseButton: true,
      width: 360,
      height: 100,
      background: KColors.darkModeSubCard,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: 'MontserratArabic',
          color: KColors.white,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'MontserratArabic',
          color: KColors.white,
        ),
      ),
      icon: const Icon(
        IconsaxPlusLinear.warning_2,
        color: Colors.orange,
      ),
      progressIndicatorColor: Colors.orange,
    ).show(context);
  }

  Future<void> errorSnackBar(
      {required String title, message = '', required context}) async {
    windowsAudioPlayer.open(Media("asset:///assets/sounds/error.mp3"));

    ElegantNotification(
      displayCloseButton: true,
      width: 360,
      height: 100,
      background: KColors.darkModeSubCard,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          fontFamily: 'MontserratArabic',
          color: KColors.white,
        ),
      ),
      description: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'MontserratArabic',
          color: KColors.white,
        ),
      ),
      icon: const Icon(
        FontAwesomeIcons.triangleExclamation,
        color: Colors.red,
      ),
      progressIndicatorColor: Colors.red,
    ).show(context);
  }
}
