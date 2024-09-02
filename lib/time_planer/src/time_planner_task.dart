import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';

import 'package:al_maafer/time_planer/src/time_planner_date_time.dart';
import 'package:al_maafer/time_planer/src/config/global_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget that show on time planner as the tasks
class TimePlannerTask extends StatelessWidget {
  final IconData icon;
  final String title;
  //--------------------------------------------------------------------------------
  /// Minutes duration of task or object
  final int minutesDuration;
  final int? iconIndex;

  /// Days duration of task or object, default is 1
  final int? daysDuration;

  /// When this task will be happen
  final TimePlannerDateTime dateTime;

  /// Background color of task
  final Color? color;

  /// This will be happen when user tap on task, for example show a dialog or navigate to other page
  final Function? onTap;

  /// Show this child on the task
  ///
  /// Typically an [Text].
  // final Widget? child;

  /// parameter to set space from left, to set it: config.cellWidth! * dateTime.day.toDouble()
  final double? leftSpace;

  /// parameter to set width of task, to set it: (config.cellWidth!.toDouble() * (daysDuration ?? 1)) -config.horizontalTaskPadding!
  final double? widthTask;

  Map<String, dynamic> toJson() {
    return {
      'color': color?.value,
      'iconIndex': iconIndex,
      'title': title,
      'dateTime': {
        'day': dateTime.day,
        'hour': dateTime.hour,
        'minutes': dateTime.minutes,
      },
      'minutesDuration': minutesDuration,
      'daysDuration': daysDuration,
    };
  }

  /// Widget that show on time planner as the tasks
  TimePlannerTask({
    Key? key,
    required this.minutesDuration,
    required this.dateTime,
    this.daysDuration,
    this.color,
    this.onTap,
    // this.child,
    this.leftSpace,
    this.widthTask,
    required this.icon,
    required this.title,
    this.iconIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final controller = Get.put(WeeklyCalendarController());
      final adjustedScreenWidth =
          screenWidth - (controller.showAddTask.value ? 486 : 134);

      final calculatedWidthTask = controller.showFullWidthTask.value
          ? adjustedScreenWidth
          : ((adjustedScreenWidth / config.totalDays) * (daysDuration ?? 1) -
              config.horizontalTaskPadding!);

      return Positioned(
        top: ((config.cellHeight! * (dateTime.hour - config.startHour)) +
                ((dateTime.minutes * config.cellHeight!) / 60))
            .toDouble(),
        left: controller.showFullWidthTask.value
            ? 0.0
            : (((adjustedScreenWidth) / config.totalDays) *
                    dateTime.day.toDouble() +
                (leftSpace ?? 0.0)),
        child: SizedBox(
          width: calculatedWidthTask,
          child: Padding(
            padding:
                EdgeInsets.only(left: config.horizontalTaskPadding!.toDouble()),
            child: Material(
              elevation: 3,
              borderRadius: config.borderRadius,
              child: Stack(
                children: [
                  InkWell(
                    onTap: onTap as void Function()? ?? () {},
                    child: Container(
                      height:
                          ((minutesDuration.toDouble() * config.cellHeight!) /
                              60), // 60 minutes
                      width: calculatedWidthTask,
                      decoration: BoxDecoration(
                        borderRadius: config.borderRadius,
                        color: color ?? Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: Container(
                          height: double.infinity,
                          width: double.maxFinite,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: minutesDuration <= 45
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            double iconSize =
                                                (constraints.maxHeight * 0.6)
                                                    .clamp(
                                                        8.0,
                                                        constraints.maxWidth *
                                                            0.6);
                                            return Icon(
                                              icon,
                                              color: Colors.white,
                                              size: iconSize,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            double textSize =
                                                (constraints.maxWidth * 0.12)
                                                    .clamp(10.0, 15.0);
                                            return Center(
                                              child: Text(
                                                title,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(Get.context!)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      fontSize: textSize,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            double iconSize = (constraints
                                                        .maxHeight *
                                                    1.0)
                                                .clamp(
                                                    10.0,
                                                    constraints.maxWidth *
                                                        0.6); // Adjust the multiplier and clamp values as needed
                                            return Icon(
                                              icon,
                                              color: Colors.white,
                                              size: iconSize,
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            double textSize =
                                                (constraints.maxWidth * 0.12)
                                                    .clamp(10.0, 15.0);
                                            return Center(
                                              child: Text(
                                                title,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(Get.context!)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      fontSize: textSize,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
