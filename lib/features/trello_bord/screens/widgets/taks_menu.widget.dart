import 'package:flutter/material.dart';


class TaskMenu extends StatelessWidget {
  final VoidCallback deleteHandler;
  final VoidCallback updateHandler;

  const TaskMenu({
    super.key,
    required this.deleteHandler,
    required this.updateHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Update Task'),
          onTap: () {
            Navigator.pop(context);
            updateHandler();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete Task'),
          onTap: () {
            Navigator.pop(context);
            deleteHandler();
          },
        ),
      ],
    );
  }
}