import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:second_brain/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_add_update.dart';
import 'package:second_brain/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_planner.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_brain/utils/constants/sizes.dart';

class WeeklyCalendarScreen extends StatelessWidget {
  const WeeklyCalendarScreen({super.key, required this.viewCurrentDayOnly});
  final bool viewCurrentDayOnly;
  @override
  Widget build(BuildContext context) {
    final WeeklyCalendarController controller =
        Get.put(WeeklyCalendarController());

    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: Row(
        children: [
          Obx(() {
            if (controller.showAddTask.value) {
              return Container(
                margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  color: KColors.darkModeCard,
                  border:
                      Border.all(color: KColors.darkModeCardBorder, width: 1),
                  borderRadius: BorderRadius.circular(KSizes.borderRadius),
                ),
                width: 300,
                child: SingleChildScrollView(child: AddTaskForm()),
              );
            } else {
              return Container();
            }
          }),
          Expanded(
              flex: 2,
              child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: KColors.darkModeCard,
                    border:
                        Border.all(color: KColors.darkModeCardBorder, width: 1),
                    borderRadius: BorderRadius.circular(KSizes.borderRadius),
                  ),
                  child: WeeklyCalendarPlanner(
                      viewCurrentDayOnly: viewCurrentDayOnly))),
        ],
      ),
    );
  }
}
