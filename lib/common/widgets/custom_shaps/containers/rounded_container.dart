import 'package:flutter/material.dart';
import 'package:questly/utils/constants/colors.dart';
import 'package:questly/utils/constants/sizes.dart';
import 'package:questly/utils/helpers/helper_functions.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({
    super.key,
    this.margin,
    this.width,
    this.height,
    this.radius = KSizes.cardRadiusLg,
    this.padding,
    this.chiled,
    this.backgroundColor = KColors.white,
    this.showBorder = true,
    this.borderColor,
  });
  final double? width, height;
  final double radius;
  final bool showBorder;
  final Widget? chiled;
  final EdgeInsetsGeometry? margin, padding;
  final Color? backgroundColor, borderColor;
  @override
  Widget build(BuildContext context) {
    final dark = KHelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder
            ? Border.all(
                color: borderColor ?? (dark ? KColors.darkContainer : KColors.borderPrimary))
            : null,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: chiled,
    );
  }
}
