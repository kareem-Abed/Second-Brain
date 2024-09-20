//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:second_brain/common/widgets/loaders/animation_loader.dart';
// import 'package:second_brain/utils/constants/colors.dart';
// import 'package:second_brain/utils/helpers/helper_functions.dart';
//
// class KFullScreenLoader {
//   static void openLoaderDialog(String text, String anumation) {
//     showDialog(
//       context: Get.overlayContext!,
//       barrierDismissible: false,
//       builder: (_) => PopScope(
//         canPop: false,
//         child: Container(
//           color: KHelperFunctions.isDarkMode(Get.context!)
//               ? KColors.dark
//               : KColors.white,
//           width: double.infinity,
//           height: double.infinity,
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 250,
//               ),
//               TAnimationLoaderWidget(
//                 animation: anumation,
//                 text: text,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   static stopLoading() {
//     Navigator.of(Get.overlayContext!).pop();
//   }
// }
