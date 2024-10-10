import 'dart:collection';

import 'package:get/get.dart';
import 'package:second_brain/features/trello_bord/models/item.dart';

class KanbanController extends GetxController {
  Rx<LinkedHashMap<String, List<Item>>> board =
      LinkedHashMap<String, List<Item>>().obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the board with default values
    board.value.addAll({
      "1": [
        Item(id: "1", listId: "1", title: "Pear"),
        Item(id: "2", listId: "1", title: "Potato"),
        Item(id: "q", listId: "1", title: "Potato"),
      ],
      "2": [
        Item(id: "3", listId: "2", title: "Car"),
        Item(id: "4", listId: "2", title: "Bicycle"),
        Item(id: "5", listId: "2", title: "On foot"),
      ],
      "3": [
        Item(id: "6", listId: "3", title: "Chile"),
        Item(id: "7", listId: "3", title: "Madagascar"),
        Item(id: "8", listId: "3", title: "Japan"),
      ],
      "4": [
        Item(id: "6", listId: "3", title: "Chile"),
        Item(id: "7", listId: "3", title: "Madagascar"),
        Item(id: "8", listId: "3", title: "Japan"),
      ],
    });
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
    board.refresh(); // Notify the UI of the changes
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
    board.refresh(); // Notify the UI of the changes
  }
}
