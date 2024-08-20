
// import 'package:al_maafer/features/nick_names/screens/nick_names_years/nick_names_years.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:al_maafer/utils/constants/colors.dart';
// import 'package:al_maafer/utils/helpers/helper_functions.dart';
// import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';
//
//
// class NavigationMenu extends StatelessWidget {
//   const NavigationMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NavigationController());
//     final darkMode = KHelperFunctions.isDarkMode(context);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: PersistentTabView(
//         context,
//         controller: controller.persistentTabController,
//         screens: controller.screens,
//         items: _navBarsItems(),
//         confineInSafeArea: false,
//         backgroundColor: darkMode ? KColors.black :  KColors.white ,
//         handleAndroidBackButtonPress: true,
//         resizeToAvoidBottomInset: true,
//         stateManagement: true,
//         hideNavigationBarWhenKeyboardShows: true,
//         decoration: NavBarDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           colorBehindNavBar: darkMode ? KColors.black : Colors.white,
//         ),
//         popAllScreensOnTapOfSelectedTab: true,
//         popAllScreensOnTapAnyTabs: true,
//         itemAnimationProperties: const ItemAnimationProperties(
//           duration: Duration(milliseconds: 200),
//           curve: Curves.ease,
//         ),
//         screenTransitionAnimation: const ScreenTransitionAnimation(
//           animateTabTransition: false,
//           curve: Curves.ease,
//           duration: Duration(milliseconds: 200),
//         ),
//         navBarStyle: NavBarStyle.style6,
//       ),
//     );
//   }
//
//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     return [
//       PersistentBottomNavBarItem(
//         icon: const Icon(Iconsax.personalcard),
//         title: ("الألقاب"),
//         activeColorPrimary: KColors.primary,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Iconsax.bank),
//         title: ("الحساب"),
//         activeColorPrimary: KColors.primary,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Iconsax.people),
//         title: ("المجموعات"),
//         activeColorPrimary: KColors.primary,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(
//           Iconsax.add,
//         ),
//         title: ("اضافة طالب"),
//         activeColorPrimary: KColors.primary,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Iconsax.search_normal),
//         title: ("بحث"),
//         activeColorPrimary: KColors.primary,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//       PersistentBottomNavBarItem(
//         icon: const Icon(Iconsax.setting_2),
//         title: ("الإعدادات"),
//         activeColorPrimary: KColors.primary,
//         inactiveColorPrimary: CupertinoColors.systemGrey,
//       ),
//     ];
//   }
// }
//
// class NavigationController extends GetxController {
//   final RxInt selectedIndex = 0.obs;
//
//   static NavigationController get instance => Get.find();
//   final PersistentTabController persistentTabController =
//       PersistentTabController(initialIndex: 0);
//
//   final List<Widget> screens = [
//     const NickNameScreen(),
//     const ComingSoon(),
//     //const MonthsScreen(),
//     const ComingSoon(),
//     const ComingSoon(),
//
//     // const AddScreen(),
//     const ComingSoon(),
//     const ComingSoon(),
//   ];
// }
