import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:second_brain/time_planer/src/config/global_config.dart'
    as config;
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class TimePlannerTime extends StatelessWidget {
  final DateTime time;
  // final String? textStar;
  final bool? setTimeOnAxis;
  final Color? textColor;

  const TimePlannerTime({
    Key? key,
    required this.time,
    this.setTimeOnAxis,
    this.textColor,
    // this.textStar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeeklyCalendarController());

    double height = config.cellHeight!.toDouble();
    return Container(
      height: height,
      width: 64,
      child: Column(
        children: [
          if ((controller.currentHour.value == time.hour &&
                  (controller.currentMinute.value >= time.minute - 6 &&
                      controller.currentMinute.value <= time.minute + 6)) ||
              (controller.currentHour.value == time.hour - 1 &&
                  controller.currentMinute >= 54 &&
                  time.minute <= 6) ||
              (controller.currentHour.value == time.hour + 1 &&
                  controller.currentMinute <= 6 &&
                  time.minute >= 54))
            Container()
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    intl.DateFormat('h ').format(time) +
                        intl.DateFormat('a').format(time).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
