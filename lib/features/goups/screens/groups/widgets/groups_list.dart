// import 'package:al_maafer/common/widgets/divider/divider.dart';
// import 'package:al_maafer/common/widgets/loaders/animation_loader.dart';
// import 'package:al_maafer/features/goups/controllers/groups_controller.dart';
// import 'package:al_maafer/utils/constants/colors.dart';
// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pull_down_button/pull_down_button.dart';
// import '../../../../../utils/constants/sizes.dart';
//
// class GroupsList extends StatelessWidget {
//   const GroupsList({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final GroupsController controller = Get.put(GroupsController());
//
//     return Obx(() {
//       if (controller.isLoading.value) {
//         return const TAnimationLoaderWidget(
//           text: 'جاري التحميل',
//           animation: 'assets/lottie/loading.json',
//         );
//       }
//       if (controller.groupsList.isEmpty) {
//         return const TAnimationLoaderWidget(
//           text: 'لا توجد مجموعات',
//           animation: 'assets/images/animations/53207-empty-file.json',
//         );
//       } else {
//         return
//
//           ReorderableListView(
//             onReorder: controller.reorderData,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: List.generate(
//                 controller.groupsList.length,
//                     (index) => Container(
//                       key: ValueKey(controller.groupsList[index].id),
//                       margin: const EdgeInsets.only(bottom: KSizes.md),
//                       decoration: BoxDecoration(
//                         color: KColors.darkContainer,
//                         border: Border.all(color: KColors.darkGrey),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: KColors.dark.withOpacity(0.5),
//                             spreadRadius: 1,
//                             blurRadius: 2,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: <Widget>[
//                           Container(
//                             padding:
//                             const EdgeInsets.symmetric(vertical: KSizes.sm + 2),
//                             decoration:  BoxDecoration(
//                             //  color: controller.groupsList[index].,
//                               color: controller.groupsList[index].color,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(15),
//                                 topRight: Radius.circular(15),
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Padding(
//                                   padding: EdgeInsets.only(right: KSizes.sm),
//                                   child: Icon(
//                                     Icons.dehaze_rounded,
//                                     color: Colors.transparent,
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: FittedBox(
//                                       child: Text(controller.groupsList[index].name,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headlineSmall!
//                                               .apply(
//                                             color: KColors.white,
//                                           )),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: KSizes.sm),
//                                   child: PullDownButton(
//                                     routeTheme: const PullDownMenuRouteTheme(
//                                       backgroundColor: KColors.dark,
//                                     ),
//                                     itemBuilder: (context) => [
//                                       PullDownMenuActionsRow.medium(
//                                         items: [
//                                           PullDownMenuItem(
//                                             onTap: () {
//                                               controller.showAddAndRemoveBottomSheet(
//                                                 isEdit: true,
//                                                 group: controller.groupsList[index],
//                                               );
//                                               //
//                                             },
//                                             title: 'تعديل',
//                                             icon: Icons.edit,
//                                           ),
//                                           PullDownMenuItem(
//                                             onTap: () {
//                                               controller.deleteGroup(
//                                                   controller.groupsList[index].id);
//                                             },
//                                             title: 'حذف',
//                                             isDestructive: true,
//                                             icon: Icons.delete,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                     buttonBuilder: (context, showMenu) =>
//                                         GestureDetector(
//                                           onTap: showMenu,
//                                           child: const Icon(
//                                             Icons.more_vert,
//                                           ),
//                                         ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: KSizes.sm,
//                           ),
//                           Container(
//                             margin: const EdgeInsets.symmetric(
//                               horizontal: KSizes.sm,
//                             ),
//                             decoration: BoxDecoration(
//                               color: KColors.darkContainer,
//                               border: Border.all(color: KColors.darkerGrey),
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: KColors.dark.withOpacity(0.5),
//                                   spreadRadius: 1,
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 2),
//                                 ),
//                               ],
//                             ),
//                             child: ExpandablePanel(
//                               theme: const ExpandableThemeData(
//                                 iconColor: KColors.primary,
//                                 iconSize: 25,
//                               ),
//                               header: Padding(
//                                 padding: const EdgeInsets.only(
//                                     right: 6 + KSizes.sm, top: KSizes.sm),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Text('عدد الطلاب',
//                                           textAlign: TextAlign.start,
//                                           style: Theme.of(context).textTheme.bodyLarge),
//                                     ),
//                                     Expanded(
//                                       child: Obx(
//                                             () => Text(
//                                             controller.groupsList[index].studentCount
//                                                 .toString(),
//                                             textAlign: TextAlign.end,
//                                             style:
//                                             Theme.of(context).textTheme.bodyLarge),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               expanded: Padding(
//                                 padding: const EdgeInsets.only(
//                                   right: KSizes.sm,
//                                   left: KSizes.sm,
//                                   bottom: KSizes.sm,
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     const KDivider(),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.symmetric(horizontal: 6),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text('سعر الشهر',
//                                                 textAlign: TextAlign.start,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyLarge),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                                 controller.groupsList[index].monthlyFee,
//                                                 textAlign: TextAlign.end,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyLarge),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const KDivider(),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.symmetric(horizontal: 6),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text('وقت الحصة',
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyLarge),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                                 controller
//                                                     .groupsList[index].sessionTime,
//                                                 textAlign: TextAlign.end,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyLarge),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const KDivider(),
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.symmetric(horizontal: 6),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text('ايام الحصة',
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyLarge),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                                 controller.groupsList[index].sessionDays
//                                                     .join(' - '),
//                                                 textAlign: TextAlign.end,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyLarge),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: KSizes.md,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               collapsed: const SizedBox(),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: KSizes.sm,
//                           ),
//                         ],
//                       ),
//                     )),
//           );
//       }
//     });
//   }
// }
