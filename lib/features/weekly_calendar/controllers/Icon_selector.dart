import 'package:second_brain/utils/constants/colors.dart';
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
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.briefcase,
      'name': 'عمل',
      'color': 0xFF2196F3 // Blue
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.solidBell,
      'name': 'استيقاظ',
      'color': 0xFFFF6347 // Amber
    }),
    iconChoicesModel(
        icon: FontAwesomeIcons.utensils,
        name: 'فطور',
        color: 0xFFFF9800 // Orange
        ),
    iconChoicesModel(
        icon: FontAwesomeIcons.laptopCode,
        name: 'المشروع',
        color: 0xFF4CAF50
        ),
    iconChoicesModel(
        icon: FontAwesomeIcons.gamepad,
        name: 'استراحة',
        color: 0xFF673AB7 // Deep Purple
        ),
    iconChoicesModel(
        icon: FontAwesomeIcons.dumbbell,
        name: 'تمرين',
        color: 0xFFE91E63 // Pink
        ),
    iconChoicesModel(
        icon: FontAwesomeIcons.bed, name: 'النوم', color: 0xFF9C27B0 // Purple
        ),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.book,
      'name': 'دراسة',
      'color': 0xFF8BC34A
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.code,
      'name': 'برمجة',
      'color': 0xFF009688 // Teal
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.school,
      'name': 'مدرسة',
      'color': 0xFFD32F2F // Red
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.cartShopping,
      'name': 'تسوق',
      'color': 0xFFFB8C00 // Deep Orange
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.toilet,
      'name': 'حمام',
      'color': 0xFFAB47BC // Purple
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.personWalking,
      'name': 'خروج',
      'color': 0xFF1976D2 // Blue
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.hospital,
      'name': 'مستشفى',
      'color': 0xFFD32F2F // Red
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.calendarDay,
      'name': 'حدث',
      'color': 0xFF009688 // Teal
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.music,
      'name': 'موسيقى',
      'color': 0xFFE91E63 // Pink
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.film,
      'name': 'سينما',
      'color': 0xFF00BCD4 // Cyan
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.lightbulb,
      'name': 'أفكار',
      'color': 0xFFFFC107 // Yellow
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.mosque,
      'name': 'صلاة',
      'color': 0xFF00796B // Teal
    }),
    iconChoicesModel.fromJson({
      'icon': FontAwesomeIcons.bullseye,
      'name': 'هدف',
      'color': 0xFFD32F2F // Red
    }),
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
          padding: const EdgeInsets.all(KSizes.sm / 2),
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: KColors.darkModeSubCard,
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: iconController.iconChoices.length,
                itemBuilder: (context, index) {
                  final iconChoice = iconController.iconChoices[index];
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
                          width: 38,
                          child: Icon(
                            iconChoice.icon,
                            color: Color(iconChoice.color),
                          ),
                        ),
                        const SizedBox(height: KSizes.sm / 4),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            iconChoice.name,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Color(iconChoice.color),
                                    ),
                          ),
                        ),
                        // SizedBox(
                        //   height: KSizes.md,
                        //   width: 40,
                        // ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
