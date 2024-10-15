import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:second_brain/utils/constants/colors.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });
  void _showOverlayMenu(BuildContext context) {
    final overlay = Overlay.of(context).context.findRenderObject();
    final button = context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero);

    showMenu(
      color: KColors.darkModeSubCard,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + 80,
        position.dy,
        overlay?.semanticBounds.size.width ?? 0 - position.dx,
        0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: Text('Edit',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white)),
            onTap: () => settingsTapped?.call(context),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text('Delete',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red)),
            onTap: () => deleteTapped?.call(context),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: KColors.darkModeSubCard,
          border: Border.all(color: KColors.darkModeCardBorder, width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Checkbox(
              value: habitCompleted,
              activeColor: Colors.lightBlueAccent,
              onChanged: onChanged,
            ),
            Expanded(
                child: Text(
              habitName,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            )),
            IconButton(
              onPressed: () => _showOverlayMenu(context),
              icon: const Icon(
                FontAwesomeIcons.ellipsisVertical,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
