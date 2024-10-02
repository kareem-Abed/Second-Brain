import 'dart:io';

import 'package:flutter/services.dart';
import 'package:second_brain/features/habit/screens/habit_screen.dart';
import 'package:second_brain/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:second_brain/features/weekly_calendar/screens/weekly_calendar/weekly_calendar.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import 'features/trello_bord/screens/widgets/kanban_board.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({Key? key}) : super(key: key);

  @override
  _CustomSideMenuState createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  PageController pageController = PageController();
  final controller = Get.put(WeeklyCalendarController());
  final timeController = Get.put(WeeklyCalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: KColors.darkModeSideMenuBackground,
                    ),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const WeeklyCalendarScreen(viewCurrentDayOnly: false),
                        const WeeklyCalendarScreen(viewCurrentDayOnly: true),
                        KanbanBoard(),
                        HabitScreen(),
                        Container(
                          color: Colors.black,
                          child: const Center(
                            child: Text(
                              'إعدادات',
                              style:
                                  TextStyle(fontSize: 35, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
                color: KColors.darkModeSideMenuBackground,

                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black38,
                //     blurRadius: 4.0,
                //     spreadRadius: 0.0,
                //     offset: Offset(5, 2),
                //   )
                // ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() {
                      final currentHour = timeController.currentHour.value;

                      String getTimePeriodImage(int hour) {
                        if (hour >= 4 && hour < 6) {
                          return 'assets/images/dawn.png';
                        } else if (hour >= 6 && hour < 12) {
                          return 'assets/images/sunrise.png';
                        } else if (hour >= 12 && hour < 15) {
                          return 'assets/images/afternoon.png';
                        } else if (hour >= 15 && hour < 18) {
                          return 'assets/images/sunset.png';
                        } else if (hour >= 18 && hour < 21) {
                          return 'assets/images/evening.png';
                        } else {
                          return 'assets/images/midnight.png';
                        }
                      }

                      String getTimePeriod(int hour) {
                        if (hour >= 4 && hour < 6) {
                          return 'فجر';
                        } else if (hour >= 6 && hour < 12) {
                          return 'صباح';
                        } else if (hour >= 12 && hour < 15) {
                          return 'ظهر';
                        } else if (hour >= 15 && hour < 18) {
                          return 'عصر';
                        } else if (hour >= 18 && hour < 21) {
                          return 'مساء';
                        } else if (hour >= 21 && hour < 24) {
                          return 'ليل';
                        } else {
                          return 'منتصف الليل';
                        }
                      }

                      final image = getTimePeriodImage(currentHour);
                      final timeOfDayText = getTimePeriod(currentHour);

                      return Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 65,
                            ),
                            child: Image.asset(image),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 5),
                            child: FittedBox(
                              child: Text(
                                timeOfDayText,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    SizedBox(
                      height: KSizes.sm,
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.calendar,
                      title: 'اسبوع',
                      index: 0,
                    ),
                    _buildMenuItem(
                      icon: Icons.calendar_view_day,
                      title: 'يوم',
                      index: 1,
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.tableColumns,
                      title: 'مهام',
                      index: 2,
                    ),
                    _buildMenuItem(
                      icon: FontAwesomeIcons.listCheck,
                      title: 'العادات',
                      index: 3,
                    ),
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: 'إعدادات',
                      index: 5,
                    ),
                    _buildMenuItem(
                      icon: Icons.exit_to_app,
                      title: 'الخروج',
                      index: 6,
                      exit: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      {required IconData icon,
      required String title,
      required int index,
      bool exit = false}) {
    return HoverableMenuItem(
      icon: icon,
      title: title,
      index: index,
      pageController: pageController,
      controller: controller,
      exit: exit,
    );
  }
}

class HoverableMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final int index;
  final bool exit;
  final PageController pageController;
  final WeeklyCalendarController controller;

  const HoverableMenuItem({
    required this.icon,
    required this.title,
    required this.index,
    required this.pageController,
    required this.controller,
    this.exit = false,
    Key? key,
  }) : super(key: key);

  @override
  _HoverableMenuItemState createState() => _HoverableMenuItemState();
}

class _HoverableMenuItemState extends State<HoverableMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: GestureDetector(
          onTap: () {
            if (widget.exit) {
              exit(0);
            } else {
              widget.pageController.jumpToPage(widget.index);
              widget.controller.iconIndex.value = widget.index;
            }
          },
          child: Obx(() {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              // width: 70,
              padding: const EdgeInsets.symmetric(
                vertical: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Icon(
                        widget.icon,
                        color: widget.controller.iconIndex.value == widget.index
                            ? Colors.blue
                            : Colors.white,
                        size: 24,
                      ),
                      // const SizedBox(height: KSizes.sm),
                      // Text(
                      //   widget.title,
                      //   style: TextStyle(
                      //     color:
                      //         widget.controller.iconIndex.value == widget.index
                      //             ? Colors.blue
                      //             : Colors.white,
                      //     fontSize: 12,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Container(
                      height: 52,
                      width: 3,
                      decoration: BoxDecoration(
                        color: widget.controller.iconIndex.value == widget.index
                            ? Colors.lightBlue
                            : isHovered
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      )),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
