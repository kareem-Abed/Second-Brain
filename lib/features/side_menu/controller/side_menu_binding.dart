import 'package:get/get.dart';
import 'package:questly/features/side_menu/controller/side_menu_controller.dart';
import 'package:questly/features/pomodoro/controller/pomodoro_controller.dart';

class SideMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SideMenuController>(() => SideMenuController());
    Get.put<PomodoroController>(PomodoroController());

  }
}
