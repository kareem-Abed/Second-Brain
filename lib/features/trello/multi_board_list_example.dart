import 'package:flutter/material.dart';

import '../../appflowy_board/appflowy_board.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appflowy_board/appflowy_board.dart';
import 'package:get/get.dart';

class MultiBoardController extends GetxController {
  var groups = <AppFlowyGroupData>[].obs;

  void addGroup(AppFlowyGroupData group) {
    groups.add(group);
  }

  void addItemToGroup(String groupId, AppFlowyGroupItem item) {
    final group = groups.firstWhere((group) => group.id == groupId);
    group.items.add(item);
    groups.refresh();
  }
}


class MultiBoardListExample extends StatefulWidget {
  const MultiBoardListExample({Key? key}) : super(key: key);

  @override
  State<MultiBoardListExample> createState() => _MultiBoardListExampleState();
}

class _MultiBoardListExampleState extends State<MultiBoardListExample> {
  final MultiBoardController controller = Get.put(MultiBoardController());

  @override
  void initState() {
    super.initState();
    final group1 = AppFlowyGroupData(id: "To Do", name: "To Do", items: [
      TextItem("Card 1"),
      TextItem("Card 2"),
      RichTextItem(title: "Card 3", subtitle: 'Aug 1, 2020 4:05 PM'),
      TextItem("Card 4"),
      TextItem("Card 5"),
    ]);

    final group2 = AppFlowyGroupData(
      id: "Done",
      name: "Done",
      items: <AppFlowyGroupItem>[
        TextItem("Card 6 Card 6 Card 6 Card 6 Card 6 Card 6 Card 6 "),
        RichTextItem(title: "Card 7", subtitle: 'Aug 1, 2020 4:05 PM'),
        RichTextItem(title: "Card 8", subtitle: 'Aug 1, 2020 4:05 PM'),
      ],
    );

    final group3 = AppFlowyGroupData(
        id: "Doneing",
        name: "Doneing",
        customData: "Custom Data",
        items: <AppFlowyGroupItem>[
          TextItem("Card 14"),
          TextItem("Card 15"),
        ]);

    controller.addGroup(group1);
    controller.addGroup(group2);
    controller.addGroup(group3);
    controller.addItemToGroup(group1.id, TextItem("كريم احمد"));
  }

  void addItemToGroup(String groupId, String title) {
    controller.addItemToGroup(groupId, TextItem("   كريم احمد$title "));
  }

  @override
  Widget build(BuildContext context) {
    final config = AppFlowyBoardConfig(
      groupBackgroundColor: HexColor.fromHex('#1E1E1E'),
      stretchGroupHeight: false,
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Obx(() {
          return AppFlowyBoard(
            controller: AppFlowyBoardController(
              // groups: controller.groups,
              onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
                debugPrint('Move item from $fromIndex to $toIndex');
              },
              onMoveGroupItem: (groupId, fromIndex, toIndex) {
                debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
              },
              onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
                debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
              },
            ),
            cardBuilder: (context, group, groupItem) {
              return AppFlowyGroupCard(
                key: ValueKey(groupItem.id),
                margin: const EdgeInsets.only(bottom: 10),
                child: _buildCard(groupItem),
                decoration: BoxDecoration(
                  color: HexColor.fromHex('#2C2C2C'),
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            },
            boardScrollController: AppFlowyBoardScrollController(),
            footerBuilder: (context, columnData) {
              return AppFlowyGroupFooter(
                icon: const Icon(Icons.add, size: 20, color: Colors.white),
                title: InkWell(
                  onTap: () {
                    addItemToGroup(columnData.id, 'كريم احمد');
                  },
                  child: const Text('اضافة', style: TextStyle(color: Colors.white)),
                ),
                height: 50,
                margin: config.groupBodyPadding,
                onAddButtonClick: () {
                  AppFlowyBoardScrollController().scrollToBottom(columnData.id);
                },
              );
            },
            headerBuilder: (context, columnData) {
              return AppFlowyGroupHeader(
                icon: const Icon(Icons.lightbulb_circle, color: Colors.blue),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    columnData.headerData.groupName,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                height: 50,
                margin: config.groupBodyPadding,
              );
            },
            groupConstraints: const BoxConstraints.tightFor(width: 240),
            config: config,
          );
        }),
      ),
    );
  }

  Widget _buildCard(AppFlowyGroupItem item) {
    if (item is TextItem) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Text(item.s, style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    if (item is RichTextItem) {
      return RichTextCard(item: item);
    }

    throw UnimplementedError();
  }
}
// class MultiBoardListExample extends StatefulWidget {
//   const MultiBoardListExample({Key? key}) : super(key: key);
//
//   @override
//   State<MultiBoardListExample> createState() => _MultiBoardListExampleState();
// }
//
// class _MultiBoardListExampleState extends State<MultiBoardListExample> {
//   AppFlowyBoardController controller = AppFlowyBoardController(
//     onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
//       debugPrint('Move item from $fromIndex to $toIndex');
//     },
//     onMoveGroupItem: (groupId, fromIndex, toIndex) {
//       debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
//     },
//     onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
//       debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
//     },
//   );
//
//   late AppFlowyBoardScrollController boardController;
//
//   @override
//   void initState() {
//     super.initState();
//     boardController = AppFlowyBoardScrollController();
//     final group1 = AppFlowyGroupData(id: "To Do", name: "To Do", items: [
//       TextItem("Card 1"),
//       TextItem("Card 2"),
//       RichTextItem(title: "Card 3", subtitle: 'Aug 1, 2020 4:05 PM'),
//       TextItem("Card 4"),
//       TextItem("Card 5"),
//     ]);
//
//     final group2 = AppFlowyGroupData(
//       id: "Done",
//       name: "Done",
//       items: <AppFlowyGroupItem>[
//         TextItem("Card 6 Card 6 Card 6 Card 6 Card 6 Card 6 Card 6 "),
//         RichTextItem(title: "Card 7", subtitle: 'Aug 1, 2020 4:05 PM'),
//         RichTextItem(title: "Card 8", subtitle: 'Aug 1, 2020 4:05 PM'),
//       ],
//     );
//
//     final group3 = AppFlowyGroupData(
//         id: "Doneing",
//         name: "Doneing",
//         customData: "Custom Data",
//         items: <AppFlowyGroupItem>[
//           TextItem("Card 14"),
//           TextItem("Card 15"),
//         ]);
//
//     controller.addGroup(group1);
//     controller.addGroup(group2);
//     controller.addGroup(group3);
// // print(controller.items[0].);
//     controller.addGroupItem(group1.id, TextItem("كريم احمد"));
//   }
//
//   void addItemToGroup(String groupId, String title) {
//     setState(() {
//       final group = controller.items.firstWhere((group) => group.id == groupId);
//       // group.addGroupItem(newItem);
//       controller.addGroupItem(groupId, TextItem("   كريم احمد$title "));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final config = AppFlowyBoardConfig(
//       groupBackgroundColor: HexColor.fromHex('#1E1E1E'),
//       stretchGroupHeight: false,
//     );
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 20.0),
//         child: AppFlowyBoard(
//             controller: controller,
//             cardBuilder: (context, group, groupItem) {
//               return AppFlowyGroupCard(
//                 key: ValueKey(groupItem.id),
//                 margin: const EdgeInsets.only(bottom: 10),
//                 child: _buildCard(groupItem),
//                 decoration: BoxDecoration(
//                   color: HexColor.fromHex('#2C2C2C'),
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//               );
//             },
//             boardScrollController: boardController,
//             footerBuilder: (context, columnData) {
//               return AppFlowyGroupFooter(
//                 icon: const Icon(Icons.add, size: 20, color: Colors.white),
//                 title:
//                     InkWell(
//                         onTap: () {
//                           addItemToGroup(columnData.id, 'كريم احمد');
//                         },
//                         child: const Text('اضافة', style: TextStyle(color: Colors.white))),
//                 height: 50,
//                 margin: config.groupBodyPadding,
//                 onAddButtonClick: () {
//                   boardController.scrollToBottom(columnData.id);
//                 },
//               );
//             },
//             headerBuilder: (context, columnData) {
//               return AppFlowyGroupHeader(
//                 icon: const Icon(Icons.lightbulb_circle, color: Colors.blue),
//                 title: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     columnData.headerData.groupName,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 // addIcon: const Icon(Icons.add, size: 20, color: Colors.white),
//                 // moreIcon:
//                 // const Icon(Icons.more_horiz, size: 20, color: Colors.white),
//                 height: 50,
//                 margin: config.groupBodyPadding,
//               );
//             },
//             groupConstraints: const BoxConstraints.tightFor(width: 240),
//             config: config),
//       ),
//     );
//   }
//
//   Widget _buildCard(AppFlowyGroupItem item) {
//     if (item is TextItem) {
//       return Align(
//         alignment: Alignment.centerLeft,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Text(item.s, style: const TextStyle(color: Colors.white)),
//         ),
//       );
//     }
//
//     if (item is RichTextItem) {
//       return RichTextCard(item: item);
//     }
//
//     throw UnimplementedError();
//   }
// }

class RichTextCard extends StatefulWidget {
  final RichTextItem item;
  const RichTextCard({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<RichTextCard> createState() => _RichTextCardState();
}

class _RichTextCardState extends State<RichTextCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item.title,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            Text(
              widget.item.subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

class TextItem extends AppFlowyGroupItem {
  final String s;

  TextItem(this.s);

  @override
  String get id => s;
}

class RichTextItem extends AppFlowyGroupItem {
  final String title;
  final String subtitle;

  RichTextItem({required this.title, required this.subtitle});

  @override
  String get id => title;
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
