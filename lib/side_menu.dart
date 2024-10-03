import 'dart:io';

import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
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
                      children: [
                        HeaderButtons(),
                        const SizedBox(width: KSizes.spaceBtwItems),
                        SearchWidget(),
                        const SizedBox(width: KSizes.spaceBtwItems),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.bars,
                              color: Colors.grey,
                            )),
                      ],
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
                    SizedBox(
                      height: KSizes.sm,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 44,
                      ),
                      child: Image.asset('assets/images/second_brain.png'),
                    ),
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

class HeaderButtons extends StatelessWidget {
  const HeaderButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeeklyCalendarController>();
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: 'تأكيد الحذف',
                content: Text(
                  'هل أنت متأكد أنك تريد حذف جميع المهام؟',
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                confirm: ElevatedButton(
                  onPressed: () {
                    controller.clearAllTasks();
                    Get.back();
                  },
                  child: Text('نعم'),
                ),
                cancel: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('إلغاء'),
                ),
              );
            },
            icon: Icon(FontAwesomeIcons.trash, color: Colors.red)),
        const SizedBox(width: KSizes.spaceBtwItems),
        IconButton(
          onPressed: () {
            controller.showAddTask.value = !controller.showAddTask.value;
            controller.showUpdateTask.value = false;
          },
          icon: Obx(() {
            return Icon(
              controller.showAddTask.value
                  ? FontAwesomeIcons.xmark
                  : FontAwesomeIcons.plus,
              color: controller.showAddTask.value ? Colors.red : Colors.blue,
            );
          }),
        ),
      ],
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 50,
      // padding: const EdgeInsets.all(KSizes.xs),
      decoration: BoxDecoration(
        color: KColors.darkModeSubCard,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextFormField(
                onFieldSubmitted: (value) {},
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 16,
                        color: KColors.grey,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(width: KSizes.spaceBtwItems),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: KColors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: KSizes.spaceBtwItems),
        ],
      ),
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
              if (widget.index == 1) {
                widget.controller.showFullWidthTask.value = true;
              } else {
                widget.controller.showFullWidthTask.value = false;
              }
              if (widget.index == 0 || widget.index == 1) {
                widget.controller.showAddTask.value = false;
                widget.controller.showUpdateTask.value = false;
              }
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
