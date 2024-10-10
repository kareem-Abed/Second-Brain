import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:second_brain/features/trello_bord/controller/kanban_board_controller.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.title,
    required this.controller,
    required this.listId,
  });
  final String title, listId;
  final KanbanController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 6.0),
      child: Row(
        children: [
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                onTap: () {},
                title: 'edit',
                isDestructive: false,
                icon: Icons.edit,
              ),
              PullDownMenuItem(
                onTap: () {
                  controller.removeColumn(listId);
                },
                title: 'Delete',
                isDestructive: true,
                icon: Icons.delete,
              ),
            ],
            buttonBuilder: (context, showMenu) => IconButton(
              onPressed: showMenu,
              icon: const Icon(
                FontAwesomeIcons.ellipsis,
              ),
            ),
          ),
          // Container(
          //   width: 25,
          //   height: 25,
          //   margin: EdgeInsets.symmetric(horizontal: 8.0),
          //   decoration: BoxDecoration(
          //     color: KColors.darkModeBackground,
          //     shape: BoxShape.circle,
          //   ),
          //   child: FittedBox(
          //       fit: BoxFit.scaleDown,
          //       child: Text('3',
          //           style: Theme.of(context).textTheme.headlineMedium)),
          // ),
          Container(
            width: 220.0,
            child: Text(title,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall),
          ),
        ],
      ),
    );
  }
}
