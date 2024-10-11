import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/features/kanban_bord/models/item.dart';


class KanbanController extends GetxController {
  Rx<LinkedHashMap<String, List<Item>>> board =
      LinkedHashMap<String, List<Item>>().obs;
  RxMap<String, String> listNames = <String, String>{}.obs;
  final box = GetStorage();
  var isDragging = false.obs;
  var draggingListId = ''.obs;
  final listNameController = TextEditingController().obs;
  var listNameFocusNode = FocusNode().obs;

  final ItemNameController = TextEditingController().obs;
  final ItemNameFocusNode = FocusNode().obs;
  final RxBool ShowListNameTextField = false.obs;
  final RxBool ShowItemNameTextField = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadBoardState();
  }

  void focusItemName() {
    // ItemNameFocusNode.value.unfocus();
    // listNameFocusNode.value.unfocus();
    ItemNameFocusNode.value.requestFocus();
  }

  void loadBoardState() {
    final storedBoard = box.read('board');
    final storedListNames = box.read('listNames');

    if (storedBoard != null && storedListNames != null) {
      board.value = LinkedHashMap<String, List<Item>>.from(
        (storedBoard as Map).map((key, value) => MapEntry(
              key,
              (value as List).map((item) => Item.fromJson(item)).toList(),
            )),
      );
      listNames.value = Map<String, String>.from(storedListNames);
    } else {
      // Initialize the board with default values
      board.value.addAll({
        "1": [
          Item(id: "1", listId: "1", title: "Pear"),
          Item(id: "2", listId: "1", title: "Potato"),
          Item(id: "3", listId: "1", title: "Tomato"),
        ],
        "2": [
          Item(id: "4", listId: "2", title: "Car"),
          Item(id: "5", listId: "2", title: "Bicycle"),
          Item(id: "6", listId: "2", title: "On foot"),
        ],
        "3": [
          Item(id: "7", listId: "3", title: "Chile"),
          Item(id: "8", listId: "3", title: "Madagascar"),
          Item(id: "9", listId: "3", title: "Japan"),
        ],
      });

      listNames.addAll({
        "1": "Fruits",
        "2": "Transport",
        "3": "Countries",
      });
    }
  }

  void saveBoardState() {
    box.write(
        'board',
        board.value.map((key, value) => MapEntry(
              key,
              value.map((item) => item.toJson()).toList(),
            )));
    box.write('listNames', listNames);
  }

  void editItem(String itemId, String newTitle) {
    board.value.forEach((listId, items) {
      final item = items.firstWhere(
        (item) => item.id == itemId,
        orElse: () => Item(id: '', listId: '', title: ''),
      );
      if (item.id.isNotEmpty) {
        item.title = newTitle;
        board.refresh();
        saveBoardState();
        return;
      }
    });
  }

  void addItem(String listId, String itemName) {
    String itemId = DateTime.now().millisecondsSinceEpoch.toString();
    Item newItem = Item(id: itemId, listId: listId, title: itemName);

    if (board.value.containsKey(listId)) {
      board.value[listId]?.add(newItem);
      board.refresh();
      saveBoardState();
    } else {
      print('listId: $listId not found in board');
    }
  }

  void addList(String listName) {
    String listId = DateTime.now().millisecondsSinceEpoch.toString();
    if (!board.value.containsKey(listId)) {
      board.value[listId] = [];
      listNames[listId] = listName;
      board.refresh();
      listNames.refresh();
      saveBoardState();
    } else {
      print('listId: $listId already exists in board');
    }
  }

  void removeItem(String listId, String itemId) {
    if (!board.value.containsKey(listId)) {
      print('Error: listId: $listId not found in board');
      return;
    }

    final items = board.value[listId];
    if (items == null || items.isEmpty) {
      print('Error: No items found for listId: $listId');
      return;
    }

    final initialLength = items.length;
    items.removeWhere((item) => item.id == itemId);
    final itemRemoved = items.length < initialLength;

    if (itemRemoved) {
      board.refresh();
      saveBoardState();
      print('Item removed successfully');
    } else {
      print('Error: itemId: $itemId not found in listId: $listId');
    }
  }

  void renameColumn(String listId, String newName) {
    listNames[listId] = newName;
    listNames.refresh();
    saveBoardState();
  }

  void removeColumn(String listId) {
    board.value.remove(listId);
    listNames.remove(listId);
    board.refresh();
    listNames.refresh();
    saveBoardState();
  }

  void moveItem(Item data, String listId, int targetPosition) {
    final currentList = board.value[data.listId]!;
    currentList.remove(data);
    data.listId = listId;
    if (board.value[listId]!.length > targetPosition) {
      board.value[listId]?.insert(targetPosition + 1, data);
    } else {
      board.value[listId]?.add(data);
    }
    board.refresh();
    saveBoardState();
  }

  void reorderLists(String listId, String incomingListId) {
    LinkedHashMap<String, List<Item>> reorderedBoard = LinkedHashMap();
    for (String key in board.value.keys) {
      if (key == incomingListId) {
        reorderedBoard[listId] = board.value[listId]!;
      } else if (key == listId) {
        reorderedBoard[incomingListId] = board.value[incomingListId]!;
      } else {
        reorderedBoard[key] = board.value[key]!;
      }
    }
    board.value = reorderedBoard;
    board.refresh();
    saveBoardState();
  }
}
