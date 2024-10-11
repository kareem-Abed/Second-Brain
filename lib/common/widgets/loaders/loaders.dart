import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/helpers/helper_functions.dart';

class TLoaders {
  // static final AudioPlayer player = AudioPlayer();

  static hideSnackBar() {
    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  }

  static void customToast({required message}) {
    // player.play(AssetSource('sounds/error.mp3'));
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      elevation: 0,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.transparent,
      content: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: KHelperFunctions.isDarkMode(Get.context!)
                  ? KColors.darkGrey.withOpacity(0.9)
                  : KColors.grey.withOpacity(0.9),
            ),
            child: Center(
              child: Text(
                message,
                style: Theme.of(Get.context!).textTheme.labelLarge,
              ),
            )),
      ),
    ));
  }

  static void successSnackBar(
      {required String title, message = '', duration = 1}) {
    // player.play(volume: 100,AssetSource('sounds/success.mp3'));

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

  static void warningSnackBar({
    required String title,
    message = '',
  }) {
    // player.play(AssetSource('sounds/error.mp3'));
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

  static void errorSnackBar({
    required String title,
    message = '',
  }) {
    // player.play(AssetSource('sounds/error.mp3'));
    DelightToastBar(
      builder: (context) {
        return ToastCard(
          color: Colors.red.shade600,
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
      snackbarDuration: const Duration(
        seconds: 3,
      ),
    ).show(
      Get.context!,
    );
  }
}
