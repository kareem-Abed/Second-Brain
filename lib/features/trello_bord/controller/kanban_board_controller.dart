
import 'package:second_brain/features/trello_bord/models/column.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/data.dart';
import '../models/task.dart';

class KanbanController extends GetxController {
  var columns = <KColumn>[].obs;
  final box = GetStorage();
  final tasksMap = <String, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // clearAllTasks();
    loadTasks();
  }

  void addColumn(String title) {
    columns.add(KColumn(
      title: title,
      children: List.of([]),
    ));
    columns.refresh();
    saveTasks();
  }
void moveColumn(int currentIndex, bool isNext) {
  if (isNext&& currentIndex < columns.length - 1) {
    final temp = columns[currentIndex];
    columns[currentIndex] = columns[currentIndex + 1];
    columns[currentIndex + 1] = temp;
  } else if (!isNext && currentIndex > 0) {
    final temp = columns[currentIndex];
    columns[currentIndex] = columns[currentIndex - 1];
    columns[currentIndex - 1] = temp;
  }
  columns.refresh();
  saveTasks();
}
  void deleteItem(int columnIndex, String taskTitle) {
    String columnTitle = columns[columnIndex].title.toString();
    columns[columnIndex]
        .children
        .removeWhere((task) => task.title == taskTitle);
    tasksMap[columnTitle]?.remove(taskTitle);
    columns.refresh();
    saveTasks();
  }

  void handleReOrder(int oldIndex, int newIndex, int columnIndex) {
    final task = columns[columnIndex].children.removeAt(oldIndex);
    columns[columnIndex].children.insert(newIndex, task);

    // Update tasksMap to reflect the new order
    final columnTitle = columns[columnIndex].title;
    tasksMap[columnTitle]?.remove(task.title);
    tasksMap[columnTitle]?.insert(newIndex, task.title);

    columns.refresh();
    saveTasks();
  }

  void addTask(String title, int column) {
    final columnTitle = columns[column].title;
    columns[column].children.add(KTask(title: title));
    tasksMap.putIfAbsent(columnTitle, () => []);
    tasksMap[columnTitle]?.add(title);
    columns.refresh();
    saveTasks();
  }

  void dragHandler(KData data, int index) {
    final task = data.task;
    final fromColumn = columns[data.from];
    final toColumn = columns[index];

    fromColumn.children.remove(task);
    toColumn.children.add(task);

    tasksMap[fromColumn.title]?.remove(task.title);
    tasksMap.putIfAbsent(toColumn.title, () => []);
    tasksMap[toColumn.title]?.add(task.title);

    columns.refresh();
    saveTasks();
  }

  void saveTasks() {
    final columnsJson = columns
        .map((column) => {
              'title': column.title,
              'tasks': tasksMap[column.title] ?? [],
            })
        .toList();
    box.write('columns', columnsJson);
  }

  void loadTasks() {
    columns.value = [];
    final columnsJson = box.read<List<dynamic>>('columns') ?? [];
    for (var columnData in columnsJson) {
      final columnTitle = columnData['title'];
      final tasks = List<String>.from(columnData['tasks']);
      columns.add(KColumn(
          title: columnTitle,
          children:
              tasks.map((taskTitle) => KTask(title: taskTitle)).toList()));
      tasksMap[columnTitle] = tasks;
    }
    columns.refresh();
  }
  void clearAllTasks() {
    box.write('columns', []);
  }
}

// class Data {
//   static List<KColumn> getColumns() {
//     return List.from([
//       KColumn(
//         title: 'To Do',
//         children: [
//           KTask(title: 'ToDo 1'),
//           KTask(title: 'ToDo 2'),
//         ],
//       ),
//       KColumn(
//         title: 'In Progress',
//         children: [
//           KTask(title: 'ToDo 3'),
//         ],
//       ),
//       KColumn(
//         title: 'Done',
//         children: [
//           KTask(title: 'ToDo 4'),
//           KTask(title: 'ToDo 5'),
//         ],
//       )
//     ]);
//   }
// }
