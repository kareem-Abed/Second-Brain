import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_add_update.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_planner.dart';
import 'package:al_maafer/utils/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WeeklyCalendarScreen extends StatelessWidget {
  const WeeklyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeeklyCalendarController controller =
        Get.put(WeeklyCalendarController());
    final _key = GlobalKey<ExpandableFabState>();

    return Scaffold(
      backgroundColor: KColors.dark,
      body: Row(
        children: [
          Obx(() {
            if (controller.showAddTask.value) {
              return Row(
                children: [
                  Container(
                    width: 350,
                    child: AddGroupForm(),
                  ),
                  Container(
                    width: 2,
                    color: KColors.darkerGrey,
                  )
                ],
              );
            } else {
              return Container();
            }
          }),
          Expanded(flex: 2, child: WeeklyCalendarPlanner()),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.fan,
        pos: ExpandableFabPos.left,
        distance: 78,
        fanAngle: 90,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(FontAwesomeIcons.bars),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(FontAwesomeIcons.xmark),
          fabSize: ExpandableFabSize.small,
          foregroundColor: Colors.white,
          backgroundColor: Colors.redAccent,
          shape: const CircleBorder(),
        ),
        key: _key,
        initialOpen: false,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: () {
              Get.defaultDialog(
                title: 'تأكيد الحذف',
                content: Text(
                  'هل أنت متأكد أنك تريد حذف جميع المهام؟',
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                confirm: ElevatedButton(
                  onPressed: () {
                    controller.clearAllTasks();

                    Get.back();
                    final state = _key.currentState;
                    if (state != null) {
                      state.toggle();
                    }
                  },
                  child: Text('نعم'),
                ),
                cancel: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('إلغاء'),
                ),
              );
            },
            child: const Icon(FontAwesomeIcons.trash),
          ),
          // FloatingActionButton(
          //   child: const Icon(Icons.edit),
          //   onPressed: () {
          //     final state = _key.currentState;
          //     if (state != null) {
          //       state.toggle();
          //     }
          //   },
          // ),
          Obx(() {
            return FloatingActionButton(
              backgroundColor:
                  controller.showAddTask.value ? Colors.red : Colors.blue,
              onPressed: () {
                controller.showAddTask.value = !controller.showAddTask.value;
                controller.showUpdateTask.value = false;
              },
              child: Icon(controller.showAddTask.value
                  ? FontAwesomeIcons.xmark
                  : FontAwesomeIcons.plus),
            );
          }),
        ],
      ),
    );
  }
}
