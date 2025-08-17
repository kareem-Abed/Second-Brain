import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:questly/features/kanban_bord/controller/kanban_board_controller.dart';
import 'package:questly/utils/constants/colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.controller,
    required this.listId,
  });

  void _showOverlayMenu(BuildContext context) {
    final overlay = Overlay.of(context).context.findRenderObject();
    final button = context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero);

    showMenu(
      color: KColors.darkModeSubCard,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + button.size.width,
        position.dy,
        overlay?.semanticBounds.size.width ?? 0 - position.dx,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: Text('Edit',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white)),
            onTap: () {
              controller.listNameController.value.text =
                  controller.listNames[listId]!.value;
              controller.isListEditMode.value = true;
              controller.editingListId.value = listId;
              controller.showListNameTextField.value = true;
              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text('Delete',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red)),
            onTap: () {
              controller.removeColumn(listId);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  final String listId;
  final KanbanController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 6.0),
      child: Row(
        children: [
          // PullDownButton(
          //   itemBuilder: (context) => [
          //     PullDownMenuItem(
          //       onTap: () {
          //         controller.listNameController.value.text =
          //             controller.listNames[listId]!.value;
          //         controller.isListEditMode.value = true;
          //         controller.editingListId.value = listId;
          //         controller.showListNameTextField.value = true;
          //       },
          //       title: 'edit',
          //       isDestructive: false,
          //       icon: Icons.edit,
          //     ),
          //     PullDownMenuItem(
          //       onTap: () {
          //         controller.removeColumn(listId);
          //       },
          //       title: 'Delete',
          //       isDestructive: true,
          //       icon: Icons.delete,
          //     ),
          //   ],
          //   buttonBuilder: (context, showMenu) => IconButton(
          //     onPressed: showMenu,
          //     icon: const Icon(
          //       FontAwesomeIcons.ellipsis,
          //     ),
          //   ),
          // ),
          IconButton(
            onPressed: () => _showOverlayMenu(context),
            icon: const Icon(
              FontAwesomeIcons.ellipsis,
              color: KColors.white,
              weight: 4,
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
