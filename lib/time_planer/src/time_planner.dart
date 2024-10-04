import 'package:intl/intl.dart' as intl;
import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:second_brain/time_planer/src/time_planner_style.dart';
import 'package:second_brain/time_planer/src/time_planner_task.dart';
import 'package:second_brain/time_planer/src/time_planner_time.dart';
import 'package:second_brain/time_planer/src/time_planner_title.dart';
import 'package:second_brain/time_planer/src/config/global_config.dart'
    as config;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

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
  final controller = Get.put(WeeklyCalendarController());

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
    // controller.updateTime();
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
      // color: style.backgroundColor,
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
                      child: widget.headers[controller.currentDay.value],
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
              child: Stack(
                children: [
                  Row(
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
                                TimePlannerTime(
                                  oneDayOnlyView: widget.viewCurrentDayOnly,
                                  time: formattedTime(i),
                                  setTimeOnAxis: config.setTimeOnAxis,
                                  textColor: controller.currentHour.value == i
                                      ? Colors.blue
                                      : Colors.white,
                                )
                            ],
                          ),
                          Container(
                            height:
                                (config.totalHours * config.cellHeight!) + 100,
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
                  Obx(
                    () => Positioned(
                      top: ((config.cellHeight! *
                                  (controller.currentHour.value -
                                      config.startHour)) +
                              ((controller.currentMinute.value *
                                      config.cellHeight!) /
                                  60)) -
                          10,
                      left: 0,
                      right: 0,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 58,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: FittedBox(
                                child: Text(
                                  intl.DateFormat(' h:mm a ').format(
                                    DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      controller.currentHour.value,
                                      controller.currentMinute.value,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.redAccent,
                              thickness: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
        final currentDayIndex = 6 - controller.currentDay.value;

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
                                // SizedBox(
                                //   height: (config.cellHeight! - 1).toDouble(),
                                // ),
                                // const Divider(
                                //   height: 1,
                                //   color: Colors.grey,
                                // ),
                                SizedBox(
                                  height:
                                      (config.cellHeight! / 2) - 1.toDouble(),
                                ),
                                DashedDivider(
                                  height: 1,
                                  color: widget.viewCurrentDayOnly
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.transparent,
                                  dashWidth: 5,
                                  dashSpace: 3,
                                ),
                                SizedBox(
                                  height:
                                      (config.cellHeight! / 2) - 1.toDouble(),
                                ),
                                const Divider(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          SizedBox(
                            height: (config.cellHeight! / 2) - 1.toDouble(),
                          ),
                          DashedDivider(
                            height: 1,
                            color: widget.viewCurrentDayOnly
                                ? Colors.grey.withOpacity(0.3)
                                : Colors.transparent,
                            dashWidth: 5,
                            dashSpace: 3,
                          ),
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
                                    color: i != config.totalDays - 1
                                        ? Colors.grey
                                        : Colors.transparent,
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

class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double dashHeight;

  const DashedDivider({
    Key? key,
    this.height = 1,
    this.color = Colors.black,
    this.dashWidth = 10,
    this.dashSpace = 5,
    this.dashHeight = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight, // Use dashHeight instead of height
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
