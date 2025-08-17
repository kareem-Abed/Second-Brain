import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:questly/features/pomodoro/screens/pomodoro.dart';
import 'package:questly/features/side_menu/screens/widgets/custom_title_bar.dart';
import 'package:questly/features/side_menu/screens/widgets/hoverable_menu_item.dart';
import 'package:questly/features/side_menu/screens/widgets/placeholder_page_widget.dart';
import 'package:questly/features/side_menu/screens/widgets/smart_pomodoro_icon.dart';
import 'package:questly/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:questly/utils/constants/sizes.dart';
import '../../calender/screens/calender.dart';
import '../../flip_clock/screens/flip_clock.dart';
import '../../kanban_bord/screens/kanban_board.dart';
import '../../player/screens/flip_clock.dart';
import '../../pomodoro/controller/pomodoro_controller.dart';
import '../controller/side_menu_controller.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({Key? key}) : super(key: key);

  @override
  _CustomSideMenuState createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  final sideMenuController = Get.find<SideMenuController>();
  final pomodoroController = Get.put(PomodoroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomTitleBar(
            backgroundColor: KColors.darkModeSideMenuBackground,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SideMenuWidget(),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Obx(() => _getScreenByIndex(
                            sideMenuController.selectedIndex.value)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScreenByIndex(int index) {
    switch (index) {
      case 0:
        return const PlaceholderPageWidget(title: 'Dashboard');
      case 1:
        return const CalendarScreen();
      case 2:
        return const PlaceholderPageWidget(title: 'Daily Calendar');
      case 3:
        return const PlaceholderPageWidget(title: 'Project Manager');
      case 4:
        return const KanbanBoard();
      case 5:
        return const Pomodoro();
      case 6:
        return const PlaceholderPageWidget(title: 'Course Manager');
      case 7:
        return const PlaceholderPageWidget(title: 'Habit Tracker');
      case 8:
        return const PlaceholderPageWidget(title: 'Settings');
      case 10:
        return const PlaceholderPageWidget(title: 'Achievements');
      case 11:
        return FlipClockScreen();
      case 12:
        return const Tasks();
      default:
        return const PlaceholderPageWidget(title: 'Dashboard');
    }
  }
}

//
// class SideMenuWidget extends StatelessWidget {
//   const SideMenuWidget({super.key});
//
//   void _navigateToPage(int index) {
//     final controller = Get.find<SideMenuController>();
//     controller.updateSelectedIndex(index);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 50,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         color: KColors.darkModeSideMenuBackground,
//         border: Border(
//           right: BorderSide(
//             color: KColors.darkModeBorder,
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: KSizes.lg),
//               child: MouseRegion(
//                 cursor: SystemMouseCursors.click,
//                 child: GestureDetector(
//                   onTap: () => _navigateToPage(0),
//                   child: ConstrainedBox(
//                     constraints: const BoxConstraints(maxWidth: KSizes.iconLg),
//                     child: Image.asset('assets/images/app logo.png'),
//                   ),
//                 ),
//               ),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.category,
//               title: 'Dashboard',
//               index: 0,
//               onTap: () => _navigateToPage(0),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.calendar,
//               title: 'Calendar',
//               index: 1,
//               onTap: () => _navigateToPage(1),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.folder,
//               title: 'Projects',
//               index: 3,
//               onTap: () => _navigateToPage(3),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.task_square,
//               title: 'Tasks',
//               index: 4,
//               onTap: () => _navigateToPage(4),
//             ),
//             HoverableMenuItem(
//               customIcon: SmartPomodoroIcon(),
//               title: 'Pomodoro',
//               index: 5,
//               onTap: () => _navigateToPage(5),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.book_square,
//               title: 'Courses',
//               index: 6,
//               onTap: () => _navigateToPage(6),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.tree,
//               title: 'Habits',
//               index: 7,
//               onTap: () => _navigateToPage(7),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.award,
//               title: 'Achievements',
//               index: 10,
//               onTap: () => _navigateToPage(10),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.clock_1,
//               title: 'FlipClockScreen',
//               index: 11,
//               onTap: () => _navigateToPage(11),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.task_square,
//               title: 'FlipClockScreen',
//               index: 12,
//               onTap: () => _navigateToPage(12),
//             ),
//             HoverableMenuItem(
//               icon: IconsaxPlusBold.setting_2,
//               title: 'Settings',
//               index: 8,
//               onTap: () => _navigateToPage(8),
//             ),
//             const HoverableMenuItem(
//               icon: IconsaxPlusLinear.arrow_square_left,
//               title: 'Exit',
//               index: 9,
//               exit: true,
//             ),
//             const SizedBox(height: KSizes.lg),
//           ],
//         ),
//       ),
//     );
//   }
// }
class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({super.key});

  void _navigateToPage(int index) {
    final controller = Get.find<SideMenuController>();
    controller.updateSelectedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    // Define a list of colors for hover effects
    final List<Color> hoverColors = [
      const Color(0xFFFF6B6B), // Red
      const Color(0xFF4ECDC4), // Teal
      const Color(0xFFFFD166), // Yellow
      const Color(0xFF9D8DF1), // Purple
      const Color(0xFF06D6A0), // Green
      const Color(0xFFFF9F1C), // Orange
      const Color(0xFF118AB2), // Blue
      const Color(0xFFEF476F), // Pink
      const Color(0xFF073B4C), // Dark Blue
      const Color(0xFF84A59D), // Sage
      const Color(0xFFF28482), // Coral
      // const Color(0xFF8E9AAF), // Lavender
      Colors.red
    ];

    return Container(
      width: 220,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: KColors.darkModeSideMenuBackground,
        border: Border(
          right: BorderSide(
            color: KColors.darkModeBorder,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: KSizes.md, left: 12),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _navigateToPage(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: KSizes.iconLg),
                      child: Image.asset('assets/images/app logo.png'),
                    ),
                    const SizedBox(width: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFF9D8DF1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Questly',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: KSizes.sm),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white30,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
              color: KColors.darkModeCard.withOpacity(0.2),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    IconsaxPlusLinear.search_normal,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Search..',
                      hintStyle: TextStyle(color: Colors.white60),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: KSizes.md),
                  // const SizedBox(height: KSizes.sm),
                  HoverableMenuItem(
                    icon: IconsaxPlusBold.category,
                    title: 'Dashboard',
                    index: 0,
                    onTap: () => _navigateToPage(0),
                    hoverColor: hoverColors[0],
                  ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.calendar,
                  //   title: 'Calendar',
                  //   index: 1,
                  //   onTap: () => _navigateToPage(1),
                  //   hoverColor: hoverColors[1],
                  // ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.folder,
                  //   title: 'Projects',
                  //   index: 3,
                  //   onTap: () => _navigateToPage(3),
                  //   hoverColor: hoverColors[2],
                  // ),
                  HoverableMenuItem(
                    icon: IconsaxPlusBold.task_square,
                    title: 'Tasks',
                    index: 4,
                    onTap: () => _navigateToPage(4),
                    hoverColor: hoverColors[3],
                  ),
                  HoverableMenuItem(
                    customIcon: SmartPomodoroIcon(),
                    title: 'Pomodoro',
                    index: 5,
                    onTap: () => _navigateToPage(5),
                    hoverColor: hoverColors[4],
                  ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.book_square,
                  //   title: 'Courses',
                  //   index: 6,
                  //   onTap: () => _navigateToPage(6),
                  //   hoverColor: hoverColors[5],
                  // ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.tree,
                  //   title: 'Habits',
                  //   index: 7,
                  //   onTap: () => _navigateToPage(7),
                  //   hoverColor: hoverColors[6],
                  // ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.award,
                  //   title: 'Achievements',
                  //   index: 10,
                  //   onTap: () => _navigateToPage(10),
                  //   hoverColor: hoverColors[7],
                  // ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.clock_1,
                  //   title: 'FlipClockScreen',
                  //   index: 11,
                  //   onTap: () => _navigateToPage(11),
                  //   hoverColor: hoverColors[8],
                  // ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.task_square,
                  //   title: 'FlipClockScreen',
                  //   index: 12,
                  //   onTap: () => _navigateToPage(12),
                  //   hoverColor: hoverColors[9],
                  // ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusBold.setting_2,
                  //   title: 'Settings',
                  //   index: 8,
                  //   onTap: () => _navigateToPage(8),
                  //   hoverColor: hoverColors[10],
                  // ),
                  // HoverableMenuItem(
                  //   icon: IconsaxPlusLinear.arrow_square_left,
                  //   title: 'Exit',
                  //   index: 9,
                  //   exit: true,
                  //   hoverColor: hoverColors[11],
                  // ),
                  const SizedBox(height: KSizes.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoverableMenuItem extends StatefulWidget {
  final IconData? icon;
  final Widget? customIcon;
  final String title;
  final int index;
  final bool exit;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color hoverColor;

  const HoverableMenuItem({
    this.icon,
    this.customIcon,
    required this.title,
    required this.index,
    this.exit = false,
    this.onTap,
    this.isSelected = false,
    this.hoverColor = const Color(0xFFFF6B6B),
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
    return Obx(() {
      final isSelected = widget.isSelected ||
          sideMenuController.selectedIndex.value == widget.index;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: InkWell(
            onTap: () {
              sideMenuController.playSound();
              if (widget.exit) {
                // exit(0);
              } else {
                widget.onTap?.call();
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFF9D8DF1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : isHovered
                        ? LinearGradient(
                            colors: [
                              widget.hoverColor.withOpacity(0.05),
                              widget.hoverColor.withOpacity(0.05)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (widget.customIcon != null)
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        isSelected
                            ? Colors.white
                            : isHovered
                                ? widget.hoverColor
                                : Colors.white70,
                        BlendMode.srcIn,
                      ),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: widget.customIcon!,
                      ),
                    )
                  else if (widget.icon != null)
                    Icon(
                      widget.icon,
                      color: isSelected
                          ? Colors.white
                          : isHovered
                              ? widget.hoverColor
                              : Colors.white70,
                      size: 22,
                    ),
                  const SizedBox(width: 16),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isHovered
                              ? Colors.white
                              : Colors.white70,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
