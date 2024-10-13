import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:second_brain/time_planer/src/config/global_config.dart'
    as config;
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class TimePlannerTime extends StatelessWidget {
  final DateTime time;
  final bool? oneDayOnlyView;
  final bool? setTimeOnAxis;
  final Color? textColor;

  const TimePlannerTime({
    Key? key,
    required this.time,
    this.setTimeOnAxis,
    this.textColor,
    this.oneDayOnlyView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeeklyCalendarController());

    double height = config.cellHeight!.toDouble();
    return SizedBox(
      height:
          (intl.DateFormat('ha').format(time) == '12AM') ? height - 25 : height,
      width: 64,
      child: Obx(() {
        return Column(
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
              Stack(
                children: [
                  Container(
                    height: (intl.DateFormat('ha').format(time) == '12AM')
                        ? height - 26
                        : height - 1,
                  ),
                  (intl.DateFormat('ha').format(time) != '12AM')
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  intl.DateFormat('h ').format(time) +
                                      intl.DateFormat('a')
                                          .format(time)
                                          .toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  if (oneDayOnlyView! &&
                      !(controller.currentHour.value == time.hour &&
                          controller.currentMinute >= 26 &&
                          controller.currentMinute <= 35))
                    Positioned(
                      bottom: 30,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              intl.DateFormat('h:30').format(time),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
          ],
        );
      }),
    );
  }
}
