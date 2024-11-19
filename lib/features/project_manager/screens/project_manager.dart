import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/kanban_bord/controller/kanban_board_controller.dart';
import 'package:second_brain/features/kanban_bord/models/item.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/add_item_button.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/add_list_button.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/floating_widget.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/header_widget.dart';
import 'package:second_brain/features/kanban_bord/screens/widgets/item_widget.dart';
import 'package:second_brain/utils/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_brain/features/project_manager/controller/project_manager_controller.dart';
import 'package:second_brain/features/project_manager/models/folder.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import 'package:second_brain/utils/validators/validation.dart';

class ProjectManager extends StatelessWidget {
  final ProjectManagerController projectManagerController =
      Get.put(ProjectManagerController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    projectManagerController.updateCrossAxisCount(screenWidth);
    print('Project Manager Screen$screenWidth');

    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                color: KColors.darkModeCard,
                border: Border.all(
                  color: KColors.darkModeCardBorder,
                ),
                borderRadius: BorderRadius.circular(KSizes.borderRadius),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        backgroundColor: KColors.darkModeSubCard,
                        onPressed: () {
                          projectManagerController
                              .addFolder(Folder(id: '1', title: 'New Project'));
                        },
                        child: const Icon(
                          IconsaxPlusBroken.add,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text('Project Manager',
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Obx(() {
              return AlignedGridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: projectManagerController.crossAxisCount.value,
                shrinkWrap: true,
                itemCount: projectManagerController.folders.length,
                itemBuilder: (context, index) {
                  final folder = projectManagerController.folders[index];
                  return FolderContainer(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, left: 1),
                            child: SizedBox(
                              // color: Colors.red,
                              height: 25,
                              width: 110,
                              child: FittedBox(
                                child: Text(
                                  'work',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          folder.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.ellipsisVertical,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class FolderContainer extends StatelessWidget {
  final Widget child;

  const FolderContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          child: CustomPaint(
            painter: RPSCustomPainter(),
            child: SizedBox(width: double.infinity, height: 300, child: child),
          ),
        ),
      ],
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.3407080, size.height * 0.1215470);
    path_0.cubicTo(
        size.width * 0.3247788,
        size.height * 0.1160221,
        size.width * 0.3156350,
        size.height * 0.07780856,
        size.width * 0.3130531,
        size.height * 0.05939227);
    path_0.cubicTo(size.width * 0.3108407, size.height * 0.03959475,
        size.width * 0.2980088, 0, size.width * 0.2643805, 0);
    path_0.lineTo(size.width * 0.04977876, 0);
    path_0.cubicTo(
        size.width * 0.03576704,
        size.height * 0.0004604061,
        size.width * 0.006194690,
        size.height * 0.01270718,
        0,
        size.height * 0.05801105);
    path_0.lineTo(0, size.height * 0.9240359);
    path_0.lineTo(size.width * 0.0001138352, size.height * 0.9270746);
    path_0.cubicTo(
        size.width * 0.002080086,
        size.height * 0.9523950,
        size.width * 0.01596996,
        size.height * 0.9994006,
        size.width * 0.05752212,
        size.height * 0.9972376);
    path_0.lineTo(size.width * 0.4137168, size.height * 0.9972376);
    path_0.lineTo(size.width * 0.9369469, size.height * 0.9972376);
    path_0.cubicTo(size.width * 0.9579646, size.height * 0.9972376, size.width,
        size.height * 0.9831492, size.width, size.height * 0.9267956);
    path_0.lineTo(size.width, size.height * 0.1906077);
    path_0.cubicTo(
        size.width,
        size.height * 0.1381215,
        size.width * 0.9679204,
        size.height * 0.1184942,
        size.width * 0.9502212,
        size.height * 0.1187845);
    path_0.cubicTo(
        size.width * 0.7536881,
        size.height * 0.1220075,
        size.width * 0.3566372,
        size.height * 0.1270718,
        size.width * 0.3407080,
        size.height * 0.1215470);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;

    paint_0_fill.color = KColors.darkModeCard;
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
