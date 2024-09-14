import 'package:al_maafer/features/trello/multi_board_list_example.dart';
import 'package:al_maafer/features/trello/trello.dart';
import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/weekly_calendar.dart';
import 'package:al_maafer/main.dart';
import 'package:al_maafer/time_planer/src/time_planner.dart';
import 'package:al_maafer/utils/constants/colors.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'trello_bord/presentation/widgets/kanban_board.dart';

class EasySideMenu extends StatefulWidget {
  const EasySideMenu({Key? key}) : super(key: key);

  @override
  _easySideMenuState createState() => _easySideMenuState();
}

class _easySideMenuState extends State<EasySideMenu> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      controller.iconIndex.value = index;
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  final controller = Get.put(WeeklyCalendarController());
  final timeController = Get.put(TimePlannerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const WeeklyCalendarScreen(
                    viewCurrentDayOnly: false,
                  ),
                  const WeeklyCalendarScreen(
                    viewCurrentDayOnly: true,
                  ),
                  // MultiBoardListExample(),
                  // TrelloBoard(),

                  KanbanBoard(),
                  Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        'إعدادات',
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const VerticalDivider(width: 0, color: Colors.white),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: KColors.darkModeSideMenuBackground,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset: Offset(
                      5,
                      2,
                    ),
                  )
                ],
              ),
              child: SideMenu(
                controller: sideMenu,
                style: SideMenuStyle(
                  displayMode: SideMenuDisplayMode.compact,
                  showHamburger: false,
                  itemOuterPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  hoverColor: Colors.blue[200],
                  selectedHoverColor: Colors.blue[200],
                  selectedColor: Colors.lightBlue,
                  selectedTitleTextStyle: const TextStyle(color: Colors.white),
                  unselectedTitleTextStyle:
                      const TextStyle(color: Colors.white),
                  selectedIconColor: Colors.white,
                  unselectedIconColor: Colors.white,
                  selectedIconColorExpandable: Colors.white,
                  unselectedIconColorExpandable: Colors.white,
                  arrowOpen: Colors.white,
                  arrowCollapse: Colors.white,
                  backgroundColor: KColors.darkModeSideMenuBackground,
                  toggleColor: Colors.white,
                ),
                title: Column(
                  children: [
                    Obx(() {
                      final currentHour = timeController.currentHour.value;
                      final image = currentHour >= 6 && currentHour < 18
                          ? 'assets/images/sun.png'
                          : 'assets/images/moon.png';

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

                      final timeOfDayText = getTimePeriod(currentHour);

                      return Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 150,
                              maxWidth: 150,
                            ),
                            child: Image.asset(image),
                          ),
                          FittedBox(
                            child: Text(
                              timeOfDayText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }),
                    const Divider(
                      indent: 8.0,
                      endIndent: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
                items: [
                  SideMenuItem(
                    title: 'اسبوع',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                      controller.showFullWidthTask.value = false;
                    },
                    iconWidget: Obx(
                      () => Icon(FontAwesomeIcons.calendar,
                          color: controller.iconIndex.value == 0
                              ? Colors.white
                              : Colors.grey),
                    ),
                  ),
                  SideMenuItem(
                    title: 'يوم',
                    onTap: (index, _) {
                      sideMenu.changePage(index);

                      controller.showFullWidthTask.value = true;
                    },
                    iconWidget: Obx(
                      () => Icon(Icons.calendar_view_day,
                          color: controller.iconIndex.value == 1
                              ? Colors.white
                              : Colors.grey),
                    ),
                  ),
                  SideMenuItem(
                    title: 'مهام',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    iconWidget: Obx(
                      () => Icon(FontAwesomeIcons.tableColumns,
                          color: controller.iconIndex.value == 2
                              ? Colors.white
                              : Colors.grey),
                    ),
                  ),
                  SideMenuItem(
                    builder: (context, displayMode) {
                      return const Divider(
                        endIndent: 8,
                        indent: 8,
                        color: Colors.white,
                      );
                    },
                  ),
                  SideMenuItem(
                    title: 'إعدادات',
                    onTap: (index, _) {
                      sideMenu.changePage(index);
                    },
                    iconWidget: Obx(
                      () => Icon(Icons.settings,
                          color: controller.iconIndex.value == 4
                              ? Colors.white
                              : Colors.grey),
                    ),
                  ),
                  SideMenuItem(
                    title: 'الخروج',
                    iconWidget: Icon(Icons.exit_to_app, color: Colors.grey),
                    // icon: Icon(Icons.exit_to_app, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // backgroundColor: Colors.grey[900],
      // backgroundColor: KColors.darkModeSideMenuBackground,
    );
  }
}