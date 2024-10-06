import 'package:get/get.dart';
import 'package:second_brain/features/side_menu/controller/side_menu_controller.dart';

import '../../weekly_calendar/controllers/weekly_calendar_controller.dart';

class SideMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SideMenuController>(() => SideMenuController());
    Get.lazyPut<WeeklyCalendarController>(() => WeeklyCalendarController());
  }
}
