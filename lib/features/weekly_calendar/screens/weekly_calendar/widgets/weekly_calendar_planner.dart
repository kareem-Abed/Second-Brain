// import 'package:al_maafer/common/widgets/loaders/animation_loader.dart';
import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/time_planer/time_planner.dart';
import 'package:al_maafer/utils/constants/colors.dart';
import 'package:al_maafer/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:time_planner/time_planner.dart';

class WeeklyCalendarPlanner extends StatelessWidget {
  const WeeklyCalendarPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeeklyCalendarController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final newCellWidth = (constraints.maxWidth / 7).toDouble();
        controller.updateCellWidth(newCellWidth);

        return Obx(() {
          return TimePlanner(
            startHour: 1,
            endHour: 23,
            use24HourFormat: false,
            setTimeOnAxis: false,
            style: TimePlannerStyle(
              backgroundColor: Colors.grey[900],
              // cellWidth: controller.cellWidth.value,
              cellHeight: 100,
              showScrollBar: true,
              dividerColor: Colors.blue,
              // horizontalTaskPadding: 1.0,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              interstitialEvenColor: Colors.grey[850],
              interstitialOddColor: Colors.grey[800],
            ),
            headers: [
              TimePlannerTitle(
                title: 'السبت',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[0] == '*'
                        ? Colors.blue
                        : Colors.white),
                date: controller.daysOfWeekStare[0],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blue),
              ),
              TimePlannerTitle(
                title: 'الأحد',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[1] == '*'
                        ? Colors.blue
                        : Colors.white),
                date: controller.daysOfWeekStare[1],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blue),
              ),
              TimePlannerTitle(
                title: 'الاثنين',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[2] == '*'
                        ? Colors.blue
                        : Colors.white),
                date: controller.daysOfWeekStare[2],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blue),
              ),
              TimePlannerTitle(
                title: 'الثلاثاء',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[3] == '*'
                        ? Colors.blue
                        : Colors.white),
                date: controller.daysOfWeekStare[3],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blue),
              ),
              TimePlannerTitle(
                title: 'الأربعاء',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[4] == '*'
                        ? Colors.blue
                        : Colors.white),
                date: controller.daysOfWeekStare[4],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blue),
              ),
              TimePlannerTitle(
                title: 'الخميس',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[5] == '*'
                        ? Colors.blue
                        : Colors.white),
                date: controller.daysOfWeekStare[5],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blue),
              ),
              TimePlannerTitle(
                title: 'الجمعة',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[6] == '*'
                        ? Colors.blue
                        : Colors.white),
                date: controller.daysOfWeekStare[6],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.blue),
              ),
            ],
            tasks: controller.tasks.value,
          );
        });
      },
    );
  }
}

class WeeklyCalendarPlanner2 extends StatelessWidget {
  const WeeklyCalendarPlanner2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeeklyCalendarController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final newCellWidth = (constraints.maxWidth / 7).toDouble();
        controller.updateCellWidth(newCellWidth);

        return Obx(() {
          return TimePlanner(
            startHour: 6,
            endHour: 23,
            use24HourFormat: false,
            setTimeOnAxis: false,
            style: TimePlannerStyle(
              backgroundColor: KColors.dark,
              cellWidth: controller.cellWidth.value,
              cellHeight: 100,
              showScrollBar: true,
              dividerColor: KColors.primary,
              horizontalTaskPadding: 3.0,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              interstitialEvenColor: Colors.grey[850],
              interstitialOddColor: Colors.grey[800],
            ),
            headers: [
              TimePlannerTitle(
                title: 'السبت',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[0] == '*'
                        ? KColors.primary
                        : KColors.white),
                date: controller.daysOfWeekStare[0],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: KColors.primary),
              ),
              TimePlannerTitle(
                title: 'الأحد',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[1] == '*'
                        ? KColors.primary
                        : KColors.white),
                date: controller.daysOfWeekStare[1],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: KColors.primary),
              ),
              TimePlannerTitle(
                title: 'الاثنين',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[2] == '*'
                        ? KColors.primary
                        : KColors.white),
                date: controller.daysOfWeekStare[2],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: KColors.primary),
              ),
              TimePlannerTitle(
                title: 'الثلاثاء',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[3] == '*'
                        ? KColors.primary
                        : KColors.white),
                date: controller.daysOfWeekStare[3],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: KColors.primary),
              ),
              TimePlannerTitle(
                title: 'الأربعاء',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[4] == '*'
                        ? KColors.primary
                        : KColors.white),
                date: controller.daysOfWeekStare[4],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: KColors.primary),
              ),
              TimePlannerTitle(
                title: 'الخميس',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[5] == '*'
                        ? KColors.primary
                        : KColors.white),
                date: controller.daysOfWeekStare[5],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: KColors.primary),
              ),
              TimePlannerTitle(
                title: 'الجمعة',
                titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: controller.daysOfWeekStare[6] == '*'
                        ? KColors.primary
                        : KColors.white),
                date: controller.daysOfWeekStare[6],
                dateStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: KColors.primary),
              ),
            ],
            // ignore: invalid_use_of_protected_member
            tasks: controller.tasks.value,
          );
        });
      },
    );
  }
}

//
// class WeeklyCalendarPlanner extends StatelessWidget {
//   const WeeklyCalendarPlanner({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(WeeklyCalendarController());
//     return Expanded(
//       child: Obx(() {
//         return TimePlanner(
//           startHour: 6,
//           endHour: 23,
//           use24HourFormat: false,
//            setTimeOnAxis: false,
//           style: TimePlannerStyle(
//             backgroundColor: KColors.dark,
//             cellWidth: (KHelperFunctions.screenWidth() /7).toInt(),
//              cellHeight: 100,
//             showScrollBar: true,
//
//             dividerColor: KColors.primary,
//             horizontalTaskPadding: 3,
//
//             borderRadius: const BorderRadius.all(Radius.circular(8)),
//             interstitialEvenColor: Colors.grey[850],
//             interstitialOddColor: Colors.grey[800],
//           ),
//           headers: [
//             TimePlannerTitle(
//               title: 'السبت',
//               titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: controller.daysOfWeekStare[0] == '*'
//                       ? KColors.primary
//                       : KColors.white),
//               date: controller.daysOfWeekStare[0],
//               dateStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(color: KColors.primary),
//             ),
//             TimePlannerTitle(
//               title: 'الأحد',
//               titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: controller.daysOfWeekStare[1] == '*'
//                       ? KColors.primary
//                       : KColors.white),
//               date: controller.daysOfWeekStare[1],
//               dateStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(color: KColors.primary),
//             ),
//             TimePlannerTitle(
//               title: 'الاثنين',
//               titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: controller.daysOfWeekStare[2] == '*'
//                       ? KColors.primary
//                       : KColors.white),
//               date: controller.daysOfWeekStare[2],
//               dateStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(color: KColors.primary),
//             ),
//             TimePlannerTitle(
//               title: 'الثلاثاء',
//               titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: controller.daysOfWeekStare[3] == '*'
//                       ? KColors.primary
//                       : KColors.white),
//               date: controller.daysOfWeekStare[3],
//               dateStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(color: KColors.primary),
//             ),
//             TimePlannerTitle(
//               title: 'الأربعاء',
//               titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: controller.daysOfWeekStare[4] == '*'
//                       ? KColors.primary
//                       : KColors.white),
//               date: controller.daysOfWeekStare[4],
//               dateStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(color: KColors.primary),
//             ),
//             TimePlannerTitle(
//               title: 'الخميس',
//               titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: controller.daysOfWeekStare[5] == '*'
//                       ? KColors.primary
//                       : KColors.white),
//               date: controller.daysOfWeekStare[5],
//               dateStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(color: KColors.primary),
//             ),
//             TimePlannerTitle(
//               title: 'الجمعة',
//               titleStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   color: controller.daysOfWeekStare[6] == '*'
//                       ? KColors.primary
//                       : KColors.white),
//               date: controller.daysOfWeekStare[6],
//               dateStyle: Theme.of(context)
//                   .textTheme
//                   .titleLarge!
//                   .copyWith(color: KColors.primary),
//             ),
//           ],
//           // ignore: invalid_use_of_protected_member
//           tasks: controller.tasks.value,
//         );
//       }),
//     );
//   }
// }
