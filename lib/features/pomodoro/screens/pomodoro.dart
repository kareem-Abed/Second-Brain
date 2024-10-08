import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_circular_progress_indicator/gradient_circular_progress_indicator.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/pomodoro/controller/pomodoro_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

import 'package:get/get.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Pomodoro extends StatelessWidget {
  final PomodoroController controller = Get.put(PomodoroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: Row(
        children: [
          Obx(() {
            return controller.showSettings.value
                ? Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 560,
                            margin: EdgeInsets.only(
                              // top: 16,
                              right: 16,
                            ),
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: KColors.darkModeCard,
                              border: Border.all(
                                  color: KColors.darkModeCardBorder, width: 1),
                              borderRadius:
                                  BorderRadius.circular(KSizes.borderRadius),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      Obx(() {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(controller
                                              .focusDuration.value
                                              .toString()),
                                        );
                                      }),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText:
                                                'Focus Duration (minutes)',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            controller.focusDuration.value =
                                                int.parse(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Obx(() {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(controller
                                              .breakDuration.value
                                              .toString()),
                                        );
                                      }),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText:
                                                'Break Duration (minutes)',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            controller.breakDuration.value =
                                                int.parse(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Obx(() {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(controller
                                              .longBreakDuration.value
                                              .toString()),
                                        );
                                      }),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText:
                                                'Long Break Duration (minutes)',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            controller.longBreakDuration.value =
                                                int.parse(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Obx(() {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(controller
                                              .sessionName.value
                                              .toString()),
                                        );
                                      }),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Session Name',
                                          ),
                                          onChanged: (value) {
                                            controller.sessionName.value =
                                                value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Obx(() {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(controller
                                              .numberOfSubSessions.value
                                              .toString()),
                                        );
                                      }),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Number of Sub-Sessions',
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            controller.numberOfSubSessions
                                                .value = int.parse(value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.saveValues();
                                    },
                                    child: Text('Save Settings'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // HistoryWidget(controller: controller),
                        ],
                      ),
                    ),
                  )
                : SizedBox();
          }),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TimerWidget(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({
    super.key,
    required this.controller,
  });

  final PomodoroController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.only(top: 16, right: 16, bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KColors.darkModeCard,
        border: Border.all(color: KColors.darkModeCardBorder, width: 1),
        borderRadius: BorderRadius.circular(KSizes.borderRadius),
      ),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        children: [
          StatCard(
            icon: Icons.access_time_filled_outlined,
            value: controller.totalMin.toString(),
            label: 'total minutes',
          ),
          StatCard(
            icon: Icons.emoji_events,
            value: controller.longestSesh.toString(),
            label: 'longest session',
          ),
          StatCard(
            icon: Icons.calendar_month_rounded,
            value: controller.sessionNum.toString(),
            label: 'number of sessions',
          ),
          StatCard(
            icon: Icons.bar_chart_rounded,
            value: double.parse((controller.avgSesh).toStringAsFixed(2))
                .toString(),
            label: 'avg session time',
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatCard({
    Key? key,
    required this.icon,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KSizes.borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      color: KColors.darkModeSubCard,
      shadowColor: KColors.dark,
      elevation: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: KColors.primary,
            size: 35,
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                label + " => " + value,
                style: TextStyle(
                  color: KColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                ),
              ),
            ),
          ),
          // FittedBox(
          //   fit: BoxFit.scaleDown,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       label,
          //       style: TextStyle(
          //         color: Colors.greenAccent,
          //         fontSize: 12,
          //         fontWeight: FontWeight.bold,
          //         fontFamily: 'Arial',
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required this.controller,
  });

  final PomodoroController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: KColors.darkModeCard,
        border: Border.all(color: KColors.darkModeCardBorder, width: 1),
        borderRadius: BorderRadius.circular(KSizes.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              child: IconButton(
                onPressed: () async {
                  controller.playAudio("assets/sounds/success.mp3");
                  // controller.showSettings.value =
                  //     !controller.showSettings.value;
                },
                icon: Obx(() {
                  return Icon(
                    controller.showSettings.value
                        ? IconsaxPlusLinear.maximize_4
                        : FontAwesomeIcons.minus,
                    color: Colors.white,
                    size: 30,
                  );
                }),
              ),
            ),
          ),
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
                  Obx(() => Text(controller.timerString.value,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 70,
                          fontWeight: FontWeight.bold))),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => Text('${controller.numberOfSubSessions.value}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.w600))),
                      Text('/',
                          style: TextStyle(
                              color: KColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Obx(() => Text('${controller.sessionCount..value}',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.w600))),
                    ],
                  ),
                  Obx(() => Text(controller.isBreak.value ? 'Break' : 'Focus',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w600))),
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
    );
  }
}
