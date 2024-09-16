import 'package:al_maafer/utils/constants/colors.dart';
import 'package:al_maafer/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../models/models.dart';
import 'taks_menu.widget.dart';
import 'task_text_widget.dart';

class TaskCard extends StatelessWidget {
  final KTask task;
  final int columnIndex;
  final Function deleteItemHandler;
  final Function(DragUpdateDetails) dragListener;

  const TaskCard({
    super.key,
    required this.task,
    required this.columnIndex,
    required this.dragListener,
    required this.deleteItemHandler,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext _, BoxConstraints constraints) {
        return Container(
          height: 50 + (task.title.length / 30) * 16,
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Draggable<KData>(
            onDragUpdate: dragListener,
            feedback: Material(
              // color: Colors.red,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: 50 + (task.title.length / 30) * 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: KColors.darkModeBackground,
                ),

                width: constraints.maxWidth,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10.0),
                // padding: const EdgeInsets.only(left: 16),
                child: Center(
                  child: Text(task.title,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            childWhenDragging: Container(color: Colors.black12),
            data: KData(from: columnIndex, task: task),
            child: GestureDetector(
              onSecondaryTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: KColors.darkModeBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.task, color: Colors.blue),
                          SizedBox(width: 10),
                          Text('Task Options'),
                        ],
                      ),
                      content: Text('Choose an action for the task.'),
                      actions: <Widget>[
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // updateItemHandler(columnIndex, task.title);
                          },
                          icon: Icon(Icons.edit, color: Colors.green),
                          label: Text('Update',
                              style: TextStyle(color: Colors.green)),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            deleteItemHandler(columnIndex, task.title);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                          label: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                height: 50 + (task.title.length / 30) * 16,
                color: KColors.darkModeBackground,
                padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(task.title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(width: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
