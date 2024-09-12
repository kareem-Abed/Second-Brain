import 'package:al_maafer/features/trello/multi_board_list_example.dart';
import 'package:al_maafer/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/column.dart';
import '../pages/kaban_set_state_page.dart';
import '../pages/kanban_board_controller.dart';
import 'add_column_button_widget.dart';
import 'add_column_widget.dart';
import 'add_task_widget.dart';
import 'column_widget.dart';

class KanbanBoard extends StatefulWidget {
  // final KanbanBoardController controller;
  // final List<KColumn> columns;
  KanbanBoard({
    super.key,
    // required this.controller,
    // required this.columns,
  });

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final controller = Get.put(KanbanController());
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: Obx(
        () => ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.all(16),
          itemCount: controller.columns.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            if (index == controller.columns.length) {
              // return SizedBox();
              return AddColumnButton(
                addColumnAction: _showAddColumn,
              );
            } else {
              return KanbanColumn(
                column: controller.columns[index],
                index: index,
                dragHandler: controller.dragHandler,
                reorderHandler: controller.handleReOrder,
                addTaskHandler: _showAddTask,
                dragListener: _dragListener,
                deleteItemHandler: controller.deleteItem,
              );
            }
          },
        ),
      ),
    );
  }

  void _showAddColumn() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => AddColumnForm(
        addColumnHandler: controller.addColumn,
      ),
    );
  }

  void _showAddTask(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: HexColor.fromHex('#2C2C2C'),
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => AddTaskForm(
        addTaskHandler: (String title) {
          controller.addTask(title, index);
        },
      ),
    );
  }

  void _dragListener(DragUpdateDetails details) {
    if (details.localPosition.dx > MediaQuery.of(context).size.width - 40) {
      _scrollController.jumpTo(_scrollController.offset + 10);
    } else if (details.localPosition.dx < 20) {
      _scrollController.jumpTo(_scrollController.offset - 10);
    }
  }
}
