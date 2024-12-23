import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:second_brain/time_planer/src/time_planner_date_time.dart';
import 'package:second_brain/time_planer/src/config/global_config.dart'
    as config;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_brain/utils/constants/colors.dart';

/// Widget that show on time planner as the tasks
class TimePlannerTask extends StatelessWidget {
  final IconData icon;
  final String title;
  //--------------------------------------------------------------------------------
  /// Minutes duration of task or object
  final int minutesDuration;
  final int iconIndex;

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
  const TimePlannerTask({
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
    required this.iconIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final controller = Get.put(WeeklyCalendarController());
      final adjustedScreenWidth =
          // screenWidth - (controller.showAddTask.value ? 486 : 134);
          screenWidth - (controller.showAddTask.value ? 495 : 179);

      final calculatedWidthTask = controller.showFullWidthTask.value
          ? adjustedScreenWidth
          : ((adjustedScreenWidth / config.totalDays) * (daysDuration ?? 1) -
              config.horizontalTaskPadding!);

      return Positioned(
        top: ((config.cellHeight! * (dateTime.hour - config.startHour)) +
                ((dateTime.minutes * config.cellHeight!) / 60))
            .toDouble(),
        left: controller.showFullWidthTask.value
            ? 3.0
            : (((adjustedScreenWidth) / config.totalDays) *
                        dateTime.day.toDouble() +
                    (leftSpace ?? 0.0)) +
                3,
        child: SizedBox(
          width: calculatedWidthTask - 5,
          child: Padding(
            padding:
                EdgeInsets.only(left: config.horizontalTaskPadding!.toDouble(),top: 1),
            child: Material(
              elevation: 1,
              borderRadius: config.borderRadius,
              child: InkWell(
                onTap: onTap as void Function()? ?? () {},
                child: Container(
                  height:
                      (((minutesDuration.toDouble() - 2) * config.cellHeight!) /
                          60), // 60 minutes
                  width: calculatedWidthTask,
                  decoration: BoxDecoration(
                    borderRadius: config.borderRadius,
                    color: KColors.darkModeSubCard,
                    border: Border.all(
                      color: color ?? KColors.darkModeCardBorder,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: minutesDuration <= 45
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double iconSize =
                                          (constraints.maxHeight * 0.6).clamp(
                                              8.0, // Ensure the minimum value is valid
                                              constraints.maxWidth * 0.6);

                                      return Icon(
                                        icon,
                                        color: color ?? Colors.white,
                                        size: iconSize,
                                      );
                                    },
                                  ),
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
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      double iconSize =
                                          (constraints.maxHeight * 1.0).clamp(
                                        10.0,
                                        constraints.maxWidth * 0.6,
                                      );
                                      return Center(
                                        child: Icon(
                                          icon,
                                          applyTextScaling: true,
                                          color: color ?? Colors.white,
                                          size: iconSize,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
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
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
