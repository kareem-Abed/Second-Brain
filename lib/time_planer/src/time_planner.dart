import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:second_brain/time_planer/src/time_planner_style.dart';
import 'package:second_brain/time_planer/src/time_planner_task.dart';
import 'package:second_brain/time_planer/src/time_planner_time.dart';
import 'package:second_brain/time_planer/src/time_planner_title.dart';
import 'package:second_brain/time_planer/src/config/global_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

/// TimePlannerController with GetX
// class TimePlannerController extends GetxController {
//
//   var currentHour = DateTime.now().hour.obs;
//   var currentMinute = DateTime.now().minute.obs;
//
//   var dividerColor = Colors.white.obs;
//   RxInt currentDay = 0.obs;
//
//   final weeklyCalendarController = Get.find<WeeklyCalendarController>();
//
//   /// Timer to update the time every minute
//   Timer? timer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     updateTime();
//     currentDay.value = 6 - weeklyCalendarController.currentDay.value;
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       updateTime();
//     });
//   }
//
//   void updateTime() {
//     var now = DateTime.now();
//
//     currentHour.value = now.hour;
//     currentMinute.value = now.minute;
//     if (currentHour.value == 0) {
//       weeklyCalendarController.getCurrentDay();
//     }
//   }
//
//   @override
//   void onClose() {
//     timer?.cancel();
//     super.onClose();
//   }
// }

class TimePlanner extends StatefulWidget {
  /// Time start from this, it will start from 0
  final int startHour;

  /// Time end at this hour, max value is 23
  final int endHour;

  /// Create days from here, each day is a TimePlannerTitle.
  ///
  /// you should create at least one day
  final List<TimePlannerTitle> headers;

  /// List of widgets on time planner
  final List<TimePlannerTask>? tasks;

  /// Style of time planner
  final TimePlannerStyle? style;

  /// When widget loaded scroll to current time with an animation. Default is true
  final bool? currentTimeAnimation;

  /// Whether time is displayed in 24 hour format or am/pm format in the time column on the left.
  final bool use24HourFormat;

  /// Whether the time is displayed on the axis of the time or on the center of the timeblock. Default is false.
  final bool setTimeOnAxis;

  /// Whether to display tasks of the current day only
  final bool viewCurrentDayOnly;

  /// Time planner widget
  const TimePlanner({
    Key? key,
    required this.startHour,
    required this.endHour,
    required this.headers,
    this.tasks,
    this.style,
    this.use24HourFormat = false,
    this.setTimeOnAxis = false,
    this.currentTimeAnimation,
    this.viewCurrentDayOnly = true,
  }) : super(key: key);

  @override
  _TimePlannerState createState() => _TimePlannerState();
}

class _TimePlannerState extends State<TimePlanner> {
  ScrollController timeVerticalController = ScrollController();
  TimePlannerStyle style = TimePlannerStyle();
  List<TimePlannerTask> tasks = [];
  bool? isAnimated = true;

  /// Initialize the controller
  // final TimePlannerController controller = Get.put(TimePlannerController());
  final  controller = Get.put(WeeklyCalendarController());

  /// check input value rules
  void _checkInputValue() {
    if (widget.startHour > widget.endHour) {
      throw FlutterError("Start hour should be lower than end hour");
    } else if (widget.startHour < 0) {
      throw FlutterError("Start hour should be larger than 0");
    } else if (widget.endHour > 23) {
      throw FlutterError("End hour should be lower than 23");
    } else if (widget.headers.isEmpty) {
      throw FlutterError("Header can't be empty");
    }
  }

  /// create local style
  void _convertToLocalStyle() {
    style.backgroundColor = widget.style?.backgroundColor;
    style.cellHeight = widget.style?.cellHeight ?? 80;
    style.cellWidth = widget.style?.cellWidth ?? 90;
    style.horizontalTaskPadding = widget.style?.horizontalTaskPadding ?? 0;
    style.borderRadius = widget.style?.borderRadius ??
        const BorderRadius.all(Radius.circular(8.0));
    style.dividerColor = widget.style?.dividerColor;
    style.showScrollBar = widget.style?.showScrollBar ?? false;
    style.interstitialOddColor = widget.style?.interstitialOddColor;
    style.interstitialEvenColor = widget.style?.interstitialEvenColor;
  }

  /// store input data to static values
  void _initData() {
    _checkInputValue();
    _convertToLocalStyle();
    config.horizontalTaskPadding = style.horizontalTaskPadding;
    config.cellHeight = style.cellHeight;
    config.cellWidth = style.cellWidth;
    config.totalHours = (widget.endHour - widget.startHour).toDouble();
    config.totalDays = widget.headers.length;
    config.startHour = widget.startHour;
    config.use24HourFormat = widget.use24HourFormat;
    config.setTimeOnAxis = widget.setTimeOnAxis;
    config.borderRadius = style.borderRadius;
    isAnimated = widget.currentTimeAnimation;
    tasks = widget.tasks ?? [];
  }

  @override
  void initState() {
    _initData();
    super.initState();
    controller.updateTime(); // Update the current time
    Future.delayed(Duration.zero).then((_) {
      int hour = DateTime.now().hour;
      if (isAnimated != null && isAnimated == true) {
        if (hour > widget.startHour) {
          double scrollOffset =
              (hour - widget.startHour) * config.cellHeight!.toDouble();
          timeVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    timeVerticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tasks = widget.tasks ?? [];

    return Container(
      color: style.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final adjustedScreenWidth = screenWidth - 65;
              final calculatedWidth = adjustedScreenWidth /
                  (widget.viewCurrentDayOnly ? 1 : config.totalDays);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    width: 64,
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          ' الساعه / اليوم ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.viewCurrentDayOnly)
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: style.dividerColor!.withOpacity(0.9),
                            width: 1.2,
                          ),
                        ),
                      ),
                      width: calculatedWidth,
                      child: widget.headers[6 - controller.currentDay.value],
                    )
                  else
                    for (int i = 0; i < config.totalDays; i++)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: style.dividerColor!.withOpacity(0.9),
                              width: 1.2,
                            ),
                          ),
                        ),
                        width: calculatedWidth,
                        child: widget.headers[i],
                      ),
                ],
              );
            },
          ),
          Container(
            height: 1,
            color: style.dividerColor ?? Theme.of(context).primaryColor,
          ),
          Expanded(
            child: SingleChildScrollView(

              controller: timeVerticalController,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (int i = widget.startHour;
                              i <= widget.endHour;
                              i++)
                            Obx(() => TimePlannerTime(
                                  time: formattedTime(i),
                                  setTimeOnAxis: config.setTimeOnAxis,
                                  textColor: controller.currentHour.value == i
                                      ? Colors.blue
                                      : Colors.white,
                                  textStar: controller.currentHour.value == i
                                      ? '*'
                                      : '',
                                )),
                        ],
                      ),
                      Container(
                        height: (config.totalHours * config.cellHeight!) + 100,
                        width: 1,
                        color: style.dividerColor ??
                            Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  Expanded(
                    child: buildMainBody(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainBody() {
    final crossAxisAlignment = CrossAxisAlignment.start;
    final mainAxisAlignment = MainAxisAlignment.start;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final calculatedWidth = screenWidth / config.totalDays;
        final currentDayIndex = controller.currentDay.value;

        List<TimePlannerTask> filteredTasks = tasks.where((task) {
          final taskStartDayIndex = task.dateTime.day;
          final taskEndDay = task.daysDuration!;

          if (taskStartDayIndex <= currentDayIndex &&
              taskStartDayIndex + taskEndDay > currentDayIndex) {
            return true;
          } else {
            return false;
          }
        }).toList();

        return Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: (config.totalHours * config.cellHeight!) + 100,
                  width: screenWidth,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (var i = 0; i < config.totalHours; i++)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: (config.cellHeight! - 1).toDouble(),
                                ),
                                const Divider(
                                  height: 1,
                                ),
                              ],
                            )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (!widget.viewCurrentDayOnly)
                            for (var i = 0; i < config.totalDays; i++)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(
                                    width: (calculatedWidth - 1).toDouble(),
                                  ),
                                  Container(
                                    width: 1,
                                    height: (config.totalHours *
                                            config.cellHeight!) +
                                        config.cellHeight!,
                                    color: Colors.grey.shade800,
                                  )
                                ],
                              )
                        ],
                      ),
                      if (widget.viewCurrentDayOnly)
                        for (int i = 0; i < filteredTasks.length; i++)
                          filteredTasks[i]
                      else
                        for (int i = 0; i < tasks.length; i++) tasks[i],
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  DateTime formattedTime(int hour) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, 0);
  }
}
