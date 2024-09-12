import 'package:flutter/material.dart';

import '../widgets/kanban_board.dart';

class Kanban extends StatelessWidget {
  const Kanban({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set State'),
      ),
      body: SafeArea(
        child: KanbanBoard(),
      ),
    );
  }
}
