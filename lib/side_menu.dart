import 'package:al_maafer/features/weekly_calendar/controllers/weekly_calendar_controller.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/weekly_calendar.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  final controller = Get.put(WeeklyCalendarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
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
                Container(
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'مهام',
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ),
                ),
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
          const VerticalDivider(width: 0, color: Colors.white),
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.compact,
              showHamburger: false,
              itemOuterPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 6),
              hoverColor: Colors.blue[200],
              selectedHoverColor: Colors.blue[200],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              unselectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              unselectedIconColor: Colors.white,
              selectedIconColorExpandable: Colors.white,
              unselectedIconColorExpandable: Colors.white,
              arrowOpen: Colors.white,
              arrowCollapse: Colors.white,
              toggleColor: Colors.white,
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'assets/images/moon.png',
                  ),
                ),
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
                icon: Icon(FontAwesomeIcons.calendar, color: Colors.white),
                // iconWidget: Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //         child: Icon(
                //       FontAwesomeIcons.calendar,
                //       color: Colors.white,
                //       size: 18,
                //     )),
                //     Expanded(
                //       child: FittedBox(
                //         child: Text(
                //           'اسبوع',
                //           style: const TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
              SideMenuItem(
                title: 'يوم',
                onTap: (index, _) {
                  sideMenu.changePage(index);

                  controller.showFullWidthTask.value = true;
                },
                icon: const Icon(Icons.calendar_view_day, color: Colors.white),
                // iconWidget: Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //         child: Icon(
                //       FontAwesomeIcons.calendarDay,
                //       color: Colors.white,
                //       size: 19,
                //     )),
                //     Expanded(
                //       child: FittedBox(
                //         child: Text(
                //           '  يوم  ',
                //           style: const TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
              SideMenuItem(
                title: 'مهام',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                icon:
                const Icon(FontAwesomeIcons.listCheck, color: Colors.white),
                // iconWidget: Column(
                //   children: [
                //     Expanded(
                //         child: const Icon(
                //       FontAwesomeIcons.listCheck,
                //       color: Colors.white,
                //       size: 19,
                //     )),
                //     Expanded(
                //       child: FittedBox(
                //         child: Text(
                //           'مهام',
                //           style: const TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
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
                icon: const Icon(Icons.settings, color: Colors.white),
              ),
              const SideMenuItem(
                title: 'الخروج',
                icon: Icon(Icons.exit_to_app, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}