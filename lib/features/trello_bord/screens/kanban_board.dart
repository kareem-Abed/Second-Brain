import 'dart:math';

import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:second_brain/features/trello_bord/controller/kanban_board_controller.dart';

import 'package:second_brain/features/trello_bord/models/item.dart';
import 'package:second_brain/utils/constants/colors.dart';

class KanbanBoard extends StatelessWidget {
  final double tileHeight = 100;
  final double headerHeight = 80;
  final double tileWidth = 300;
  final KanbanController kanbanController = Get.put(KanbanController());

  @override
  Widget build(BuildContext context) {
    buildKanbanList(String listId, List<Item> items) {
      return DragTarget<String>(
        onWillAccept: (String? incomingListId) => true,
        onAccept: (String incomingListId) {
          kanbanController.reorderLists(listId, incomingListId);
        },
        builder: (BuildContext context, List<String?> data,
            List<dynamic> rejectedData) {
          return Container(
            // width: tileWidth,
            // color: Colors.grey[300],
            margin: EdgeInsets.all(16),
            child: buildColumns(listId, items),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      // appBar: AppBar(title: Text("Kanban test")),
      body: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: kanbanController.board.value.keys.map((String key) {
                return Container(
                  width: tileWidth,
                  child:
                      buildKanbanList(key, kanbanController.board.value[key]!),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  buildColumns(String listId, List<Item> items) {
    return Draggable<String>(
      data: listId,
      childWhenDragging: Opacity(
        opacity: 0.2,
        child: Container(
          width: tileWidth,
          color: Colors.green,
          child: Column(
            children: [
              Container(
                height: headerHeight,
                child: HeaderWidget(title: listId),
              ),
              ...items
                  .map((item) => Container(
                        height: tileHeight,
                        child: ItemWidget(item: item),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
      feedback: Opacity(
        opacity: 0.8,
        child: Transform.rotate(
          angle: 0.1, // الزاوية لإظهار الميلان
          child: Container(
            width: tileWidth,
            color: Colors.green,
            child: Column(
              children: [
                Container(
                  height: headerHeight,
                  child: HeaderWidget(title: listId),
                ),
                ...items
                    .map((item) => Container(
                          height: tileHeight,
                          child: ItemWidget(item: item),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              DragTarget<Item>(
                onWillAccept: (Item? data) {
                  return data != null &&
                      (kanbanController.board.value[listId]!.isEmpty ||
                          data.id !=
                              kanbanController.board.value[listId]?[0].id);
                },
                onAccept: (Item data) {
                  kanbanController.moveItem(data, listId, 0);
                },
                builder: (BuildContext context, List<Item?> data,
                    List<dynamic> rejectedData) {
                  if (data.isEmpty) {
                    return Container(
                      height: headerHeight,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: HeaderWidget(title: listId),
                    );
                  } else {
                    return Column(
                      children: [
                        Container(
                          height: headerHeight,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: HeaderWidget(title: listId),
                        ),
                        ...data.map((Item? item) {
                          return Opacity(
                            opacity: 0.5,
                            child: ItemWidget(item: item!),
                          );
                        }).toList(),
                      ],
                    );
                  }
                },
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Draggable<Item>(
                        data: items[index],
                        child: ItemWidget(item: items[index]),
                        // childWhenDragging: Opacity(
                        //   opacity: 0.2,
                        //   child: ItemWidget(item: items[index]),
                        // ),
                        feedback: Container(
                          height: tileHeight,
                          width: tileWidth,
                          color: Colors.purple,
                          child: FloatingWidget(
                            child: ItemWidget(item: items[index]),
                          ),
                        ),
                      ),
                      buildItemDragTarget(listId, index, tileHeight),
                    ],
                  );
                },
              ),
              DragTarget<Item>(
                onWillAccept: (Item? data) {
                  return data != null &&
                      (kanbanController.board.value[listId]!.isEmpty ||
                          data.id !=
                              kanbanController.board.value[listId]?[0].id);
                },
                onAccept: (Item data) {
                  kanbanController.moveItem(data, listId, 0);
                },
                builder: (BuildContext context, List<Item?> data,
                    List<dynamic> rejectedData) {
                  if (data.isEmpty) {
                    return Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        ...data.map((Item? item) {
                          return Opacity(
                            opacity: 0.5,
                            child: ItemWidget(item: item!),
                          );
                        }).toList(),
                        Container(
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildItemDragTarget(String listId, int targetPosition, double height) {
    return DragTarget<Item>(
      onWillAccept: (Item? data) {
        return data != null &&
            (kanbanController.board.value[listId]!.isEmpty ||
                data.id !=
                    kanbanController.board.value[listId]?[targetPosition].id);
      },
      onAccept: (Item data) {
        kanbanController.moveItem(data, listId, targetPosition);
      },
      builder:
          (BuildContext context, List<Item?> data, List<dynamic> rejectedData) {
        if (data.isEmpty) {
          return Container(
            height: height,
          );
        } else {
          return Column(
            children: [
              Container(
                height: height,
              ),
              ...data.map((Item? item) {
                return Opacity(
                  opacity: 0.5,
                  child: ItemWidget(item: item!),
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String title;

  const HeaderWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal,
      child: ListTile(
        dense: true,
        title: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final Item item;

  const ItemWidget({Key? key, required this.item}) : super(key: key);

  ListTile makeListTile(Item item) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          item.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text("listId: ${item.listId}"),
        onTap: () {},
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(64, 75, 96, .9),
        ),
        child: makeListTile(item),
      ),
    );
  }
}

class FloatingWidget extends StatelessWidget {
  final Widget child;

  const FloatingWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.1,
      child: child,
    );
  }
}
