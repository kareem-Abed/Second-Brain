import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:second_brain/features/kanban_bord/controller/kanban_board_controller.dart';
import 'package:second_brain/utils/constants/colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key,

    required this.controller,
    required this.listId,
  });
  final String listId;
  final KanbanController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 6.0),
      child: Row(
        children: [
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                onTap: () {
                  controller.listNameController.value.text =
                      controller.listNames[listId]!.value;
                  controller.isListEditMode.value = true;
                  controller.editingListId.value = listId;
                  controller.showListNameTextField.value = true;
                },
                title: 'edit',
                isDestructive: false,
                icon: Icons.edit,
              ),
              PullDownMenuItem(
                onTap: () {
                  controller.removeColumn(listId);
                },
                title: 'Delete',
                isDestructive: true,
                icon: Icons.delete,
              ),
            ],
            buttonBuilder: (context, showMenu) => IconButton(
              onPressed: showMenu,
              icon: const Icon(
                FontAwesomeIcons.ellipsis,
              ),
            ),
          ),
          Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: const BoxDecoration(
              color: KColors.darkModeBackground,
              shape: BoxShape.circle,
            ),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        (controller.board.value[listId]?.length ?? '0')
                            .toString(),
                        style: Theme.of(context).textTheme.headlineMedium),
                  );
                })),
          ),
          SizedBox(
            width: 180.0,
            // width: 220.0,
            child: Obx(
              () => Text(controller.listNames[listId]!.value,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
        ],
      ),
    );
  }
}
