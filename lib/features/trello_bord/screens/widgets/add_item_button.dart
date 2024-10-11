import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/trello_bord/controller/kanban_board_controller.dart';
import 'package:second_brain/utils/constants/colors.dart';

class AddItemButton extends StatelessWidget {
  final KanbanController controller = Get.find();
  final VoidCallback onActivate;
  final String listId;
  final String activeListId;

  AddItemButton({
    required this.onActivate,
    required this.listId,
    required this.activeListId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Divider(
              color: KColors.darkModeSubCard,
              thickness: 3.0,
            ),
          ),
          Obx(
            () => controller.ShowItemNameTextField.value &&
                    activeListId == listId
                ? Container(
                    key: ValueKey(1),
                    decoration: BoxDecoration(
                      color: KColors.darkModeCard,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        TextField(
                          maxLines: 2,
                          controller: controller.ItemNameController.value,
                          focusNode: controller.ItemNameFocusNode.value,
                          decoration: InputDecoration(
                            hintText: 'Enter list name',
                            hintStyle:
                                TextStyle(color: KColors.grey.withOpacity(0.5)),
                          ),
                          onSubmitted: (value) {
                            if (controller
                                .ItemNameController.value.text.isEmpty) {
                              return;
                            }
                            controller.addItem(
                              listId,
                              controller.ItemNameController.value.text,
                            );
                            controller.ShowItemNameTextField.value = false;
                            controller.ItemNameController.value.clear();
                          },
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(FontAwesomeIcons.xmark),
                              onPressed: () {
                                controller.ShowItemNameTextField.value = false;
                              },
                            ),
                            SizedBox(width: 8.0),
                            InkWell(
                              onTap: () {
                                if (controller
                                    .ItemNameController.value.text.isEmpty) {
                                  return;
                                }
                                controller.addItem(
                                  listId,
                                  controller.ItemNameController.value.text,
                                );
                                controller.ShowItemNameTextField.value = false;
                                controller.listNameController.value.clear();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: KColors.darkModeSubCard,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Add list'),
                                      SizedBox(width: 8.0),
                                      Icon(IconsaxPlusLinear.add),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : InkWell(
                    key: ValueKey(2),
                    onTap: onActivate,
                    child: Container(
                        decoration: BoxDecoration(
                          color: KColors.darkModeCard,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Add another list'),
                            SizedBox(width: 8.0),
                            Icon(Icons.add),
                          ],
                        )),
                  ),
          ),
        ],
      ),
    );
  }
}
// class AddItemButton extends StatelessWidget {
//   final KanbanController controller = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // padding: EdgeInsets.all(16.0),
//       // width: 300,
//       // color: KColors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Obx(
//             () => controller.ShowListNameTextField.value
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
//                           controller: controller.listNameController.value,
//                           decoration: InputDecoration(
//                             hintText: 'Enter list name',
//                             hintStyle:
//                                 TextStyle(color: KColors.grey.withOpacity(0.5)),
//                           ),
//                           onSubmitted: (value) {
//                             if (controller
//                                 .listNameController.value.text.isEmpty) {
//                               return;
//                             }
//                             controller.addList(
//                               controller.listNameController.value.text,
//                             );
//                             controller.ShowListNameTextField.value = false;
//                             controller.listNameController.value.clear();
//                           },
//                         ),
//                         SizedBox(height: 8.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             IconButton(
//                               icon: Icon(FontAwesomeIcons.xmark),
//                               onPressed: () {
//                                 controller.ShowListNameTextField.value = false;
//                               },
//                             ),
//                             SizedBox(width: 8.0),
//                             InkWell(
//                               onTap: () {
//                                 if (controller
//                                     .listNameController.value.text.isEmpty) {
//                                   return;
//                                 }
//                                 controller.addList(
//                                   controller.listNameController.value.text,
//                                 );
//                                 controller.ShowListNameTextField.value = false;
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
//                     onTap: () {
//                       controller.ShowListNameTextField.value = true;
//                     },
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
