import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/constants/sizes.dart';

class TAnimationLoaderWidget extends StatelessWidget {
  const TAnimationLoaderWidget(
      {super.key,
      required this.text,
      required this.animation,
      this.showAction = false,
      this.onActionPressed,
      this.actionText});

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Lottie.asset(
          animation,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const SizedBox(
          height: KSizes.sm,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(

            fontFamily: 'MontserratArabic',

          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: KSizes.defaultSpace,
        ),
        if (showAction)
          SizedBox(
            width: 250,
            child: OutlinedButton(
              onPressed: onActionPressed,
              style: OutlinedButton.styleFrom(backgroundColor: KColors.dark),
              child: Text(
                actionText!,
                style: Theme.of(context).textTheme.bodyMedium!.apply(color: KColors.light),
              ),
            ),
          )
      ]),
    );
  }
}
