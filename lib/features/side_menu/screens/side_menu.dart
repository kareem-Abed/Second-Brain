import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/habit/screens/habit_screen.dart';
import 'package:second_brain/features/pomodoro/screens/pomodoro.dart';
import 'package:second_brain/features/side_menu/screens/widgets/header_buttons.dart';
import 'package:second_brain/features/side_menu/screens/widgets/hoverable_menu_item.dart';
import 'package:second_brain/features/side_menu/screens/widgets/search_widget.dart';
import 'package:second_brain/features/weekly_calendar/screens/weekly_calendar/weekly_calendar.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import '../../trello_bord/screens/widgets/kanban_board.dart';
import '../controller/side_menu_controller.dart';

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({Key? key}) : super(key: key);

  @override
  _CustomSideMenuState createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      HeaderWidget(),
                      PageViewWidget(),
                    ],
                  ),
                ),
                SideMenuWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageViewWidget extends StatelessWidget {
  PageViewWidget({
    super.key,
  });

  final sideMenuController = Get.find<SideMenuController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: sideMenuController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            color: KColors.darkModeBackground,
            child: const Center(
              child: Text(
                'Dashboard',
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
          ),
          const WeeklyCalendarScreen(viewCurrentDayOnly: false),
          const WeeklyCalendarScreen(viewCurrentDayOnly: true),
          KanbanBoard(),
          Pomodoro(),
          HabitScreen(),
          Container(
            color: KColors.darkModeBackground,
            child: const Center(
              child: Text(
                'إعدادات',
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KColors.darkModeSideMenuBackground,
      ),
      height: 70,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              IconsaxPlusLinear.arrow_circle_down,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'Second Brain',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 16,
          ),
          CircleAvatar(
            radius: 24,
            backgroundImage: const AssetImage('assets/images/second_brain.png'),
          ),
          SizedBox(
            width: 16,
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                IconsaxPlusBold.notification_bing,
                color: KColors.primary,
              )),
          Spacer(),
          HeaderButtons(),
          const SizedBox(width: KSizes.spaceBtwItems),
          SearchWidget(),
          const SizedBox(width: KSizes.sm),
        ],
      ),
    );
  }
}

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        color: KColors.darkModeSideMenuBackground,
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
            HoverableMenuItem(
              icon: IconsaxPlusBold.category,
              title: 'Dashboard',
              index: 0,
            ),
            HoverableMenuItem(
              icon: IconsaxPlusBold.calendar,
              title: 'اسبوع',
              index: 1,
            ),
            HoverableMenuItem(
              icon: IconsaxPlusBold.code,
              title: 'يوم',
              index: 2,
            ),
            // _buildMenuItem(
            //   icon: IconsaxPlusLinear.task_square,
            //   title: 'مهام',
            //   index: 3,
            // ),
            HoverableMenuItem(
              icon: IconsaxPlusBold.task_square,
              title: 'مهام',
              index: 3,
            ),
            HoverableMenuItem(
              icon: IconsaxPlusBold.clock,
              title: 'Pomodoro ',
              index: 4,
            ),
            HoverableMenuItem(
              icon: IconsaxPlusBold.tree,
              title: 'العادات',
              index: 5,
            ),
            HoverableMenuItem(
              icon: IconsaxPlusBold.setting_2,
              title: 'إعدادات',
              index: 6,
            ),
            SizedBox(
              height: 58,
            ),
            HoverableMenuItem(
              icon: IconsaxPlusLinear.arrow_square_left,
              title: 'الخروج',
              index: 7,
              exit: true,
            ),
          ],
        ),
      ),
    );
  }
}
