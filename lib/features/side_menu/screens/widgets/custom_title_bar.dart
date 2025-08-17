import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:questly/features/side_menu/screens/side_menu.dart';
import 'package:questly/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:window_manager/window_manager.dart';

class CustomTitleBar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonHoverColor;

  const CustomTitleBar({
    super.key,
    this.title = "Second Brain",
    this.backgroundColor = const Color(0xFF1C1C1C),
    this.textColor = Colors.white,
    this.buttonHoverColor = const Color(0xFF404040),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        // gradient: const LinearGradient(
        //   colors: [Color(0xFFFF6B6B), Color(0xFF9D8DF1)],
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        // ),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                windowManager.startDragging();
              },
              onTapDown: (details) {
                windowManager.startDragging();
              },
              child: Container(
                decoration: BoxDecoration(
                    // color: backgroundColor,
                    borderRadius: BorderRadius.circular(4)),
                width: double.maxFinite,
                height: 32,
              ),
            ),
          ),
          _WindowButton(
            icon: Icons.remove,
            onPressed: () => windowManager.minimize(),
            hoverColor: buttonHoverColor,
          ),
          _WindowButton(
            icon: Icons.crop_square,
            onPressed: () async {
              print('hi');
              if (await windowManager.isMaximized()) {
                windowManager.restore();
              } else {
                windowManager.maximize();
              }
            },
            hoverColor: buttonHoverColor,
          ),
          _WindowButton(
            icon: Icons.close,
            onPressed: () => windowManager.close(),
            hoverColor: Colors.red.withOpacity(0.8),
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color hoverColor;
  final Color? iconColor;

  const _WindowButton({
    required this.icon,
    required this.onPressed,
    required this.hoverColor,
    this.iconColor,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 38,
            color: isHovered ? widget.hoverColor : Colors.transparent,
            child: Icon(
              widget.icon,
              color: isHovered ? Colors.white : Colors.grey,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
