import 'package:second_brain/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import 'card_column.dart';

class AddColumnButton extends StatelessWidget {
  final Function addColumnAction;

  const AddColumnButton({super.key, required this.addColumnAction});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: InkWell(
        onTap: () => addColumnAction(),
        child: CardColumn(
          backgroundColor: KColors.darkModeCard,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              const Icon(Icons.add),
              const Text("Add Column"),
            ],
          ),
        ),
      ),
    );
  }
}
