import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_brain/features/kanban_bord/controller/kanban_board_controller.dart';
import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';

import '../../../../utils/constants/sizes.dart';
import '../../controller/side_menu_controller.dart';

class HoverableMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final int index;
  final bool exit;

  const HoverableMenuItem({
    required this.icon,
    required this.title,
    required this.index,
    this.exit = false,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HoverableMenuItemState createState() => _HoverableMenuItemState();
}

class _HoverableMenuItemState extends State<HoverableMenuItem> {
  bool isHovered = false;
  final controller = Get.find<WeeklyCalendarController>();
  final sideMenuController = Get.find<SideMenuController>();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          sideMenuController.playSound();
          if (widget.exit) {
            exit(0);
          } else {
            if (widget.index == 2) {
              controller.showFullWidthTask.value = true;
            } else {
              controller.showFullWidthTask.value = false;
            }
            if (widget.index == 1 || widget.index == 2) {
              controller.showAddTask.value = false;
              controller.showUpdateTask.value = false;
            }
            if (widget.index == 4) {
              final kanbanController = Get.put(KanbanController());
              kanbanController.loadBoardState('board', 'listNames');
            }
            sideMenuController.updateSelectedIndex(widget.index);
          }
        },
        child: Obx(() {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: 80,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Icon(
                        widget.icon,
                        color: sideMenuController.selectedIndex.value ==
                                widget.index
                            ? Colors.lightBlue
                            : isHovered
                                ? Colors.blue.withOpacity(0.7)
                                : Colors.white,
                        size: 28,
                      ),
                      const SizedBox(height: KSizes.sm / 2),
                      SizedBox(
                        width: 56,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              color: sideMenuController.selectedIndex.value ==
                                      widget.index
                                  ? Colors.lightBlue
                                  : isHovered
                                      ? Colors.blue.withOpacity(0.7)
                                      : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                    height: 52,
                    width: 4,
                    decoration: BoxDecoration(
                      color:
                          sideMenuController.selectedIndex.value == widget.index
                              ? Colors.lightBlue
                              : isHovered
                                  ? Colors.blue.withOpacity(0.4)
                                  : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    )),
              ],
            ),
          );
        }),
      ),
    );
  }
}
