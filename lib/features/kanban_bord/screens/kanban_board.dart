import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:second_brain/features/kanban_bord/controller/kanban_board_controller.dart';
import 'package:second_brain/features/kanban_bord/models/item.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/add_item_button.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/add_list_button.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/floating_widget.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/header_widget.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/item_widget.dart';
import 'package:second_brain/utils/constants/colors.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _KanbanBoardState createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final double tileHeight = 100;
  final double headerHeight = 80;
  final double tileWidth = 300;
  // final KanbanController kanbanController = Get.put(KanbanController(boardGetStorageKey: 'board', listNamesGetStorageKey: 'listNames'));
  final KanbanController kanbanController = KanbanController.instance;

  void setActiveColumn(String columnId) {
    setState(() {
      kanbanController.showListNameTextField.value = false;
      kanbanController.activeListId.value = columnId;
      kanbanController.itemNameController.value.clear();
      kanbanController.showItemNameTextField.value = true;
    });
    kanbanController.focusItemName();
  }

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
          return buildColumns(listId, items);
        },
      );
    }

    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: SizedBox(
            height: double.infinity,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const AddListButton(),
              ...kanbanController.board.value.keys
                  .toList()
                  .reversed
                  .map((String key) {
                return Container(
                  width: tileWidth,
                  margin: const EdgeInsets.all(8.0),
                  child:
                      buildKanbanList(key, kanbanController.board.value[key]!),
                );
              }).toList(),
              const SizedBox(width: 8.0),
            ]),
          ),
        ),
      ),
    );
  }

  buildColumns(String listId, List<Item> items) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Draggable<String>(
            data: listId,
            onDragStarted: () {
              kanbanController.isDragging.value = true;
              kanbanController.draggingListId.value = listId;
            },
            onDragEnd: (details) {
              kanbanController.isDragging.value = false;
              kanbanController.draggingListId.value = '';
            },
            //----------------- --------------
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: Container(
                width: tileWidth,
                decoration: BoxDecoration(
                  color: KColors.darkModeCard,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    HeaderWidget(
                      controller: kanbanController,
                      listId: listId,
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.all(0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ItemWidget(
                            item: items[index], controller: kanbanController);
                      },
                    ),
                    AddItemButton(
                      onActivate: () => setActiveColumn(listId),
                      listId: listId,
                    )
                  ],
                ),
              ),
            ),

            feedback: Opacity(
              opacity: 0.8,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  width: tileWidth,
                  decoration: BoxDecoration(
                    color: KColors.darkModeCard,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      HeaderWidget(
                        controller: kanbanController,
                        listId: listId,
                      ),
                      ...items
                          .map((item) => ItemWidget(
                              item: item, controller: kanbanController))
                          .toList(),
                      Card(
                        elevation: 0,
                        child: Container(
                            decoration: BoxDecoration(
                              color: KColors.darkModeCard,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('Add another list'),
                                SizedBox(width: 8.0),
                                Icon(Icons.add),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //----------------- --------------
            child: Container(
              decoration: const BoxDecoration(
                color: KColors.darkModeCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
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
                      kanbanController.moveItem(data, listId, -1);
                    },
                    builder: (BuildContext context, List<Item?> data,
                        List<dynamic> rejectedData) {
                      if (data.isEmpty) {
                        return HeaderWidget(
                          controller: kanbanController,
                          listId: listId,
                        );
                      } else {
                        return Column(
                          children: [
                            HeaderWidget(
                              controller: kanbanController,
                              listId: listId,
                            ),
                            ...data.map((Item? item) {
                              return Opacity(
                                opacity: 0.5,
                                child: ItemWidget(
                                    item: item!, controller: kanbanController),
                              );
                            }).toList(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Obx(() => kanbanController.isDragging.value &&
                  kanbanController.draggingListId.value == listId
              ? Container()
              : Container(
                  decoration: const BoxDecoration(
                    color: KColors.darkModeCard,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              Draggable<Item>(
                                data: items[index],
                                childWhenDragging: Opacity(
                                  opacity: 0.2,
                                  child: ItemWidget(
                                      item: items[index],
                                      controller: kanbanController),
                                ),
                                feedback: SizedBox(
                                  width: tileWidth,
                                  child: FloatingWidget(
                                    child: ItemWidget(
                                        item: items[index],
                                        controller: kanbanController),
                                  ),
                                ),
                                child: ItemWidget(
                                    item: items[index],
                                    showHover: true,
                                    controller: kanbanController),
                              ),
                              DragTarget<Item>(
                                onWillAccept: (Item? data) {
                                  return data != null &&
                                      (kanbanController
                                              .board.value[listId]!.isEmpty ||
                                          data.id !=
                                              kanbanController.board
                                                  .value[listId]?[index].id);
                                },
                                onAccept: (Item data) {
                                  kanbanController.moveItem(
                                      data, listId, index);
                                },
                                builder: (BuildContext context,
                                    List<Item?> data,
                                    List<dynamic> rejectedData) {
                                  if (data.isEmpty) {
                                    return IgnorePointer(
                                      ignoring: true,
                                      child: Card(
                                        color: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        child: Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.transparent,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 10.0),
                                          child: Text(
                                            items[index].title,
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        IgnorePointer(
                                          ignoring: true,
                                          child: Card(
                                            color: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            surfaceTintColor:
                                                Colors.transparent,
                                            child: Container(
                                              width: 300,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 10.0),
                                              child: Text(
                                                items[index].title,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.transparent),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...data.map((Item? item) {
                                          return Opacity(
                                            opacity: 0.5,
                                            child: ItemWidget(
                                                item: item!,
                                                controller: kanbanController),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      DragTarget<Item>(
                        onWillAccept: (Item? data) {
                          return data != null &&
                              (kanbanController.board.value[listId]!.isEmpty ||
                                  data.id !=
                                      kanbanController
                                          .board.value[listId]?[0].id);
                        },
                        onAccept: (Item data) {
                          kanbanController.moveItem(data, listId, 0);
                        },
                        builder: (BuildContext context, List<Item?> data,
                            List<dynamic> rejectedData) {
                          if (data.isEmpty) {
                            return AddItemButton(
                              onActivate: () => setActiveColumn(listId),
                              listId: listId,
                            );
                          } else {
                            return Column(
                              children: [
                                ...data.map((Item? item) {
                                  return Opacity(
                                    opacity: 0.5,
                                    child: ItemWidget(
                                        item: item!,
                                        controller: kanbanController),
                                  );
                                }).toList(),
                                Container(
                                    decoration: BoxDecoration(
                                      color: KColors.darkModeCard,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Add another list'),
                                        SizedBox(width: 8.0),
                                        Icon(Icons.add),
                                      ],
                                    )),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )),
        ],
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
                  child: ItemWidget(item: item!, controller: kanbanController),
                );
              }).toList(),
            ],
          );
        }
      },
    );
  }
}
