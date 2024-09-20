import 'package:flutter/material.dart';
import 'package:second_brain/utils/constants/colors.dart';

class TCircularContainer extends StatelessWidget {
  const TCircularContainer({
    super.key,
    this.margin,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.chiled,
    this.backgroundColor = KColors.textWhite,
  });
  final double? width, height;
  final double radius, padding;
  final Widget? chiled;
  final EdgeInsets? margin;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: chiled,
    );
  }
}
