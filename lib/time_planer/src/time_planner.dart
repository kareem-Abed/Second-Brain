import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/time_planer/src/time_planner_style.dart';
import 'package:al_maafer/time_planer/src/time_planner_task.dart';
import 'package:al_maafer/time_planer/src/time_planner_time.dart';
import 'package:al_maafer/time_planer/src/time_planner_title.dart';
import 'package:al_maafer/time_planer/src/config/global_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

// /// TimePlannerController with GetX
// class TimePlannerController extends GetxController {
//   var currentHour = DateTime.now().hour.obs;
//   var dividerColor = Colors.white.obs;
//   final weeklyCalendarController = Get.find<WeeklyCalendarController>();
//
//   /// Timer to update the time every minute
//   Timer? timer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     updateTime();
//     timer = Timer.periodic(const Duration(minutes: 1), (timer) {
//       updateTime();
//     });
//   }
//
//   void updateTime() {
//     int hour = DateTime.now().hour;
//     currentHour.value = hour;
//     if (hour == 0) {
//       weeklyCalendarController.getCurrentDay();
//     }
//     // print('current hour: $hour');
//   }
//
//   @override
//   void onClose() {
//     timer?.cancel();
//     super.onClose();
//   }
// }
// /// Time planner widget
// class TimePlanner extends StatefulWidget {
//   /// Time start from this, it will start from 0
//   final int startHour;
//
//   /// Time end at this hour, max value is 23
//   final int endHour;
//
//   /// Create days from here, each day is a TimePlannerTitle.
//   ///
//   /// you should create at least one day
//   final List<TimePlannerTitle> headers;
//
//   /// List of widgets on time planner
//   final List<TimePlannerTask>? tasks;
//
//   /// Style of time planner
//   final TimePlannerStyle? style;
//
//   /// When widget loaded scroll to current time with an animation. Default is true
//   final bool? currentTimeAnimation;
//
//   /// Whether time is displayed in 24 hour format or am/pm format in the time column on the left.
//   final bool use24HourFormat;
//
//   //Whether the time is displayed on the axis of the tim or on the center of the timeblock. Default is false.
//   final bool setTimeOnAxis;
//
//   /// Time planner widget
//   const TimePlanner({
//     Key? key,
//     required this.startHour,
//     required this.endHour,
//     required this.headers,
//     this.tasks,
//     this.style,
//     this.use24HourFormat = false,
//     this.setTimeOnAxis = false,
//     this.currentTimeAnimation,
//   }) : super(key: key);
//
//   @override
//   _TimePlannerState createState() => _TimePlannerState();
// }
// class _TimePlannerState extends State<TimePlanner> {
//   ScrollController mainHorizontalController = ScrollController();
//   ScrollController mainVerticalController = ScrollController();
//   ScrollController dayHorizontalController = ScrollController();
//   ScrollController timeVerticalController = ScrollController();
//   TimePlannerStyle style = TimePlannerStyle();
//   List<TimePlannerTask> tasks = [];
//   bool? isAnimated = true;
//
//   /// Initialize the controller
//   final TimePlannerController controller = Get.put(TimePlannerController());
//
//   /// check input value rules
//   void _checkInputValue() {
//     if (widget.startHour > widget.endHour) {
//       throw FlutterError("Start hour should be lower than end hour");
//     } else if (widget.startHour < 0) {
//       throw FlutterError("Start hour should be larger than 0");
//     } else if (widget.endHour > 23) {
//       throw FlutterError("End hour should be lower than 23");
//     } else if (widget.headers.isEmpty) {
//       throw FlutterError("Header can't be empty");
//     }
//   }
//
//   /// create local style
//   void _convertToLocalStyle() {
//     style.backgroundColor = widget.style?.backgroundColor;
//     style.cellHeight = widget.style?.cellHeight ?? 80;
//     style.cellWidth = widget.style?.cellWidth ?? 90;
//     style.horizontalTaskPadding = widget.style?.horizontalTaskPadding ?? 0;
//     style.borderRadius = widget.style?.borderRadius ??
//         const BorderRadius.all(Radius.circular(8.0));
//     style.dividerColor = widget.style?.dividerColor;
//     style.showScrollBar = widget.style?.showScrollBar ?? false;
//     style.interstitialOddColor = widget.style?.interstitialOddColor;
//     style.interstitialEvenColor = widget.style?.interstitialEvenColor;
//   }
//
//   /// store input data to static values
//   void _initData() {
//     _checkInputValue();
//     _convertToLocalStyle();
//     config.horizontalTaskPadding = style.horizontalTaskPadding;
//     config.cellHeight = style.cellHeight;
//     config.cellWidth = style.cellWidth;
//     config.totalHours = (widget.endHour - widget.startHour).toDouble();
//     config.totalDays = widget.headers.length;
//     config.startHour = widget.startHour;
//     config.use24HourFormat = widget.use24HourFormat;
//     config.setTimeOnAxis = widget.setTimeOnAxis;
//     config.borderRadius = style.borderRadius;
//     isAnimated = widget.currentTimeAnimation;
//     tasks = widget.tasks ?? [];
//   }
//
//   @override
//   void initState() {
//     _initData();
//     super.initState();
//     controller.updateTime(); // Update the current time
//     Future.delayed(Duration.zero).then((_) {
//       int hour = DateTime.now().hour;
//       if (isAnimated != null && isAnimated == true) {
//         if (hour > widget.startHour) {
//           double scrollOffset =
//               (hour - widget.startHour) * config.cellHeight!.toDouble();
//           mainVerticalController.animateTo(
//             scrollOffset,
//             duration: const Duration(milliseconds: 800),
//             curve: Curves.easeOutCirc,
//           );
//           timeVerticalController.animateTo(
//             scrollOffset,
//             duration: const Duration(milliseconds: 800),
//             curve: Curves.easeOutCirc,
//           );
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     mainHorizontalController.dispose();
//     mainVerticalController.dispose();
//     dayHorizontalController.dispose();
//     timeVerticalController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // we need to update the tasks list in case the tasks have changed
//     tasks = widget.tasks ?? [];
//     mainHorizontalController.addListener(() {
//       dayHorizontalController.jumpTo(mainHorizontalController.offset);
//     });
//     mainVerticalController.addListener(() {
//       timeVerticalController.jumpTo(mainVerticalController.offset);
//     });
//
//     return Container(
//       color: style.backgroundColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           LayoutBuilder(
//             builder: (context, constraints) {
//               final screenWidth = constraints.maxWidth;
//               final adjustedScreenWidth = screenWidth - 68;
//               final calculatedWidth = adjustedScreenWidth / config.totalDays;
//
//               return SingleChildScrollView(
//                 controller: dayHorizontalController,
//                 scrollDirection: Axis.horizontal,
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     const SizedBox(
//                       width: 68,
//                       child: Center(
//                         child: FittedBox(
//                           child: Text(
//                             ' الساعه / اليوم ',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     for (int i = 0; i < config.totalDays; i++)
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border(
//                             right: BorderSide(
//                               color: style.dividerColor!.withOpacity(0.9),
//                               width: 1.2,
//                             ),
//                           ),
//                         ),
//                         width: calculatedWidth,
//                         child: widget.headers[i],
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           Container(
//             height: 1,
//             color: style.dividerColor ?? Theme.of(context).primaryColor,
//           ),
//           Expanded(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 ScrollConfiguration(
//                   behavior: ScrollConfiguration.of(context)
//                       .copyWith(scrollbars: false),
//                   child: SingleChildScrollView(
//                     physics: const NeverScrollableScrollPhysics(),
//                     controller: timeVerticalController,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             for (int i = widget.startHour;
//                                 i <= widget.endHour;
//                                 i++)
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: !config.use24HourFormat ? 4 : 0,
//                                 ),
//                                 child: Obx(() => TimePlannerTime(
//                                       time: formattedTime(i),
//
//                                       setTimeOnAxis: config.setTimeOnAxis,
//                                       textColor:
//                                           controller.currentHour.value == i
//                                               ? Colors.blue
//                                               : Colors.white,
//                                       textStar:
//                                           controller.currentHour.value == i
//                                               ? '*'
//                                               : '',
//                                     )),
//                               ),
//                           ],
//                         ),
//                         Container(
//                           height: (config.totalHours * config.cellHeight!) + 80,
//                           width: 1,
//                           color: style.dividerColor ??
//                               Theme.of(context).primaryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: buildMainBody(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildMainBody({bool alignToEnd = true}) {
//     final crossAxisAlignment =
//         alignToEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
//     final mainAxisAlignment =
//         alignToEnd ? MainAxisAlignment.end : MainAxisAlignment.start;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final screenWidth = constraints.maxWidth;
//         final calculatedWidth = screenWidth / config.totalDays;
//
//         if (style.showScrollBar!) {
//           return Scrollbar(
//             controller: mainVerticalController,
//             thumbVisibility: true,
//             child: SingleChildScrollView(
//               controller: mainVerticalController,
//               child: Scrollbar(
//                 controller: mainHorizontalController,
//                 thumbVisibility: true,
//                 child: SingleChildScrollView(
//                   controller: mainHorizontalController,
//                   scrollDirection: Axis.horizontal,
//                   child: Column(
//                     crossAxisAlignment: crossAxisAlignment,
//                     mainAxisAlignment: mainAxisAlignment,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Row(
//                         crossAxisAlignment: crossAxisAlignment,
//                         mainAxisAlignment: mainAxisAlignment,
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           SizedBox(
//                             height:
//                                 (config.totalHours * config.cellHeight!) + 80,
//                             width: screenWidth,
//                             child: Stack(
//                               children: <Widget>[
//                                 Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     for (var i = 0; i < config.totalHours; i++)
//                                       Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: <Widget>[
//                                           Container(
//                                             color: i.isOdd
//                                                 ? style.interstitialOddColor
//                                                 : style.interstitialEvenColor,
//                                             height: (config.cellHeight! - 1)
//                                                 .toDouble(),
//                                           ),
//                                           const Divider(
//                                             height: 1,
//                                           ),
//                                         ],
//                                       )
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     for (var i = 0; i < config.totalDays; i++)
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: <Widget>[
//                                           SizedBox(
//                                             width: (calculatedWidth - 1)
//                                                 .toDouble(),
//                                           ),
//                                           Container(
//                                             width: 1,
//                                             height: (config.totalHours *
//                                                     config.cellHeight!) +
//                                                 config.cellHeight!,
//                                             color: Colors.black12,
//                                           )
//                                         ],
//                                       )
//                                   ],
//                                 ),
//                                 for (int i = 0; i < tasks.length; i++) tasks[i],
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//         return SingleChildScrollView(
//           controller: mainVerticalController,
//           child: SingleChildScrollView(
//             controller: mainHorizontalController,
//             scrollDirection: Axis.horizontal,
//             child: Column(
//               crossAxisAlignment: crossAxisAlignment,
//               mainAxisAlignment: mainAxisAlignment,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: crossAxisAlignment,
//                   mainAxisAlignment: mainAxisAlignment,
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     SizedBox(
//                       height: (config.totalHours * config.cellHeight!) + 80,
//                       width: screenWidth,
//                       child: Stack(
//                         children: <Widget>[
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               for (var i = 0; i < config.totalHours; i++)
//                                 Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     SizedBox(
//                                       height:
//                                           (config.cellHeight! - 1).toDouble(),
//                                     ),
//                                     const Divider(
//                                       height: 1,
//                                     ),
//                                   ],
//                                 )
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               for (var i = 0; i < config.totalDays; i++)
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     SizedBox(
//                                       width: (calculatedWidth - 1).toDouble(),
//                                     ),
//                                     Container(
//                                       width: 1,
//                                       height: (config.totalHours *
//                                               config.cellHeight!) +
//                                           config.cellHeight!,
//                                       color: Colors.black12,
//                                     )
//                                   ],
//                                 )
//                             ],
//                           ),
//                           for (int i = 0; i < tasks.length; i++) tasks[i],
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   String formattedTime(int hour) {
//     /// this method formats the input hour into a time string
//     /// modifing it as necessary based on the use24HourFormat flag .
//     if (config.use24HourFormat) {
//       // we use the hour as-is
//       return hour.toString() + ':00';
//     } else {
//       // we format the time to use the am/pm scheme
//       if (hour == 0) return "12:00 am";
//       if (hour < 12) return "$hour:00 am";
//       if (hour == 12) return "12:00 pm";
//       return "${hour - 12}:00 pm";
//     }
//   }
// }

//---------------

/*class _TimePlannerState extends State<TimePlanner> {
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  TimePlannerStyle style = TimePlannerStyle();
  List<TimePlannerTask> tasks = [];
  bool? isAnimated = true;

  /// Initialize the controller
  final TimePlannerController controller = Get.put(TimePlannerController());

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
          mainVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
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
    mainHorizontalController.dispose();
    mainVerticalController.dispose();
    dayHorizontalController.dispose();
    timeVerticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // we need to update the tasks list in case the tasks have changed
    tasks = widget.tasks ?? [];
    mainHorizontalController.addListener(() {
      dayHorizontalController.jumpTo(mainHorizontalController.offset);
    });
    mainVerticalController.addListener(() {
      timeVerticalController.jumpTo(mainVerticalController.offset);
    });

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
              final adjustedScreenWidth = screenWidth - 68;
              final calculatedWidth = adjustedScreenWidth /
                  (widget.viewCurrentDayOnly ? 1 : config.totalDays);

              return SingleChildScrollView(
                controller: dayHorizontalController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      width: 68,
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
                ),
              );
            },
          ),
          Container(
            height: 1,
            color: style.dividerColor ?? Theme.of(context).primaryColor,
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: timeVerticalController,
                    child: Row(
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
                                    textColor:
                                        controller.currentHour.value == i
                                            ? Colors.blue
                                            : Colors.white,
                                    textStar:
                                        controller.currentHour.value == i
                                            ? '*'
                                            : '',
                                  )),
                          ],
                        ),
                        Container(
                          height: (config.totalHours * config.cellHeight!) + 80,
                          width: 1,
                          color: style.dividerColor ??
                              Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: buildMainBody(),
                ),
              ],
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

        return SingleChildScrollView(
          controller: mainVerticalController,
          child: SingleChildScrollView(
            controller: mainHorizontalController,
            scrollDirection: Axis.horizontal,
            child: Column(
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
                      height: (config.totalHours * config.cellHeight!) + 80,
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
                                      height:
                                          (config.cellHeight! - 1).toDouble(),
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
                                        // color: Colors.black12,
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
            ),
          ),
        );
      },
    );
  }

  String formattedTime(int hour) {
    /// this method formats the input hour into a time string
    /// modifing it as necessary based on the use24HourFormat flag .
    if (config.use24HourFormat) {
      // we use the hour as-is
      return hour.toString() + ':00';
    } else {
      // we format the time to use the am/pm scheme
      if (hour == 0) return "12:00 am";
      if (hour < 12) return "$hour:00 am";
      if (hour == 12) return "12:00 pm";
      return "${hour - 12}:00 pm";
    }
  }
}
* */

/// TimePlannerController with GetX
class TimePlannerController extends GetxController {
  var currentHour = DateTime.now().hour.obs;
  var dividerColor = Colors.white.obs;
  RxInt currentDay = 0.obs;

  final weeklyCalendarController = Get.find<WeeklyCalendarController>();

  /// Timer to update the time every minute
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    updateTime();
    currentDay.value = 6 - weeklyCalendarController.currentDay.value;
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateTime();
    });
  }

  void updateTime() {
    int hour = DateTime.now().hour;
    currentHour.value = hour;
    if (hour == 0) {
      weeklyCalendarController.getCurrentDay();
    }
    // print('current hour: $hour');
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}

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
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  TimePlannerStyle style = TimePlannerStyle();
  List<TimePlannerTask> tasks = [];
  bool? isAnimated = true;

  /// Initialize the controller
  final TimePlannerController controller = Get.put(TimePlannerController());

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
          mainVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
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
    mainHorizontalController.dispose();
    mainVerticalController.dispose();
    dayHorizontalController.dispose();
    timeVerticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // we need to update the tasks list in case the tasks have changed
    tasks = widget.tasks ?? [];
    mainHorizontalController.addListener(() {
      dayHorizontalController.jumpTo(mainHorizontalController.offset);
    });
    mainVerticalController.addListener(() {
      timeVerticalController.jumpTo(mainVerticalController.offset);
    });

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
              final adjustedScreenWidth = screenWidth - 68;
              final calculatedWidth = adjustedScreenWidth /
                  (widget.viewCurrentDayOnly ? 1 : config.totalDays);

              return SingleChildScrollView(
                controller: dayHorizontalController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      width: 68,
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
                ),
              );
            },
          ),
          Container(
            height: 1,
            color: style.dividerColor ?? Theme.of(context).primaryColor,
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: timeVerticalController,
                    child: Row(
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
                                    textColor:
                                        controller.currentHour.value == i
                                            ? Colors.blue
                                            : Colors.white,
                                    textStar:
                                        controller.currentHour.value == i
                                            ? '*'
                                            : '',
                                  )),
                          ],
                        ),
                        Container(
                          height: (config.totalHours * config.cellHeight!) + 80,
                          width: 1,
                          color: style.dividerColor ??
                              Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: buildMainBody(),
                ),
              ],
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

        return SingleChildScrollView(
          controller: mainVerticalController,
          child: SingleChildScrollView(
            controller: mainHorizontalController,
            scrollDirection: Axis.horizontal,
            child: Column(
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
                      height: (config.totalHours * config.cellHeight!) + 80,
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
                                      height:
                                          (config.cellHeight! - 1).toDouble(),
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
                                        // color: Colors.black12,
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
            ),
          ),
        );
      },
    );
  }

  String formattedTime(int hour) {
    /// this method formats the input hour into a time string
    /// modifing it as necessary based on the use24HourFormat flag .
    if (config.use24HourFormat) {
      // we use the hour as-is
      return hour.toString() + ':00';
    } else {
      // we format the time to use the am/pm scheme
      if (hour == 0) return "12:00 am";
      if (hour < 12) return "$hour:00 am";
      if (hour == 12) return "12:00 pm";
      return "${hour - 12}:00 pm";
    }
  }
}
