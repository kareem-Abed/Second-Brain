import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/features/kanban_bord/models/item.dart';

class KanbanController extends GetxController {
  Rx<LinkedHashMap<String, List<Item>>> board =
      // ignore: prefer_collection_literals
      LinkedHashMap<String, List<Item>>().obs;
  RxMap<String, RxString> listNames = <String, RxString>{}.obs;
  final box = GetStorage();
  var isDragging = false.obs;
  var draggingListId = ''.obs;
  final RxBool showListNameTextField = false.obs;
  final listNameController = TextEditingController().obs;
  var listNameFocusNode = FocusNode().obs;
  final RxBool isListEditMode = false.obs;
  final RxString editingListId = ''.obs;
  final RxString activeListId = ''.obs;
//--------

  final RxBool isItemEditMode = false.obs;
  final RxString editingItemId = ''.obs;
  final RxString editingItemListId = ''.obs;

  final RxBool showItemNameTextField = false.obs;
  final itemNameController = TextEditingController().obs;
  final itemNameFocusNode = FocusNode().obs;

  @override
  void onInit() {
    super.onInit();
    loadBoardState();
  }

  @override
  void onClose() {
    // Dispose of TextEditingController instances
    listNameController.value.dispose();
    itemNameController.value.dispose();
    // Dispose of FocusNode instances
    listNameFocusNode.value.dispose();
    itemNameFocusNode.value.dispose();
    // Call super.onClose() to ensure any inherited cleanup is performed
    super.onClose();
  }

  void focusItemName() {
    itemNameFocusNode.value.requestFocus();
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
      listNames.value = Map<String, RxString>.from(
        (storedListNames as Map).map((key, value) => MapEntry(
              key,
              value.toString().obs,
            )),
      );
    } else {
      board.value.addAll({
        "1": [
          Item(id: "1", listId: "1", title: "To Do1"),
          Item(id: "2", listId: "1", title: "To Do2"),
        ],
        "2": [
          Item(id: "4", listId: "2", title: "Doing1"),
          Item(id: "5", listId: "2", title: "Doing2"),
        ],
        "3": [
          Item(id: "7", listId: "3", title: "Done1"),
          Item(id: "8", listId: "3", title: "Done2"),
        ],
      });

      listNames.addAll({
        "1": "To Do".obs,
        "2": "Doing".obs,
        "3": "Done".obs,
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
    box.write(
        'listNames',
        listNames.map((key, value) => MapEntry(
              key,
              value.value,
            )));
  }

  // void editItem(String itemId, String newTitle) {
  //   board.value.forEach((listId, items) {
  //     final item = items.firstWhere(
  //       (item) => item.id == itemId,
  //       orElse: () => Item(id: '', listId: '', title: ''),
  //     );
  //     if (item.id.isNotEmpty) {
  //       item.title = newTitle;
  //       board.refresh();
  //       saveBoardState();
  //       return;
  //     }
  //   });
  // }

  void editItem(String listId, String itemId, String newTitle) {
    if (board.value.containsKey(listId)) {
      final items = board.value[listId];
      final item = items?.firstWhere(
        (item) => item.id == itemId,
        orElse: () => Item(id: '', listId: '', title: ''),
      );
      if (item != null && item.id.isNotEmpty) {
        item.title = newTitle;
        board.refresh();
        saveBoardState();
      } else {}
    } else {}
  }

  void editList(String listId, String newName) {
    if (listNames.containsKey(listId)) {
      listNames[listId]?.value = newName;
      listNames.refresh();
      saveBoardState();
    } else {}
  }

  void addItem(String listId, String itemName) {
    String itemId = DateTime.now().millisecondsSinceEpoch.toString();
    Item newItem = Item(id: itemId, listId: listId, title: itemName);

    if (board.value.containsKey(listId)) {
      board.value[listId]?.add(newItem);
      board.refresh();
      saveBoardState();
    } else {}
  }

  void addList(String listName) {
    String listId = DateTime.now().millisecondsSinceEpoch.toString();
    if (!board.value.containsKey(listId)) {
      board.value[listId] = [];
      listNames[listId] = listName.obs;
      board.refresh();
      listNames.refresh();
      saveBoardState();
    } else {}
  }

  void removeItem(String listId, String itemId) {
    if (!board.value.containsKey(listId)) {
      return;
    }

    final items = board.value[listId];
    if (items == null || items.isEmpty) {
      return;
    }

    final initialLength = items.length;
    items.removeWhere((item) => item.id == itemId);
    final itemRemoved = items.length < initialLength;

    if (itemRemoved) {
      board.refresh();
      saveBoardState();
    } else {}
  }

  void renameColumn(String listId, String newName) {
    if (listNames.containsKey(listId)) {
      listNames[listId]?.value = newName;
      listNames.refresh();
      saveBoardState();
    } else {}
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
