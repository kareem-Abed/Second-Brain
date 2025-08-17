import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questly/features/pomodoro/controller/pomodoro_controller.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class TimerWidget extends StatelessWidget {
  TimerWidget({
    super.key,
  });

  final controller = Get.find<PomodoroController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(KSizes.borderRadius),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;

            // Calculate responsive sizes
            final maxCircleSize =
                min(availableWidth * 0.6, availableHeight * 0.5);
            final outerCircleSize = min(maxCircleSize, 400.0);
            final innerCircleSize = outerCircleSize * 0.75;
            final timerFontSize = (outerCircleSize * 0.175).clamp(40.0, 70.0);
            final buttonWidth = min(availableWidth * 0.4, 250.0);

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: outerCircleSize,
                          height: outerCircleSize,
                          decoration: BoxDecoration(
                            color: KColors.darkModeSubCard,
                            shape: BoxShape.circle,
                            boxShadow: [
                              const BoxShadow(
                                color: KColors.darkModeBackground,
                                blurRadius: 25,
                                spreadRadius: 10,
                                offset: Offset(15, 15),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 50,
                                spreadRadius: 1,
                                offset: const Offset(-1, -1),
                              ),
                              BoxShadow(
                                color:
                                    KColors.darkModeBackground.withOpacity(0.5),
                                blurRadius: 50,
                                spreadRadius: 1,
                                offset: const Offset(20, 20),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: innerCircleSize,
                          height: innerCircleSize,
                          decoration: BoxDecoration(
                            color: KColors.darkModeSubCard,
                            shape: BoxShape.circle,
                            boxShadow: [
                              const BoxShadow(
                                color: KColors.darkModeBackground,
                                blurRadius: 25,
                                spreadRadius: 10,
                                offset: Offset(15, 15),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                blurRadius: 50,
                                spreadRadius: 1,
                                offset: const Offset(-1, -1),
                              ),
                              BoxShadow(
                                color:
                                    KColors.darkModeBackground.withOpacity(0.5),
                                blurRadius: 50,
                                spreadRadius: 1,
                                offset: const Offset(20, 20),
                              ),
                            ],
                          ),
                          child: Obx(() => GradientCircularProgressIndicator(
                                progress: controller.progress.value,
                                gradient: LinearGradient(
                                  colors: controller.isBreak.value
                                      ? [
                                          const Color(0xFFFFA726),
                                          const Color(0xFFFF7043),
                                          const Color(0xFFD32F2F)
                                        ]
                                      : [
                                          const Color(0xFF1BFFFF),
                                          Colors.lightBlue,
                                          const Color(0xFF2E3192)
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                backgroundColor: KColors.darkModeBackground,
                              )),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Icon(
                                  controller.isBreak.value
                                      ? IconsaxPlusLinear.coffee
                                      : IconsaxPlusLinear.eye,
                                  size: outerCircleSize * 0.075,
                                )),
                            Obx(() => Text(
                                controller.isBreak.value ? 'Break' : 'Focus',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: outerCircleSize * 0.05,
                                    fontWeight: FontWeight.w600))),
                            Obx(() => Text(controller.timerString.value,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: timerFontSize,
                                    fontWeight: FontWeight.bold))),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(() => Text(
                                    '${controller.numberOfSessionRounds.value}',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: outerCircleSize * 0.05,
                                        fontWeight: FontWeight.w600))),
                                Text('/',
                                    style: TextStyle(
                                        color: KColors.primary,
                                        fontSize: outerCircleSize * 0.05,
                                        fontWeight: FontWeight.bold)),
                                Obx(() => Text(
                                    '${controller.sessionRounds.value}',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: outerCircleSize * 0.05,
                                        fontWeight: FontWeight.w600))),
                              ],
                            ),
                            Obx(() => Text(controller.sessionName.value,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: outerCircleSize * 0.05,
                                    fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: availableHeight * 0.05),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: buttonWidth,
                          child: InkWell(
                            onTap: () {
                              if (controller.progress.value == 1.0 &&
                                  !controller.isBreak.value) {
                                controller.startFocusSession();
                              } else if (controller.progress.value == 1.0 &&
                                  controller.isBreak.value) {
                                controller.startBreakSession();
                              } else if (controller.isPaused.value) {
                                controller.resumeTimer();
                              } else {
                                controller.pauseTimer();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: KColors.darkModeSubCard,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 50,
                                    spreadRadius: 2,
                                    offset: const Offset(5, 5),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 32.0),
                              child: Obx(() {
                                if (controller.progress.value == 1.0 &&
                                    !controller.isBreak.value) {
                                  return Text('START',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: buttonWidth * 0.096,
                                          fontWeight: FontWeight.bold));
                                } else if (controller.progress.value == 1.0 &&
                                    controller.isBreak.value) {
                                  return Text('START Break',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: buttonWidth * 0.096,
                                          fontWeight: FontWeight.bold));
                                } else if (controller.isPaused.value) {
                                  return Text('RESUME',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: buttonWidth * 0.096,
                                          fontWeight: FontWeight.bold));
                                } else {
                                  return Text('PAUSE',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: buttonWidth * 0.096,
                                          fontWeight: FontWeight.bold));
                                }
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: availableHeight * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: KColors.darkModeSubCard,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 50,
                                spreadRadius: 2,
                                offset: const Offset(5, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: IconButton(
                            onPressed: () {
                              controller.resetTimer();
                            },
                            icon: Icon(
                              IconsaxPlusLinear.repeat,
                              color: Colors.white,
                              size: outerCircleSize * 0.075,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
