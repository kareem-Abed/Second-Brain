// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:super_drag_and_drop/super_drag_and_drop.dart';
//
// import 'package:get/get.dart';
//
// // class KanbanController extends GetxController {
// //   var todoTasks = <String>[].obs;
// //   var doingTasks = <String>[].obs;
// //   var doneTasks = <String>[].obs;
// //
// //   void addTask(String task) {
// //     todoTasks.add(task);
// //   }
// //
// //   void moveToDoing(String task) {
// //     if (todoTasks.contains(task)) {
// //       todoTasks.remove(task);
// //       doingTasks.add(task);
// //     } else if (doneTasks.contains(task)) {
// //       doneTasks.remove(task);
// //       doingTasks.add(task);
// //     }
// //   }
// //
// //   void moveToDone(String task) {
// //     if (todoTasks.contains(task)) {
// //       todoTasks.remove(task);
// //       doneTasks.add(task);
// //     } else if (doingTasks.contains(task)) {
// //       doingTasks.remove(task);
// //       doneTasks.add(task);
// //     }
// //   }
// //
// //   void moveBackToTodo(String task) {
// //     if (doingTasks.contains(task)) {
// //       doingTasks.remove(task);
// //       todoTasks.add(task);
// //     } else if (doneTasks.contains(task)) {
// //       doneTasks.remove(task);
// //       todoTasks.add(task);
// //     }
// //   }
// // }
// //
// // class KanbanBoard extends StatelessWidget {
// //   final KanbanController controller = Get.put(KanbanController());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Kanban Board'),
// //       ),
// //       body: Row(
// //         children: [
// //           Expanded(child: _buildTaskColumn('Todo', controller.todoTasks)),
// //           Expanded(child: _buildTaskColumn('Doing', controller.doingTasks)),
// //           Expanded(child: _buildTaskColumn('Done', controller.doneTasks)),
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => _addNewTaskDialog(context),
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTaskColumn(String title, RxList<String> tasks) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Text(
// //             title,
// //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //           ),
// //         ),
// //         Expanded(
// //           child: DropRegion(
// //             formats: Formats.standardFormats,
// //             hitTestBehavior: HitTestBehavior.opaque,
// //             onDropOver: (event) {
// //               return DropOperation.copy;
// //             },
// //             onPerformDrop: (event) async {
// //               final item = event.session.items.first;
// //               final reader = item.dataReader!;
// //               if (reader.canProvide(Formats.plainText)) {
// //                 reader.getValue<String>(Formats.plainText, (value) {
// //                   if (value != null) {
// //                     if (title == 'Todo') {
// //                       controller.moveBackToTodo(value);
// //                     } else if (title == 'Doing') {
// //                       controller.moveToDoing(value);
// //                     } else if (title == 'Done') {
// //                       controller.moveToDone(value);
// //                     }
// //                   }
// //                 }, onError: (error) {
// //                   print('Error reading value $error');
// //                 });
// //               }
// //             },
// //             child: Obx(() {
// //               return ListView.builder(
// //                 itemCount: tasks.length,
// //                 itemBuilder: (context, index) {
// //                   final task = tasks[index];
// //                   return MyDraggableWidget(task: task);
// //                 },
// //               );
// //             }),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   void _addNewTaskDialog(BuildContext context) {
// //     final TextEditingController taskController = TextEditingController();
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Add New Task'),
// //         content: TextField(controller: taskController),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               if (taskController.text.isNotEmpty) {
// //                 controller.addTask(taskController.text);
// //               }
// //               Get.back();
// //             },
// //             child: Text('Add'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class MyDraggableWidget extends StatelessWidget {
// //   final String task;
// //
// //   MyDraggableWidget({required this.task});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return DragItemWidget(
// //       dragItemProvider: (request) async {
// //         final item = DragItem(
// //           localData: {'task': task},
// //         );
// //         item.add(Formats.plainText(task));
// //         return item;
// //       },
// //       allowedOperations: () => [DropOperation.copy],
// //       child: DraggableWidget(
// //         child: Card(
// //           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
// //           child: ListTile(
// //             title: Text(task),
// //             trailing: Icon(Icons.drag_handle),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:get/get.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:super_drag_and_drop/super_drag_and_drop.dart';
//
// class KanbanController extends GetxController {
//   var todoTasks = <String>[].obs;
//   var doingTasks = <String>[].obs;
//   var doneTasks = <String>[].obs;
//
//   void addTask(String task) {
//     todoTasks.add(task);
//   }
//
//   void removeTask(String task, String column) {
//     if (column == 'Todo') {
//       todoTasks.remove(task);
//     } else if (column == 'Doing') {
//       doingTasks.remove(task);
//     } else if (column == 'Done') {
//       doneTasks.remove(task);
//     }
//   }
//
//   void insertTaskAt(String task, int index, String column) {
//     if (column == 'Todo') {
//       todoTasks.insert(index, task);
//     } else if (column == 'Doing') {
//       doingTasks.insert(index, task);
//     } else if (column == 'Done') {
//       doneTasks.insert(index, task);
//     }
//   }
// }
//
// class KanbanBoard extends StatelessWidget {
//   final KanbanController controller = Get.put(KanbanController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Kanban Board'),
//       ),
//       body: Row(
//         children: [
//           Expanded(child: _buildTaskColumn('Todo', controller.todoTasks)),
//           Expanded(child: _buildTaskColumn('Doing', controller.doingTasks)),
//           Expanded(child: _buildTaskColumn('Done', controller.doneTasks)),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _addNewTaskDialog(context),
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget _buildTaskColumn(String title, RxList<String> tasks) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             title,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Expanded(
//           child: DropRegion(
//             formats: Formats.standardFormats,
//             hitTestBehavior: HitTestBehavior.opaque,
//             onDropOver: (event) {
//               return DropOperation.copy;
//             },
//             onPerformDrop: (event) async {
//               final item = event.session.items.first;
//               final reader = item.dataReader!;
//               if (reader.canProvide(Formats.plainText)) {
//                 reader.getValue<String>(Formats.plainText, (value) {
//                   if (value != null) {
//                     final globalPosition = event.globalPosition.dy;
//                     final itemHeight = 50.0; // Adjust based on item height
//                     final dropIndex = (globalPosition / itemHeight).floor();
//
//                     if (title == 'Todo') {
//                       controller.removeTask(value, 'Doing');
//                       controller.insertTaskAt(value, dropIndex, 'Todo');
//                     } else if (title == 'Doing') {
//                       controller.removeTask(value, 'Todo');
//                       controller.insertTaskAt(value, dropIndex, 'Doing');
//                     } else if (title == 'Done') {
//                       controller.removeTask(value, 'Doing');
//                       controller.insertTaskAt(value, dropIndex, 'Done');
//                     }
//                   }
//                 }, onError: (error) {
//                   print('Error reading value $error');
//                 });
//               }
//             },
//             child: Obx(() {
//               return ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = tasks[index];
//                   return MyDraggableWidget(task: task);
//                 },
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _addNewTaskDialog(BuildContext context) {
//     final TextEditingController taskController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Add New Task'),
//         content: TextField(controller: taskController),
//         actions: [
//           TextButton(
//             onPressed: () {
//               if (taskController.text.isNotEmpty) {
//                 controller.addTask(taskController.text);
//               }
//               Get.back();
//             },
//             child: Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class MyDraggableWidget extends StatelessWidget {
//   final String task;
//
//   MyDraggableWidget({required this.task});
//
//   @override
//   Widget build(BuildContext context) {
//     return DragItemWidget(
//       dragItemProvider: (request) async {
//         final item = DragItem(
//           localData: {'task': task},
//         );
//         item.add(Formats.plainText(task));
//         return item;
//       },
//       allowedOperations: () => [DropOperation.copy],
//       child: DraggableWidget(
//         child: Card(
//           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           child: ListTile(
//             title: Text(task),
//             trailing: Icon(Icons.drag_handle),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
