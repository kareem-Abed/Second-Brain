import 'package:second_brain/common/widgets/divider/divider.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class iconChoicesModel {
  IconData icon;
  String name;
  int color;

  iconChoicesModel(
      {required this.icon, required this.name, required this.color});

  iconChoicesModel.fromJson(Map<String, dynamic> json)
      : icon = json['icon'],
        name = json['name'],
        color = json['color'];
}

class IconController extends GetxController {
  static IconController get instance => Get.find();

  Rx<IconData> selectedIcon = FontAwesomeIcons.briefcase.obs;
  RxString selectedName = 'عمل'.obs;
  Rx<int> selectedColor = 0xFF2196F3.obs;

  // Updated list with FontAwesome icons and color codes

  List<iconChoicesModel> iconChoices = [
    // Work and Study
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.briefcase,
      'name': 'عمل',
      'color': 0xFF2196F3
    }),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.code, 'name': 'برمجة', 'color': 0xFF4CAF50}),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.school,
      'name': 'مدرسة',
      'color': 0xFFFF5722
    }),

    // Home and Daily Life
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.house, 'name': 'منزل', 'color': 0xFF9C27B0}),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.cartShopping,
      'name': 'تسوق',
      'color': 0xFFFF9800
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.utensils,
      'name': 'مطعم',
      'color': 0xFF795548
    }),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.toilet, 'name': 'حمام', 'color': 0xFF607D8B}),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.doorOpen,
      'name': 'خروج',
      'color': 0xFF607D8B
    }),

    // Health and Fitness
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.dumbbell,
      'name': 'لياقة',
      'color': 0xFFF44336
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.hospital,
      'name': 'مستشفى',
      'color': 0xFFFF5252
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.bicycle,
      'name': 'دراجة',
      'color': 0xFF4CAF50
    }),

    // Events and Activities
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.calendarDay,
      'name': 'حدث',
      'color': 0xFF009688
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.music,
      'name': 'موسيقى',
      'color': 0xFFE91E63
    }),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.film, 'name': 'سينما', 'color': 0xFF00BCD4}),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.gamepad,
      'name': 'ألعاب',
      'color': 0xFF1E88E5
    }),

    // Travel and Nature
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.plane, 'name': 'طيران', 'color': 0xFF3F51B5}),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.tree, 'name': 'طبيعة', 'color': 0xFF69F0AE}),

    // Miscellaneous
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.book, 'name': 'قراءة', 'color': 0xFFFFC107}),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.phone, 'name': 'هاتف', 'color': 0xFF673AB7}),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.laptop,
      'name': 'حاسوب',
      'color': 0xFF03A9F4
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.lightbulb,
      'name': 'أفكار',
      'color': 0xFFFFEB3B
    }),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.star, 'name': 'نجمة', 'color': 0xFFFFD740}),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.paw, 'name': 'حيوانات', 'color': 0xFFCDDC39}),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.mosque, 'name': 'صلاة', 'color': 0xFF00BFA5}),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.bed, 'name': 'نوم', 'color': 0xFF8E24AA}),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.userGroup,
      'name': 'أصدقاء',
      'color': 0xFF3F51B5
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.bullseye,
      'name': 'هدف',
      'color': Colors.red.value
    }),
    iconChoicesModel.fromJson(
        {'icon': FontAwesomeIcons.trash, 'name': 'قمامة', 'color': 0xFFFF8A80}),
  ];
  void changeIcon(IconData icon, String name, int color) {
    selectedIcon.value = icon;
    selectedName.value = name;
    selectedColor.value = color;
  }
}

class IconSelector extends StatelessWidget {
  final IconController iconController = Get.put(IconController());

  IconSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon Selection (Top)
        Container(
          padding: const EdgeInsets.all(KSizes.sm),
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(' نوع المهمة ',
                      style: Theme.of(context).textTheme.headlineSmall!),
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: KSizes.sm),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 64,
                            height: 50,
                            child: Icon(
                              iconController.selectedIcon.value,
                              size: 40,
                              color: Color(iconController.selectedColor.value),
                            ),
                          ),
                          Text(
                            iconController.selectedName.value,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color:
                                      Color(iconController.selectedColor.value),
                                ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: KSizes.sm),
              Wrap(
                spacing: KSizes.sm,
                alignment: WrapAlignment.center,
                children: iconController.iconChoices.map((iconChoice) {
                  return InkWell(
                    onTap: () => iconController.changeIcon(
                      iconChoice.icon,
                      iconChoice.name,
                      iconChoice.color,
                    ),
                    customBorder: const CircleBorder(),
                    child: Column(
                      children: [
                        Ink(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(
                                iconChoice.color), // Fixed color handling
                          ),
                          child: Icon(iconChoice.icon,
                              color: Color(iconChoice.color)),
                        ),
                        const SizedBox(height: KSizes.sm / 4),
                        Text(
                          iconChoice.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Color(iconChoice.color),
                              ),
                          // style: TextStyle(
                          //   color: Color(iconChoice.color), // Fi
                          //   fontSize: 12,
                          // ),
                        ),
                        SizedBox(
                          height: KSizes.md,
                          width: 40,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        // const SizedBox(height: KSizes.sm),

        // Display Selected Icon with Fixed Color
        // Obx(() {
        //   return Column(
        //     children: [
        //       Container(
        //         padding: EdgeInsets.symmetric(
        //             vertical: MediaQuery.of(context).size.height * 0.02),
        //         decoration: BoxDecoration(
        //           color: Colors.grey[850],
        //           borderRadius: BorderRadius.circular(15),
        //           // boxShadow: [
        //           //   BoxShadow(
        //           //     color: Colors.black.withOpacity(0.2),
        //           //     blurRadius: 5,
        //           //     spreadRadius: 2,
        //           //     offset: const Offset(0, 2),
        //           //   ),
        //           // ],
        //         ),
        //         child: Column(
        //           children: [
        //             Center(
        //               child: Icon(
        //                 iconController.selectedIcon.value,
        //                 size: 50,
        //                 color: Color(iconController.selectedColor.value),
        //               ),
        //             ),
        //             Text(
        //               iconController.selectedName.value,
        //               style: TextStyle(
        //                 color: Color(iconController.selectedColor.value),
        //                 fontSize: 16,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       // const SizedBox(height: 10),
        //     ],
        //   );
        // }),
      ],
    );
  }
}
