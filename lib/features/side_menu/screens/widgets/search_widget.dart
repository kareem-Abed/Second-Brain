import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/utils/constants/colors.dart';

import '../../../../utils/constants/sizes.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 50,
      // padding: const EdgeInsets.all(KSizes.xs),
      decoration: BoxDecoration(
        color: KColors.darkModeSubCard,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextFormField(
                onFieldSubmitted: (value) {},
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 16,
                    color: KColors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: KSizes.spaceBtwItems),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              IconsaxPlusBroken.search_normal,
              color: KColors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: KSizes.spaceBtwItems),
        ],
      ),
    );
  }
}