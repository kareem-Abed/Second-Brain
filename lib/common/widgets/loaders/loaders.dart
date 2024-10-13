import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/stacked_options.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:media_kit/media_kit.dart';
import 'package:second_brain/utils/constants/colors.dart';

class TLoaders {
  final windowsAudioPlayer = Player();
  static hideSnackBar() {
    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  }

  void successSnackBar({required String title, message = '', duration = 1}) {
    windowsAudioPlayer.open(Media("asset:///assets/sounds/timesup.mp3"));

    DelightToastBar(
      builder: (context) {
        return ToastCard(
          color: Colors.green.shade600,
          leading: const Icon(
            IconsaxPlusLinear.check,
            size: 32,
            color: KColors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: KColors.white,
              fontFamily: 'MontserratArabic',
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              color: KColors.white,
            ),
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: Duration(seconds: duration, milliseconds: 500),
    ).show(
      Get.context!,
    );
  }

  void warningSnackBar({
    required String title,
    message = '',
  }) {
    windowsAudioPlayer.open(Media("asset:///assets/sounds/error.mp3"));

    DelightToastBar(
      builder: (context) {
        return ToastCard(
          color: Colors.orange.shade600,
          leading: const Icon(
            IconsaxPlusLinear.warning_2,
            size: 32,
            color: KColors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              fontFamily: 'MontserratArabic',
              color: KColors.white,
            ),
          ),
          subtitle: Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'MontserratArabic',
              color: KColors.white,
            ),
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3, milliseconds: 500),
    ).show(
      Get.context!,
    );
  }

  void errorSnackBar({required String title, message = '', required context}) {
    windowsAudioPlayer.open(Media("asset:///assets/sounds/error.mp3"));
    ElegantNotification.error(
      width: 360,
      height: 100,
      background: KColors.darkModeSubCard,
      isDismissable: true,
      stackedOptions: StackedOptions(
        key: 'top',
        type: StackedType.same,
        itemOffset: const Offset(-5, -5),
      ),
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
      autoDismiss: true,
      onDismiss: () {
        //Message when the notification is dismissed
      },
      onNotificationPressed: () {
        //Message when the notification is pressed
      },
      border: const Border(
        bottom: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
    ).show(context);

    // DelightToastBar(
    //   builder: (context) {
    //     return ToastCard(
    //       color: Colors.red.shade600,
    //       leading: const Icon(
    //         IconsaxPlusLinear.warning_2,
    //         size: 32,
    //         color: KColors.white,
    //       ),
    //       title: Text(
    //         title,
    //         style: const TextStyle(
    //           fontWeight: FontWeight.w700,
    //           fontSize: 14,
    //           fontFamily: 'MontserratArabic',
    //           color: KColors.white,
    //         ),
    //       ),
    //       subtitle: Text(
    //         message,
    //         style: const TextStyle(
    //           fontSize: 12,
    //           fontFamily: 'MontserratArabic',
    //           color: KColors.white,
    //         ),
    //       ),
    //     );
    //   },
    //   position: DelightSnackbarPosition.top,
    //   autoDismiss: true,
    //   snackbarDuration: const Duration(
    //     seconds: 3,
    //   ),
    // ).show(
    //   Get.context!,
    // );
  }
}
