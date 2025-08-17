import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questly/features/pomodoro/controller/pomodoro_controller.dart';
import 'package:questly/features/pomodoro/screens/widgets/settings_widget.dart';
import 'package:questly/features/pomodoro/screens/widgets/timer_widget.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:get/get.dart';

class Pomodoro extends StatelessWidget {
  const Pomodoro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: Column(
        children: [
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: KSizes.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Pomodoro',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          TimerWidget(),
        ],
      ),
    );
  }
}
