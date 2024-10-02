import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:second_brain/utils/constants/colors.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: EdgeInsets.all(24),
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
            Expanded(child: Text(habitName)),
            PullDownButton(
              itemBuilder: (context) => [
                PullDownMenuItem(
                  onTap: () => settingsTapped?.call(context),
                  title: 'edit',
                  isDestructive: false,
                  icon: Icons.edit,
                ),
                PullDownMenuItem(
                  onTap: () => deleteTapped?.call(context),
                  title: 'Delete',
                  isDestructive: true,
                  icon: Icons.delete,
                ),
              ],
              buttonBuilder: (context, showMenu) => InkWell(
                onTap: showMenu,
                child: const Icon(
                  FontAwesomeIcons.ellipsisVertical,
                ),
              ),
            )
          ],
        ),
      ),
      // Slidable(
      //   endActionPane: ActionPane(
      //     motion: const StretchMotion(),
      //     children: [
      //       // settings option
      //       SlidableAction(
      //         onPressed:
      //         backgroundColor: Colors.grey.shade800,
      //         icon: Icons.settings,
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //
      //       // delete option
      //       SlidableAction(
      //         onPressed:
      //         backgroundColor: Colors.red.shade400,
      //         icon: Icons.delete,
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //     ],
      //   ),
      //   child:
      // ),
    );
  }
}
