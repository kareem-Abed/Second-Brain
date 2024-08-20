import 'package:al_maafer/features/goups/controllers/groups_controller.dart';
import 'package:al_maafer/features/weekly_calendar/controllers/Icon_selector.dart';
import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/utils/constants/colors.dart';
import 'package:al_maafer/utils/constants/sizes.dart';
import 'package:al_maafer/utils/validators/validation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class AddGroupForm extends StatelessWidget {
  AddGroupForm({super.key, required this.isEdit, required this.groupId});
  final controller = Get.put(WeeklyCalendarController());
  final bool isEdit;
  final String? groupId;
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
              Text(isEdit == true ? 'تعديل علي  مهمة' : 'اضافة مهمة جديدة',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: KSizes.spaceBtwItems),
              Obx(
                () => InkWell(
                  // onTap: () => controller.selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Color(controller.colorController.selectedColor.value),
                    ),
                    child: Center(
                      child: Text(
                        isEdit == true ? 'تعديل' : 'اضافة',
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: KSizes.spaceBtwItems),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      // controller: controller.groupNameController.value,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          KValidator.validateEmptyText('اسم التاسك', value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'اسم التاسك',
                      ),
                    ),
                    const SizedBox(height: KSizes.spaceBtwInputFields),
                    TextFormField(
                      // controller: controller.groupNameController.value,
                      maxLines: 4,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          KValidator.validateEmptyText('وصف التاسك', value),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'اسم التاسك',
                      ),
                    ),

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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('ميعاد المهمة',
                            style: Theme.of(context).textTheme.headlineSmall!),
                        HourSelectionWidget(),
                      ],
                    ),
                    // const Text('ميعاد التاسك',
                    //     style: TextStyle(
                    //         fontSize: 24, fontWeight: FontWeight.bold)),
                    // const SizedBox(height: KSizes.spaceBtwInputFields),
                    // const SizedBox(height: KSizes.spaceBtwInputFields),
                    // HourSelectionWidget(),
                    const SizedBox(
                      height: KSizes.spaceBtwInputFields,
                    ),
                    // const KDivider(),
                    WorkingDaysWidget(),
                    const SizedBox(height: KSizes.spaceBtwInputFields),
                    // const KDivider(),
                  ],
                ),
              ),
              // const SizedBox(height: KSizes.spaceBtwInputFields),

              // ColorSelector(),
              const SizedBox(height: KSizes.spaceBtwInputFields),
              IconSelector(),
              const SizedBox(height: KSizes.spaceBtwInputFields),
              // SizedBox(
              //   width: double.maxFinite,
              //   child: ElevatedButton(
              //     child: Text(isEdit == true ? 'تعديل' : 'اضافة'),
              //     onPressed: () {
              //       // controller.addGroup(isEdit, groupId);
              //     },
              //   ),
              // ),
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
      spacing: 4.0,
      runSpacing: 4.0,
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
    // return AlignedGridView.count(
    //   shrinkWrap: true,
    //   crossAxisCount: 2,
    //   physics: const NeverScrollableScrollPhysics(),
    //   itemCount: controller.daysOfWeek.length,
    //   itemBuilder: (context, index) {
    //     return Obx(
    //       () => SizedBox(
    //         height: 50,
    //         child: CheckboxListTile(
    //           title: Text(controller.daysOfWeek[index]),
    //           value: controller.selectedDays[index],
    //           onChanged: (bool? value) {
    //             controller.toggleDay(index);
    //           },
    //         ),
    //       ),
    //     );
    //   },
    //   mainAxisSpacing: 4.0,
    //   crossAxisSpacing: 4.0,
    // );
  }
}

class HourSelectionWidget extends StatelessWidget {
  final controller = Get.put(WeeklyCalendarController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          InkWell(
            onTap: () => controller.selectTime(context),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical:  12,horizontal: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(controller.colorController.selectedColor.value),
              ),
              child: Center(
                child: Text(
                  ' ${controller.selectedTime.value.format(context)} ',
                  // 'الوقت:  ${controller.selectedTime.value.format(context)} ',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class YearSelectionWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<GroupsController>(
//       init: GroupsController(),
//       builder: (controller) {
//         return Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   const SizedBox(width: 10),
//                   Obx(
//                     () => Expanded(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text("اختر السنة"),
//                                 content: SizedBox(
//                                   width: 300,
//                                   height: 300,
//                                   child: YearPicker(
//                                     firstDate: DateTime(2022),
//                                     lastDate:
//                                         DateTime(DateTime.now().year + 10, 1),
//                                     initialDate: DateTime.now(),
//                                     selectedDate:
//                                         controller.selectedYearDateTime,
//                                     onChanged: (DateTime dateTime) {
//                                       controller.selectedYearDateTime =
//                                           dateTime;
//
//                                       controller.selectedYear.value =
//                                           dateTime.year;
//                                       controller.refreshMonthsSessions();
//                                       Get.back();
//                                     },
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                         child: Text(
//                           'السنة:  ${controller.selectedYear} ',
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class DeleteGroupForm extends StatelessWidget {
//   const DeleteGroupForm({
//     super.key,
//     required this.groupId,
//   });
//   final String groupId;
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(GroupsController());
//
//     return FractionallySizedBox(
//       heightFactor: 0.93,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text('حذف المجموعة',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge!
//                       .copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
//               const SizedBox(height: KSizes.spaceBtwSections),
//               Text(
//                   'تحزير ⚠️ : حذف المجموعة سيؤدي الي حذف جميع الطلاب المسجلين بها نهائياً.',
//                   style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                       color: KColors.error, fontWeight: FontWeight.bold)),
//               const SizedBox(height: KSizes.spaceBtwSections * 2),
//               Text('هل انت متأكد من حذف المجموعة؟',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleSmall!
//                       .copyWith(fontWeight: FontWeight.bold)),
//               const SizedBox(height: KSizes.spaceBtwSections*2),
//               Obx(() {
//                 if (controller.isDeleting.value) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text('جاري حذف المجموعة...',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleSmall!
//                               .copyWith(
//                               color: KColors.error,
//                               fontWeight: FontWeight.bold)),
//                       const CircularProgressIndicator(color: KColors.error ,),
//                     ],
//                   );
//                 } else {
//                   return SizedBox(
//                     width: double.maxFinite,
//                     child: ElevatedButton(
//                       child: const Text('حذف المجموعة نهائياً'),
//                       onPressed: () async {
//                         controller.deleteGroupAndStudents(groupId);
//                       },
//                     ),
//                   );
//                 }
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
