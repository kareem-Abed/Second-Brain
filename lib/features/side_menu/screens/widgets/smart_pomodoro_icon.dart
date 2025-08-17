import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../utils/constants/colors.dart';
import '../../../pomodoro/controller/pomodoro_controller.dart';
import '../../controller/side_menu_controller.dart';

class SmartPomodoroIcon extends StatelessWidget {
  final double size = 18;

  SmartPomodoroIcon({
    super.key,
  });
  final pomodoroController = Get.find<PomodoroController>();

  final controller = Get.find<SideMenuController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Access all observable variables at the top level of Obx
      final isActive = pomodoroController.isActive.value;
      final progress = pomodoroController.progress.value;
      final completedSessions = pomodoroController.completedSessions.value;
      final selectedIndex = controller.selectedIndex.value;

      final color = selectedIndex == 5 ? Colors.white : Colors.grey;

      // Show progress indicator for active session
      if (isActive) {
        return SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 4.0,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: KColors.darkerGrey,
          ),
        );
      }

      // Show completion count when inactive
      if (completedSessions > 0) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Center(
            child: Text(
              '$completedSessions',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

      // Show default clock icon when no sessions
      return Icon(
        IconsaxPlusBold.timer,
        size: size,
        color: color,
      );
    });
  }
}
