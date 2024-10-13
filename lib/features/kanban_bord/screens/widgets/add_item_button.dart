import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/kanban_bord/controller/kanban_board_controller.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/validators/validation.dart';

//
// class AddItemButton extends StatelessWidget {
//   final KanbanController controller = Get.find();
//   final VoidCallback onActivate;
//   final String listId;
//   final String activeListId;
//
//   AddItemButton({
//     required this.onActivate,
//     required this.listId,
//     required this.activeListId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 3.0),
//             child: Divider(
//               color: KColors.darkModeSubCard,
//               thickness: 3.0,
//             ),
//           ),
//           Obx(
//             () => controller.ShowItemNameTextField.value &&
//                     activeListId == listId
//                 ? Container(
//                     key: ValueKey(1),
//                     decoration: BoxDecoration(
//                       color: KColors.darkModeCard,
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     padding: EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         TextField(
//                           maxLines: 2,
//                           controller: controller.ItemNameController.value,
//                           focusNode: controller.ItemNameFocusNode.value,
//                           decoration: InputDecoration(
//                             hintText: 'Enter list name',
//                             hintStyle:
//                                 TextStyle(color: KColors.grey.withOpacity(0.5)),
//                           ),
//                           onSubmitted: (value) {
//                             if (controller
//                                 .ItemNameController.value.text.isEmpty) {
//                               return;
//                             }
//                             controller.addItem(
//                               listId,
//                               controller.ItemNameController.value.text,
//                             );
//                             controller.ShowItemNameTextField.value = false;
//                             controller.ItemNameController.value.clear();
//                           },
//                         ),
//                         SizedBox(height: 8.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             IconButton(
//                               icon: Icon(FontAwesomeIcons.xmark),
//                               onPressed: () {
//                                 controller.ShowItemNameTextField.value = false;
//                               },
//                             ),
//                             SizedBox(width: 8.0),
//                             InkWell(
//                               onTap: () {
//                                 if (controller
//                                     .ItemNameController.value.text.isEmpty) {
//                                   return;
//                                 }
//                                 controller.addItem(
//                                   listId,
//                                   controller.ItemNameController.value.text,
//                                 );
//                                 controller.ShowItemNameTextField.value = false;
//                                 controller.listNameController.value.clear();
//                               },
//                               child: Container(
//                                   decoration: BoxDecoration(
//                                     color: KColors.darkModeSubCard,
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text('Add list'),
//                                       SizedBox(width: 8.0),
//                                       Icon(IconsaxPlusLinear.add),
//                                     ],
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 : InkWell(
//                     key: ValueKey(2),
//                     onTap: onActivate,
//                     child: Container(
//                         decoration: BoxDecoration(
//                           color: KColors.darkModeCard,
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         padding: EdgeInsets.all(10.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text('Add another list'),
//                             SizedBox(width: 8.0),
//                             Icon(Icons.add),
//                           ],
//                         )),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class AddItemButton extends StatelessWidget {
  final KanbanController controller = Get.find();
  final VoidCallback onActivate;
  final String listId;
  // final String activeListId;

  AddItemButton({super.key,
    required this.onActivate,
    required this.listId,
    // required this.activeListId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.0),
          child: Divider(
            color: KColors.darkModeSubCard,
            thickness: 3.0,
          ),
        ),
        Obx(
          () => controller.showItemNameTextField.value &&
                  controller.activeListId.value == listId
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
                          maxLines: 2,
                          controller: controller.itemNameController.value,
                          focusNode: controller.itemNameFocusNode.value,
                          validator: (value) => KValidator.validateEmptyText(
                              'اسم المهمة', value),
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: controller.isItemEditMode.value
                                ? 'Edit item name'
                                : 'Enter item name',
                          ),
                          // onFieldSubmitted: (value) {
                          //   if (controller
                          //       .itemNameController.value.text.isEmpty) {
                          //     return;
                          //   }
                          //   if (controller.isItemEditMode.value) {
                          //     controller.editItem(
                          //       controller.editingItemListId.value,
                          //       controller.editingItemId.value,
                          //       controller.itemNameController.value.text,
                          //     );
                          //   } else {
                          //     controller.addItem(
                          //       listId,
                          //       controller.itemNameController.value.text,
                          //     );
                          //   }
                          //   controller.showItemNameTextField.value = false;
                          //   controller.itemNameController.value.clear();
                          //   controller.isItemEditMode.value = false;
                          // },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(FontAwesomeIcons.xmark),
                            onPressed: () {
                              controller.showItemNameTextField.value = false;
                              controller.itemNameController.value.clear();
                              controller.isItemEditMode.value = false;
                            },
                          ),
                          const SizedBox(width: 8.0),
                          InkWell(
                            onTap: () {
                              if (controller
                                  .itemNameController.value.text.isEmpty) {
                                return;
                              }
                              if (controller.isItemEditMode.value) {
                                controller.editItem(
                                  controller.editingItemListId.value,
                                  controller.editingItemId.value,
                                  controller.itemNameController.value.text,
                                );
                              } else {
                                controller.addItem(
                                  listId,
                                  controller.itemNameController.value.text,
                                );
                              }
                              controller.showItemNameTextField.value = false;
                              controller.itemNameController.value.clear();
                              controller.isItemEditMode.value = false;
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
                                    Text(controller.isItemEditMode.value
                                        ? 'Edit item'
                                        : 'Add item'),
                                    const SizedBox(width: 8.0),
                                    Icon(controller.isItemEditMode.value
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
                  onTap: onActivate,
                  child: Container(
                      decoration: BoxDecoration(
                        color: KColors.darkModeCard,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Add another item'),
                          SizedBox(width: 8.0),
                          Icon(Icons.add),
                        ],
                      )),
                ),
        ),
      ],
    );
  }
}
