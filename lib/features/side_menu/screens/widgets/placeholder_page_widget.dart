import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class PlaceholderPageWidget extends StatelessWidget {
  final String title;

  const PlaceholderPageWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KColors.darkModeBackground,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 35, color: Colors.white),
        ),
      ),
    );
  }
}
