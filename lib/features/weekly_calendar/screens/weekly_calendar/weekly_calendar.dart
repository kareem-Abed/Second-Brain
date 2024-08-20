import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_add_update.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_planner.dart';
import 'package:al_maafer/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WeeklyCalendarScreen extends StatelessWidget {
  const WeeklyCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WeeklyCalendarController controller =
        Get.put(WeeklyCalendarController());

    return Scaffold(
      backgroundColor: KColors.dark,
      body: Row(
        children: [
          Obx(() {
            if (controller.showAddTask.value) {
              return Row(
                children: [
                  Container(
                    width: 310,
                    child: AddGroupForm(
                      isEdit: false,
                      groupId: 'asd',
                    ),
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
      floatingActionButton:Obx(
              () {
          return FloatingActionButton(
            backgroundColor:controller.showAddTask.value ?Colors.red: Colors.blue,
            onPressed: () {
              controller.showAddTask.value = !controller.showAddTask.value;
            },
            child:
                 Icon( controller.showAddTask.value ?FontAwesomeIcons.xmark:FontAwesomeIcons.plus),
          );
        }
      ),
    );
  }
}
