
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../models/column.dart';
import '../../models/data.dart';
import 'card_column.dart';
import 'task_card_widget.dart';

class KanbanColumn extends StatelessWidget {
  final KColumn column;
  final int index;
  final Function dragHandler;
  final Function reorderHandler;
  final Function addTaskHandler;
  void Function()? next;
  void Function()? back;
  final Function(DragUpdateDetails) dragListener;
  final Function deleteItemHandler;

  KanbanColumn({
    super.key,
    required this.column,
    required this.index,
    required this.dragHandler,
    required this.reorderHandler,
    required this.addTaskHandler,
    required this.dragListener,
    required this.deleteItemHandler,
    this.next,
    this.back,
  });

  @override
  Widget build(BuildContext context) {
    double columnHeight = 84.0 + (column.children.length * 60.0);
    if (columnHeight > MediaQuery.of(context).size.height) {
      columnHeight = MediaQuery.of(context).size.height;
    }
    return Stack(
      children: <Widget>[
        CardColumn(
          backgroundColor: KColors.darkModeCard,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitleColumn(index),
                _buildListItemsColumn(),
                // _buildButtonNewTask(index),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: DragTarget<KData>(
            onWillAccept: (data) {
              return true;
            },
            onLeave: (data) {},
            onAccept: (data) {
              if (data.from == index) {
                return;
              }
              dragHandler(data, index);
            },
            builder: (context, accept, reject) {
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitleColumn(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  addTaskHandler(index);
                },
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              const Icon(
                Icons.add_circle_outline,
                color: Colors.transparent,
                size: 24.0,
              ),
              Expanded(
                child: Center(
                  child: FittedBox(
                    child: Text(
                      column.title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: next,
                child: const Icon(
                  Icons.navigate_before,
                  color: Colors.red,
                  size: 24.0,
                ),
              ),
              InkWell(
                onTap: back,
                child: const Icon(
                  Icons.navigate_next,
                  color: Colors.red,
                  size: 24.0,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 3,
          )
        ],
      ),
    );
  }

  Widget _buildListItemsColumn() {
    return Expanded(
      child: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (newIndex < column.children.length) {
            reorderHandler(oldIndex, newIndex, index);
          } else {
            reorderHandler(oldIndex, newIndex - 1, index);
          }
        },
        children: [
          for (final task in column.children)
            TaskCard(
              key: ValueKey(task),
              task: task,
              columnIndex: index,
              dragListener: dragListener,
              deleteItemHandler: deleteItemHandler,
            )
        ],
      ),
    );
  }

  Widget _buildButtonNewTask(int index) {
    return ListTile(
      dense: true,
      onTap: () {
        addTaskHandler(index);
      },
      leading: const Icon(
        Icons.add_circle_outline,
        color: Colors.white,
        size: 24.0,
      ),
      title: const Text(
        'Add Task',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
