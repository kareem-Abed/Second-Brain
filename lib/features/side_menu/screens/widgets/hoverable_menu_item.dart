import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questly/features/kanban_bord/controller/kanban_board_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/side_menu_controller.dart';

class HoverableMenuItem extends StatefulWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String title;
  final int index;
  final bool exit;
  final VoidCallback? onTap;

  const HoverableMenuItem({
    this.icon,
    this.customIcon,
    required this.title,
    required this.index,
    this.exit = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableMenuItemState createState() => _HoverableMenuItemState();
}

class _HoverableMenuItemState extends State<HoverableMenuItem> {
  bool isHovered = false;
  final sideMenuController = Get.find<SideMenuController>();

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          sideMenuController.playSound();
          if (widget.exit) {
            exit(0);
          } else {
            widget.onTap!();
          }
        },
        child: Tooltip(
          message: widget.title,
          waitDuration: const Duration(milliseconds: 600),
          showDuration: const Duration(milliseconds: 2000),
          preferBelow: false,
          verticalOffset: -24,
          margin: const EdgeInsets.only(
            left: 32,
          ),
          decoration: BoxDecoration(
            color: KColors.darkModeCard,
            border: Border.all(
              color: KColors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(2, 0),
              ),
            ],
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          child: Container(
            margin: const EdgeInsets.only(top: KSizes.lg),
            decoration: const BoxDecoration(),
            child: Center(
              child: widget.customIcon ??
                  Obx(() => Icon(
                        widget.icon,
                        color: sideMenuController.selectedIndex.value ==
                                widget.index
                            ? Colors.white
                            : isHovered
                                ? Colors.blue.withOpacity(0.7)
                                : Colors.grey,
                        size: 24,
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
