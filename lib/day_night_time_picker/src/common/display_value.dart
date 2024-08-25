// ignore_for_file: no_leading_underscores_for_local_identifiers


import '../state/state_container.dart';

import 'package:flutter/material.dart';

/// Render the [Hour] or [Minute] value for `Android` picker
class DisplayValue extends StatelessWidget {
  /// The [value] to display
  final String value;

  /// The [onTap] handler
  final Null Function()? onTap;

  /// Whether the [value] is selected or not
  final bool isSelected;

  /// Constructor for the [Widget]
  const DisplayValue({
    Key? key,
    required this.value,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final _commonTimeStyles =
        Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: 62,
              fontWeight: FontWeight.bold
            ,color: Colors.white
            );

    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    final unselectedColor = timeState.widget.unselectedColor ?? Colors.blueAccent;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: InkWell(
          onTap: onTap,
          child: Text(
            value,
            textScaleFactor: 0.85,
            style: _commonTimeStyles.copyWith(
              color: isSelected ?     Colors.blue : unselectedColor,
            ),
          ),
        ),
      ),
    );
  }
}
