import 'package:flutter/material.dart';
import 'package:questly/utils/constants/sizes.dart';

class KDivider extends StatelessWidget {
  const KDivider({
    super.key,
    this.color = Colors.grey,
     this.height=2,
  });
  final Color color;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: KSizes.sm,
        ),
        Divider(
          color: color,
          thickness: height,
        ),
        const SizedBox(
          height: KSizes.sm,
        ),
      ],
    );
  }
}
