import 'package:second_brain/features/weekly_calendar/controllers/icon_selector.dart';
import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import 'package:second_brain/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskForm extends StatelessWidget {
  AddTaskForm({
    super.key,
  });
  final controller = Get.put(WeeklyCalendarController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                height: 50,
              ),
              Positioned(
                right: 1,
                top: 1,
                child: IconButton(
                  onPressed: () {
                    controller.showAddTask.value = false;
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                child: SizedBox(
                  child: Obx(
                    () => Text(
                        controller.showUpdateTask.value
                            ? 'تعديل علي  مهمة'
                            : 'اضافة مهمة جديدة',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: KSizes.spaceBtwItems),
                Obx(() {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.showUpdateTask.value) {
                            controller.UpdateTask(
                              index: controller.taskUpdateIndex.value,
                              title: controller.taskNameController.value.text,
                              hour: controller.selectedStartTime.value.hour,
                              minutes:
                                  controller.selectedStartTime.value.minute,
                              // dayIndex: controller.dayIndex.value,
                              duration: controller.duration.value.toInt(),
                              // daysDuration: controller.daysDuration.value,
                              icon:
                                  controller.colorController.selectedIcon.value,
                              color: controller
                                  .colorController.selectedColor.value,             context: context,
                            );
                          } else {
                            controller.addTask(
                              title: controller.taskNameController.value.text,
                              hour: controller.selectedStartTime.value.hour,
                              minutes:
                                  controller.selectedStartTime.value.minute,
                              // dayIndex: controller.dayIndex.value,
                              duration: controller.duration.value.toInt(),
                              // daysDuration: controller.daysDuration.value,
                              icon:
                                  controller.colorController.selectedIcon.value,
                              color: controller
                                  .colorController.selectedColor.value,
                              context: context,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(
                                controller.colorController.selectedColor.value),
                          ),
                          child: Center(
                            child: Text(
                              controller.showUpdateTask.value
                                  ? 'تعديل'
                                  : 'اضافة',
                              style: Theme.of(context).textTheme.titleMedium!,
                            ),
                          ),
                        ),
                      ),
                      (controller.showUpdateTask.value)
                          ? const SizedBox(height: KSizes.spaceBtwItems)
                          : const SizedBox(),
                      (controller.showUpdateTask.value)
                          ? InkWell(
                              onTap: () {
                                controller.resetFormFields();
                                controller.showUpdateTask.value = false;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    'الغاء',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                }),
                const SizedBox(height: KSizes.spaceBtwItems),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.taskNameController.value,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        validator: (value) =>
                            KValidator.validateEmptyText('اسم المهمة', value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'اسم المهمة',
                        ),
                      ),
                      // const SizedBox(height: KSizes.spaceBtwInputFields),
                      // TextFormField(
                      //   controller: controller.TaskDescriptionController.value,
                      //   maxLines: 4,
                      //   keyboardType: TextInputType.text,
                      //   validator: (value) =>
                      //       KValidator.validateEmptyText('وصف التاسك', value),
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   decoration: const InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'وصف المهمة',
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: KColors.darkModeSubCard,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.only(top: KSizes.md),
                  child: Column(
                    children: [
                      const SizedBox(height: KSizes.spaceBtwInputFields),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ميعاد المهمة',
                                style:
                                    Theme.of(context).textTheme.headlineSmall!),
                          ],
                        ),
                      ),
                      const SizedBox(height: KSizes.sm),
                      const HourSelectionWidget(),
                      const SizedBox(
                        height: KSizes.sm,
                      ),
                      const DurationPicker(),
                      const SizedBox(
                        height: KSizes.sm,
                      ),
                      // const KDivider(),
                      const WorkingDaysWidget(),
                      const SizedBox(height: KSizes.spaceBtwInputFields),
                      // const KDivider(),
                    ],
                  ),
                ),
                const SizedBox(height: KSizes.spaceBtwInputFields),
                IconSelector(),
                const SizedBox(height: KSizes.spaceBtwInputFields),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkingDaysWidget extends StatelessWidget {
  const WorkingDaysWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeeklyCalendarController());
    return Wrap(
      spacing: KSizes.sm,
      runSpacing: KSizes.sm,
      children: List.generate(controller.daysOfWeek.length, (index) {
        return Obx(
          () => InkWell(
            onTap: () {
              controller.toggleDay(index);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: controller.selectedDays[index]
                    ? Color(controller.colorController.selectedColor.value)
                    : KColors.darkContainer,
              ),
              width: 78,
              height: 50,
              child: Center(child: Text(controller.daysOfWeek[index])),
            ),
          ),
        );
      }),
    );
  }
}

class HourSelectionWidget extends StatelessWidget {
  const HourSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeeklyCalendarController());
    return Padding(
      padding: const EdgeInsets.all(KSizes.sm),
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' من ',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => controller.selectTime(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        Color(controller.colorController.selectedColor.value),
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        ' ${controller.selectedStartTime.value.format(context)} ',
                        // 'الوقت:  ${controller.selectedTime.value.format(context)} ',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------
class DurationPicker extends StatelessWidget {
  const DurationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final WeeklyCalendarController controller =
        Get.put(WeeklyCalendarController());
    return Padding(
      padding: const EdgeInsets.only(right: KSizes.sm),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: KSizes.sm),
            child: Text(
              'لمدة',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
          Expanded(
              flex: 2,
              child: Obx(
                () => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color:
                        Color(controller.colorController.selectedColor.value),
                  ),
                  child: Center(
                    child: Text(
                      '${(controller.duration.value ~/ 60).toString().padLeft(1, '0')}h ${(controller.duration.value % 60 ~/ 1).toString().padLeft(2, '0')}m',
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                  ),
                ),
              )),
          Expanded(
            flex: 4,
            child: Obx(() => Slider(
                  value: controller.duration.value,
                  activeColor:
                      Color(controller.colorController.selectedColor.value),
                  inactiveColor: Colors.white,
                  min: 15,
                  max: 10 * 60,
                  divisions: (10 * 60 - 15) ~/ 15,
                  label:
                      '${(controller.duration.value ~/ 60).toString().padLeft(1, '0')}h ${(controller.duration.value % 60 ~/ 1).toString().padLeft(2, '0')}m',
                  onChanged: (double value) {
                    controller.duration.value = value;
                  },
                )),
          ),
        ],
      ),
    );
  }
}
