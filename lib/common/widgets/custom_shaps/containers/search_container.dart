// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import 'package:second_brain/utils/device/device_utility.dart';
import 'package:second_brain/utils/helpers/helper_functions.dart';

class TSerchContaner2 extends StatelessWidget {
  const TSerchContaner2({
    super.key,
    required this.text,
    this.icon = IconsaxPlusLinear.search_normal,
    this.showBackGround = true,
    this.showBorder = false,
  });
  final String text;
  final IconData? icon;
  final bool showBackGround, showBorder;
  @override
  Widget build(BuildContext context) {
    final darkMode = KHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KSizes.defaultSpace),
      child: Container(
        width: KDeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(KSizes.md),
        decoration: BoxDecoration(
          color: showBackGround
              ? darkMode
                  ? KColors.dark
                  : KColors.light
              : Colors.transparent,
          borderRadius: BorderRadius.circular(KSizes.cardRadiusLg),
          border: showBorder ? Border.all(color: KColors.grey) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: KColors.darkGrey,
            ),
            const SizedBox(width: KSizes.spaceBtwItems),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class TSerchContaner extends StatelessWidget {
  const TSerchContaner(
      {super.key,
      this.hintText,
      this.icon = IconsaxPlusLinear.search_normal,
      this.showBackGround = true,
      this.showBorder = false,
      required this.gotoSerch,
      this.pading =
          const EdgeInsets.symmetric(horizontal: KSizes.defaultSpace)});
  final String? hintText;
  final IconData? icon;
  final bool showBackGround, showBorder, gotoSerch;
  final EdgeInsets pading;

  @override
  Widget build(BuildContext context) {
    final darkMode = KHelperFunctions.isDarkMode(context);
    final textEditingController = TextEditingController();

    return Padding(
      padding: pading,
      child: Container(
        width: KDeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(KSizes.xs),
        decoration: BoxDecoration(
          color: showBackGround
              ? darkMode
                  ? KColors.dark
                  : KColors.light
              : Colors.transparent,
          borderRadius: BorderRadius.circular(KSizes.cardRadiusLg),
          border: showBorder ? Border.all(color: KColors.grey) : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: KSizes.spaceBtwItems),
            GestureDetector(
              onTap: () {},
              child: Icon(
                icon,
                color: KColors.darkGrey,
              ),
            ),
            const SizedBox(width: KSizes.spaceBtwItems),
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                onFieldSubmitted: (value) {
                  value = value.trim();
                  if (value.isNotEmpty) {}
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
