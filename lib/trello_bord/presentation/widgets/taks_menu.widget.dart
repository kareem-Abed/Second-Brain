import 'package:flutter/material.dart';

// class TaskMenu extends StatelessWidget {
//   final Function deleteHandler;
//   const TaskMenu({
//     super.key,
//     required this.deleteHandler,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final double paddingBottom = MediaQuery.of(context).padding.bottom;
//     return IntrinsicHeight(
//       child: Container(
//         color: Colors.red,
//         alignment: Alignment.center,
//         padding: EdgeInsets.only(top: 30, bottom: paddingBottom + 6),
//         child: InkWell(
//           onTap: () {
//             Navigator.of(context).pop();
//             deleteHandler();
//           },
//           child: const SizedBox(
//             height: 40,
//             child: Text(
//               'Delete Task',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


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