import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/pomodoro/controller/pomodoro_controller.dart';
import 'package:second_brain/features/pomodoro/screens/widgets/settings_widget.dart';
import 'package:second_brain/features/pomodoro/screens/widgets/timer_widget.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'package:get/get.dart';

class Pomodoro extends StatelessWidget {
  final PomodoroController controller = Get.put(PomodoroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [
              controller.isFullScreen.value
                  ? TimerWidget(controller: controller)
                  : Column(
                      children: [
                        SizedBox(
                          height: 640,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SettingsWidget(controller: controller),
                              Expanded(
                                flex: 2,
                                child: TimerWidget(controller: controller),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: HistoryWidget(controller: controller),
                        ),
                      ],
                    ),
            ],
          ),
        );
      }),
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
      margin: EdgeInsets.only(
        // top: 16,
        right: 16,
        left: 16,
        bottom: 16,
      ),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KColors.darkModeCard,
        border: Border.all(color: KColors.darkModeCardBorder, width: 1),
        borderRadius: BorderRadius.circular(KSizes.borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(IconsaxPlusLinear.trash),
                onPressed: () {
                  Get.defaultDialog(
                    backgroundColor: KColors.darkModeCard,
                    title: 'تأكيد الحذف',
                    content: Text(
                      'هل أنت متأكد أنك تريد حذف التاريخ؟',
                      style: Theme.of(Get.context!).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    confirm: ElevatedButton(
                      onPressed: () {
                        controller.clearHistory();
                        Get.back();
                      },
                      child: Text('نعم'),
                    ),
                    cancel: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('إلغاء'),
                    ),
                  );
                },
              ),
              SizedBox(width: 16),
              Text('Sessions History',
                  style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          SizedBox(height: 16),
          Obx(
            () => AlignedGridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              itemCount: controller.sessionHistory.length,
              itemBuilder: (context, index) {
                return StatCard(
                  sessionName: controller.sessionHistory
                      .elementAt(index)['sessionName']
                      .toString(),
                  sessionRounds: controller.sessionHistory
                      .elementAt(index)['sessionRounds']
                      .toString(),
                  totalDuration: controller.sessionHistory
                      .elementAt(index)['totalDuration']
                      .toString(),
                  date: controller.sessionHistory
                      .elementAt(index)['date']
                      .toString(),
                );
              },
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String sessionName, sessionRounds, totalDuration, date;

  const StatCard({
    Key? key,
    required this.sessionName,
    required this.sessionRounds,
    required this.totalDuration,
    required this.date,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    sessionName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    sessionRounds,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    totalDuration,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
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
