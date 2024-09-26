import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:second_brain/time_planer/src/config/global_config.dart' as config;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TimePlannerTime extends StatelessWidget {
  final DateTime time;
  final String? textStar;
  final bool? setTimeOnAxis;
  final Color? textColor;

  const TimePlannerTime({
    Key? key,
    required this.time,
    this.setTimeOnAxis,
    this.textColor,
    this.textStar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(TimePlannerController());
    final controller = Get.put(WeeklyCalendarController());

    final widgetHour = time.hour;

    double height = config.cellHeight!.toDouble();
    return Obx(() {
      return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.blue,
                width: 2,
              ),
            ),
          ),
          height: height,
          width: 64,
          child: Stack(
            children: [
              Positioned(
                top: config.cellHeight! * 0.05,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  // height: 15,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: FittedBox(
                            child: Text(DateFormat('h:mma ').format(time),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ),
                        Expanded(child: Divider(color: textColor, height: 1)),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (height / 4) * 1 + 1.5,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  height: 15,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: FittedBox(
                              child: Text(
                                  DateFormat('h:mm')
                                      .format(time.add(Duration(minutes: 15))),
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            )),
                        Expanded(child: Divider(color: textColor, height: 1)),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (height / 4) * 2 - 1.9,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  height: 15,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: FittedBox(
                              child: Text(
                                  DateFormat('h:mm')
                                      .format(time.add(Duration(minutes: 30))),
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            )),
                        Expanded(child: Divider(color: textColor, height: 1)),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: (height / 4) * 3 - 5.6,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  height: 15,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: FittedBox(
                              child: Text(
                                  DateFormat('h:mm')
                                      .format(time.add(Duration(minutes: 45))),
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            )),
                        Expanded(child: Divider(color: textColor, height: 1)),
                      ],
                    ),
                  ),
                ),
              ),
              if (widgetHour == controller.currentHour.value)
                Obx(() {
                  final totalMinutes = controller.currentMinute.value;
                  final minuteHeight = (height - 15) /
                      60; // Adjust for the height of the time text
                  final position = minuteHeight * totalMinutes + 5;
                  return Positioned(
                    top: position,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 45.0),
                      child: Row(
                        children: [
                          Text(
                              DateFormat('m ').format(time.add(Duration(
                                  minutes: controller.currentMinute.value))),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                          Expanded(
                            child: Divider(
                              color: Colors.red,
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ));
    });
  }
}
