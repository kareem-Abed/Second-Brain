import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:second_brain/features/trello_bord/controller/kanban_board_controller.dart';
import 'package:second_brain/features/trello_bord/models/item.dart';

import '../../../../utils/constants/colors.dart';

class ItemWidget extends StatefulWidget {
  final Item item;
  final bool showHover;

  final KanbanController controller;
  const ItemWidget(
      {Key? key,
      required this.item,
      this.showHover = false,
      required this.controller})
      : super(key: key);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  Color borderColor = Colors.transparent;
  bool isHovered = false;

  void _showOverlayMenu(BuildContext context) {
    final overlay = Overlay.of(context)?.context.findRenderObject();
    final button = context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero);

    showMenu(
      color: KColors.darkModeSubCard,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + button.size.width,
        position.dy,
        overlay?.semanticBounds.size.width ?? 0 - position.dx,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.edit, color: Colors.white),
            title: Text('Edit',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white)),
            onTap: () {
              //widget.controller.editItem(widget.item);
              Navigator.pop(context);
              print('Edit');
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              widget.controller.removeItem(widget.item.listId, widget.item.id);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          borderColor = Colors.white;
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          borderColor = Colors.transparent;
          isHovered = false;
        });
      },
      child: Stack(
        children: [
          Card(
            elevation: 8.0,
            // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              width: 300,
              height: 50 + (widget.item.title.length * 3.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(64, 75, 96, .9),
                border: Border.all(
                    color: widget.showHover ? borderColor : Colors.transparent,
                    width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Text(
                widget.item.title,
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Visibility(
              visible: widget.showHover ? isHovered : false,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, right: 9.0),
                child: IconButton(
                  onPressed: () => _showOverlayMenu(context),
                  icon: const Icon(
                    FontAwesomeIcons.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
