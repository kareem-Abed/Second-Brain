import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/pomodoro/controller/pomodoro_controller.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class TimerWidget extends StatelessWidget {
  TimerWidget({
    required this.controller,
  });
  final PomodoroController controller;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: controller.isFullScreen.value ? max(610, height - 100) : 610,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: KColors.darkModeCard,
        border: Border.all(color: KColors.darkModeCardBorder, width: 1),
        borderRadius: BorderRadius.circular(KSizes.borderRadius),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () async {
                // controller.playAudio("assets/sounds/success.mp3");
                controller.showSettings.value = false;
                controller.isFullScreen.value = !controller.isFullScreen.value;
              },
              icon: Obx(() {
                return Icon(
                  controller.isFullScreen.value
                      ? FontAwesomeIcons.minus
                      : IconsaxPlusLinear.maximize_4,
                  color: Colors.white,
                  size: 30,
                );
              }),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      color: KColors.darkModeSubCard,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: KColors.darkModeBackground,
                          blurRadius: 25,
                          spreadRadius: 10,
                          offset: Offset(15, 15),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 50,
                          spreadRadius: 1,
                          offset: Offset(-1, -1),
                        ),
                        BoxShadow(
                          color: KColors.darkModeBackground.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 1,
                          offset: Offset(20, 20),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: KColors.darkModeSubCard,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: KColors.darkModeBackground,
                          blurRadius: 25,
                          spreadRadius: 10,
                          offset: Offset(15, 15),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 50,
                          spreadRadius: 1,
                          offset: Offset(-1, -1),
                        ),
                        BoxShadow(
                          color: KColors.darkModeBackground.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 1,
                          offset: Offset(20, 20),
                        ),
                      ],
                    ),
                    child: Obx(() => GradientCircularProgressIndicator(
                          progress: controller.progress.value,
                          gradient: LinearGradient(
                            colors: controller.isBreak.value
                                ? [
                                    Color(0xFFFFA726),
                                    Color(0xFFFF7043),
                                    Color(0xFFD32F2F)
                                  ]
                                : [
                                    Color(0xFF1BFFFF),
                                    Colors.lightBlue,
                                    Color(0xFF2E3192)
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          backgroundColor: KColors.darkModeBackground,
                        )),
                  ),
                  Column(
                    children: [
                      Obx(() => Icon(
                            controller.isBreak.value
                                ? IconsaxPlusLinear.coffee
                                : IconsaxPlusLinear.eye,
                            size: 30,
                          )),
                      Obx(() => Text(
                          controller.isBreak.value ? 'Break' : 'Focus',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w600))),
                      Obx(() => Text(controller.timerString.value,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 70,
                              fontWeight: FontWeight.bold))),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Text(
                              '${controller.numberOfSessionRounds.value}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600))),
                          Text('/',
                              style: TextStyle(
                                  color: KColors.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          Obx(() => Text('${controller.sessionRounds..value}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600))),
                        ],
                      ),
                      Obx(() => Text(controller.sessionName.value,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Settings button
                  Container(
                    decoration: BoxDecoration(
                      color: KColors.darkModeSubCard,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 2,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () {
                        controller.isFullScreen.value = false;

                        controller.showSettings.value =
                            !controller.showSettings.value;
                      },
                      icon: Icon(
                        IconsaxPlusLinear.setting_2,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  // Start/Resume/Pause button
                  SizedBox(
                    width: 250,
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
                              offset: Offset(5, 5),
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold));
                          } else if (controller.progress.value == 1.0 &&
                              controller.isBreak.value) {
                            return Text('START Break',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold));
                          } else if (controller.isPaused.value) {
                            return Text('RESUME',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold));
                          } else {
                            return Text('PAUSE',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold));
                          }
                        }),
                      ),
                    ),
                  ),
                  // Reset button
                  Container(
                    decoration: BoxDecoration(
                      color: KColors.darkModeSubCard,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 2,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () {
                        controller.resetTimer();
                      },
                      icon: Icon(
                        IconsaxPlusLinear.repeat,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
