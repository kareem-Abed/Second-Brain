import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questly/features/kanban_bord/controller/kanban_board_controller.dart';
import 'package:questly/utils/constants/colors.dart';
import 'package:questly/utils/validators/validation.dart';

class AddListButton extends StatelessWidget {
  const AddListButton({super.key});

  @override
  Widget build(BuildContext context) {
    final KanbanController controller = Get.find();
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  )),
                  child: child,
                );
              },
              child: controller.showListNameTextField.value
                  ? Container(
                      key: const ValueKey(1),
                      decoration: BoxDecoration(
                        color: KColors.darkModeCard,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Obx(
                            () => TextFormField(
                              controller: controller.listNameController.value,
                              focusNode: controller.listNameFocusNode.value,
                              validator: (value) =>
                                  KValidator.validateEmptyText(
                                      'اسم المهمة', value),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                hintText: controller.isListEditMode.value
                                    ? 'Edit list name'
                                    : 'Enter list name',
                              ),
                              onFieldSubmitted: (value) {
                                if (controller
                                    .listNameController.value.text.isEmpty) {
                                  return;
                                }
                                if (controller.isListEditMode.value) {
                                  controller.editList(
                                    controller.editingListId.value,
                                    controller.listNameController.value.text,
                                  );
                                } else {
                                  controller.addList(
                                    controller.listNameController.value.text,
                                  );
                                }
                                controller.showListNameTextField.value = false;
                                controller.listNameController.value.clear();
                                controller.isListEditMode.value = false;
                              },
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(FontAwesomeIcons.xmark),
                                onPressed: () {
                                  controller.showListNameTextField.value =
                                      false;
                                  controller.listNameController.value.clear();
                                  controller.isListEditMode.value = false;
                                },
                              ),
                              const SizedBox(width: 8.0),
                              InkWell(
                                onTap: () {
                                  if (controller
                                      .listNameController.value.text.isEmpty) {
                                    return;
                                  }
                                  if (controller.isListEditMode.value) {
                                    controller.editList(
                                      controller.editingListId.value,
                                      controller.listNameController.value.text,
                                    );
                                  } else {
                                    controller.addList(
                                      controller.listNameController.value.text,
                                    );
                                  }
                                  controller.showListNameTextField.value =
                                      false;
                                  controller.listNameController.value.clear();
                                  controller.isListEditMode.value = false;
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: KColors.darkModeSubCard,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(controller.isListEditMode.value
                                            ? 'Edit list'
                                            : 'Add list'),
                                        const SizedBox(width: 8.0),
                                        Icon(controller.isListEditMode.value
                                            ? IconsaxPlusLinear.edit
                                            : IconsaxPlusLinear.add),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      key: const ValueKey(2),
                      onTap: () {
                        controller.showListNameTextField.value = false;
                        controller.showListNameTextField.value = true;
                        controller.listNameFocusNode.value.requestFocus();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            color: KColors.darkModeCard,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Add another list'),
                              SizedBox(width: 8.0),
                              Icon(Icons.add),
                            ],
                          )),
                    ),
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
