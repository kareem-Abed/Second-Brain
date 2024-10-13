import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/utils/constants/colors.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../weekly_calendar/controllers/weekly_calendar_controller.dart';
import '../../controller/side_menu_controller.dart';

class HeaderButtons extends StatelessWidget {
  const HeaderButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeeklyCalendarController>();
    final sideMenuController = Get.find<SideMenuController>();

    return Obx(() {
      return sideMenuController.selectedIndex.value == 1|| sideMenuController.selectedIndex.value == 2
          ? Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        backgroundColor: KColors.darkModeCard,
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
                          },
                          child: const Text('نعم'),
                        ),
                        cancel: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('إلغاء'),
                        ),
                      );
                    },
                    icon: const Icon(IconsaxPlusBroken.trash,
                        color: Colors.red, size: 30)),
                const SizedBox(width: KSizes.spaceBtwItems),
                IconButton(
                  onPressed: () {
                    controller.showAddTask.value =
                        !controller.showAddTask.value;
                    controller.showUpdateTask.value = false;
                  },
                  icon: Obx(() {
                    return Icon(
                      controller.showAddTask.value
                          ? IconsaxPlusBroken.close_square
                          : IconsaxPlusBroken.add_square,
                      color: controller.showAddTask.value
                          ? Colors.red
                          : Colors.blue,
                      size: 30,
                    );
                  }),
                ),
              ],
            )
          : const SizedBox();
    });
  }
}
