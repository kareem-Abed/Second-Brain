import 'package:al_maafer/features/weekly_calendar/controllers/Icon_selector.dart';
import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/utils/constants/colors.dart';
import 'package:al_maafer/utils/constants/sizes.dart';
import 'package:al_maafer/utils/validators/validation.dart';
import 'package:al_maafer/day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddGroupForm extends StatelessWidget {
  AddGroupForm({
    super.key,
  });
  final controller = Get.put(WeeklyCalendarController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[950],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Obx(
                () => Text(
                    controller.showUpdateTask.value
                        ? 'تعديل علي  مهمة'
                        : 'اضافة مهمة جديدة',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: KSizes.spaceBtwItems),
              Obx(() {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (controller.showUpdateTask.value) {
                          controller.UpdateTask(
                            index: controller.taskUpdateIndex.value,
                            title: controller.TaskNameController.value.text,
                            hour: controller.selectedStartTime.value.hour,
                            minutes: controller.selectedStartTime.value.minute,
                            // dayIndex: controller.dayIndex.value,
                            duration: controller.duration.value,
                            // daysDuration: controller.daysDuration.value,
                            icon: controller.colorController.selectedIcon.value,
                            color:
                                controller.colorController.selectedColor.value,
                          );
                        } else
                          controller.addTask(
                            title: controller.TaskNameController.value.text,
                            hour: controller.selectedStartTime.value.hour,
                            minutes: controller.selectedStartTime.value.minute,
                            // dayIndex: controller.dayIndex.value,
                            duration: controller.duration.value,
                            // daysDuration: controller.daysDuration.value,
                            icon: controller.colorController.selectedIcon.value,
                            color:
                                controller.colorController.selectedColor.value,
                          );
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
                            controller.showUpdateTask.value ? 'تعديل' : 'اضافة',
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                        ),
                      ),
                    ),
                    (controller.showUpdateTask.value)
                        ? const SizedBox(height: KSizes.spaceBtwItems)
                        : SizedBox(),
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium!,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                );
              }),
              const SizedBox(height: KSizes.spaceBtwItems),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.TaskNameController.value,
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
                  color: Colors.grey[850],
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
                    HourSelectionWidget(),
                    const SizedBox(
                      height: KSizes.sm,
                    ),
                    // const KDivider(),
                    WorkingDaysWidget(),
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
      ),
    );
  }
}

class WorkingDaysWidget extends StatelessWidget {
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
              width: 80,
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
  final controller = Get.put(WeeklyCalendarController());

  @override
  Widget build(BuildContext context) {
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
                onTap: () => controller.selectTime(context, true),
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
            Text(
              'الي',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () => controller.selectTime(context, false),
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
                        ' ${controller.selectedEndTime.value.format(context)} ',
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
