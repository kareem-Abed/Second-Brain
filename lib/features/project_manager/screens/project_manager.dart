import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/common/widgets/loaders/animation_loader.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/features/project_manager/controller/project_manager_controller.dart';
import 'package:second_brain/features/project_manager/models/folder.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import 'dart:ui' as ui;

import '../../kanban_bord/controller/kanban_board_controller.dart';
import '../../kanban_bord/screens/kanban_board.dart';

class ProjectManager extends StatelessWidget {
  ProjectManager({super.key});
  final ProjectManagerController projectManagerController =
      Get.put(ProjectManagerController());
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    projectManagerController.updateCrossAxisCount(screenWidth);

    return Obx(() {
      return projectManagerController.showBord.value
          ? const KanbanBoard()
          : Scaffold(
              backgroundColor: KColors.darkModeBackground,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: KColors.darkModeCard,
                        border: Border.all(
                          color: KColors.darkModeCardBorder,
                        ),
                        borderRadius:
                            BorderRadius.circular(KSizes.borderRadius),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                backgroundColor: KColors.darkModeSubCard,
                                onPressed: () {
                                  projectManagerController.addFolder(
                                      Folder(id: '1123', title: 'New Project'));
                                },
                                child: const Icon(
                                  IconsaxPlusBroken.add,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text('Project Manager',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24)),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 16),
                      padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 16),
                      decoration: BoxDecoration(
                        color: KColors.darkModeCard,
                        border: Border.all(
                          color: KColors.darkModeCardBorder,
                        ),
                        borderRadius:
                            BorderRadius.circular(KSizes.borderRadius),
                      ),
                      child: Obx(() {
                        return projectManagerController.folders.isEmpty
                            ? const TAnimationLoaderWidget(
                                text: 'لا يوجد مشاريع',
                                animation: 'assets/lottie/not_found.json',
                              )
                            : AlignedGridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: projectManagerController
                                    .crossAxisCount.value,
                                shrinkWrap: true,
                                itemCount:
                                    projectManagerController.folders.length,
                                itemBuilder: (context, index) {
                                  final List<String> listNames = [
                                    'assets/svg/Games.svg',
                                    'assets/svg/Canceled.svg',
                                    'assets/svg/Completed.svg',
                                    'assets/svg/Idia.svg',
                                    'assets/svg/Mony.svg',
                                    'assets/svg/On Hold.svg',
                                    'assets/svg/Ongoing.svg',
                                  ];
                                  final folder =
                                      projectManagerController.folders[index];

                                  return Center(
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            final kanbanController =
                                                Get.put(KanbanController());
                                            kanbanController.loadBoardState(
                                                '${folder.id}-board',
                                                '${folder.id}-listNames');
                                            projectManagerController
                                                .showBord.value = true;
                                          },
                                          child: SizedBox(
                                            height: 320,
                                            width: 340,
                                            child: FolderContainer(
                                              svgPath: listNames[index],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: SizedBox(
                                            width: 340,
                                            child: Text(
                                              'الكليه مشروع الكليه الكليه مشروعه',
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                mainAxisSpacing: 30.0,
                                crossAxisSpacing: 30.0,
                              );
                      }),
                    )
                  ],
                ),
              ),
            );
    });
  }
}

class FolderContainer extends StatelessWidget {
  // final Widget child;
  final String svgPath;

  const FolderContainer({Key? key, required this.svgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      fit: BoxFit.fill,
    );
  }
}

// class FolderContainer extends StatelessWidget {
//   final Widget child;
//
//   const FolderContainer({Key? key, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       height: 400,
//       color: KColors.error,
//       child: CustomPaint(
//         painter: FolderPainter(
//             // color1: const Color(0xff60696B),
//             // color2: const Color(0xff858E96).withOpacity(1),
//             ),
//         child: SizedBox(width: 400, height: 400, child: child),
//       ),
//     );
//   }
// }
//
// class FolderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Path path_0 = Path();
//     path_0.moveTo(size.width * 0.02941176, size.height * 0.1811768);
//     path_0.lineTo(size.width * 0.02941176, size.height * 0.8179191);
//     path_0.cubicTo(
//         size.width * 0.02941176,
//         size.height * 0.8451324,
//         size.width * 0.05147353,
//         size.height * 0.8671949,
//         size.width * 0.07868805,
//         size.height * 0.8671949);
//     path_0.lineTo(size.width * 0.9213125, size.height * 0.8671949);
//     path_0.cubicTo(
//         size.width * 0.9485257,
//         size.height * 0.8671949,
//         size.width * 0.9705882,
//         size.height * 0.8451324,
//         size.width * 0.9705882,
//         size.height * 0.8179191);
//     path_0.lineTo(size.width * 0.9705882, size.height * 0.2816673);
//     path_0.cubicTo(
//         size.width * 0.9705882,
//         size.height * 0.2544522,
//         size.width * 0.9485257,
//         size.height * 0.2323915,
//         size.width * 0.9213125,
//         size.height * 0.2323915);
//     path_0.lineTo(size.width * 0.4790496, size.height * 0.2323915);
//     path_0.cubicTo(
//         size.width * 0.4598934,
//         size.height * 0.2323915,
//         size.width * 0.4425423,
//         size.height * 0.2212096,
//         size.width * 0.4325202,
//         size.height * 0.2048824);
//     path_0.cubicTo(
//         size.width * 0.4142592,
//         size.height * 0.1751309,
//         size.width * 0.3813309,
//         size.height * 0.1319006,
//         size.width * 0.3441636,
//         size.height * 0.1319006);
//     path_0.lineTo(size.width * 0.07861103, size.height * 0.1319006);
//     path_0.cubicTo(
//         size.width * 0.05139651,
//         size.height * 0.1319006,
//         size.width * 0.02941176,
//         size.height * 0.1539623,
//         size.width * 0.02941176,
//         size.height * 0.1811768);
//     path_0.close();
//
//     Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
//     paint_0_fill.color = Color(0xff30C584).withOpacity(1.0);
//     canvas.drawPath(path_0, paint_0_fill);
//
//     Path path_1 = Path();
//     path_1.moveTo(size.width * 0.9705882, size.height * 0.3006636);
//     path_1.lineTo(size.width * 0.9705882, size.height * 0.8013750);
//     path_1.cubicTo(
//         size.width * 0.9705882,
//         size.height * 0.8285882,
//         size.width * 0.9485257,
//         size.height * 0.8506507,
//         size.width * 0.9213125,
//         size.height * 0.8506507);
//     path_1.lineTo(size.width * 0.07868805, size.height * 0.8506507);
//     path_1.cubicTo(
//         size.width * 0.05147353,
//         size.height * 0.8506507,
//         size.width * 0.02941176,
//         size.height * 0.8285882,
//         size.width * 0.02941176,
//         size.height * 0.8013750);
//     path_1.lineTo(size.width * 0.02941176, size.height * 0.3505496);
//     path_1.cubicTo(
//         size.width * 0.02941176,
//         size.height * 0.3233364,
//         size.width * 0.05140074,
//         size.height * 0.3012739,
//         size.width * 0.07861526,
//         size.height * 0.3012739);
//     path_1.lineTo(size.width * 0.3275331, size.height * 0.3012739);
//     path_1.cubicTo(
//         size.width * 0.4113033,
//         size.height * 0.3012739,
//         size.width * 0.3995993,
//         size.height * 0.2513824,
//         size.width * 0.4568824,
//         size.height * 0.2513860);
//     path_1.cubicTo(
//         size.width * 0.6131746,
//         size.height * 0.2513934,
//         size.width * 0.8263713,
//         size.height * 0.2513897,
//         size.width * 0.9213952,
//         size.height * 0.2513879);
//     path_1.cubicTo(
//         size.width * 0.9486103,
//         size.height * 0.2513860,
//         size.width * 0.9705882,
//         size.height * 0.2734485,
//         size.width * 0.9705882,
//         size.height * 0.3006636);
//     path_1.close();
//
//     Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
//     paint_1_fill.shader = ui.Gradient.linear(
//         Offset(size.width * 0.9705882, size.height * 0.2513860),
//         Offset(size.width * 0.04991507, size.height * 0.8806489),
//         [Color(0xff7df6c1).withOpacity(1), Color(0xff30C584).withOpacity(1)],
//         [0.234375, 1]);
//     canvas.drawPath(path_1, paint_1_fill);
//
//     // Draw the separated path_0
//     canvas.save();
//     // canvas.scale(0.9, 0.99); // Scale down path_2 to half its size
//
//     IconPainter2().paint(canvas, size);
//     canvas.restore();
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// class IconPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.scale(0.9, 0.99); // Scale down path_2 to half its size
//
//     Path path_0 = Path();
//     path_0.moveTo(size.width * 0.4655110, size.height * 0.4744577);
//     path_0.cubicTo(
//         size.width * 0.4651544,
//         size.height * 0.4745864,
//         size.width * 0.4640680,
//         size.height * 0.4748676,
//         size.width * 0.4630956,
//         size.height * 0.4750827);
//     path_0.cubicTo(
//         size.width * 0.4584853,
//         size.height * 0.4760974,
//         size.width * 0.4548382,
//         size.height * 0.4813327,
//         size.width * 0.4548382,
//         size.height * 0.4869357);
//     path_0.lineTo(size.width * 0.4548382, size.height * 0.4907206);
//     path_0.lineTo(size.width * 0.4848511, size.height * 0.5427022);
//     path_0.lineTo(size.width * 0.5148640, size.height * 0.5946838);
//     path_0.lineTo(size.width * 0.5076507, size.height * 0.5988511);
//     path_0.cubicTo(
//         size.width * 0.4087555,
//         size.height * 0.6559853,
//         size.width * 0.3486893,
//         size.height * 0.7503971,
//         size.width * 0.3348750,
//         size.height * 0.8704136);
//     path_0.lineTo(size.width * 0.3345588, size.height * 0.8731618);
//     path_0.lineTo(size.width * 0.6884191, size.height * 0.8731618);
//     path_0.lineTo(size.width * 1.042279, size.height * 0.8731618);
//     path_0.lineTo(size.width * 1.041840, size.height * 0.8681507);
//     path_0.cubicTo(
//         size.width * 1.031855,
//         size.height * 0.7539596,
//         size.width * 0.9676158,
//         size.height * 0.6559118,
//         size.width * 0.8630257,
//         size.height * 0.5952279);
//     path_0.cubicTo(
//         size.width * 0.8623199,
//         size.height * 0.5948199,
//         size.width * 0.8686801,
//         size.height * 0.5833364,
//         size.width * 0.8914228,
//         size.height * 0.5439688);
//     path_0.cubicTo(
//         size.width * 0.9239908,
//         size.height * 0.4875919,
//         size.width * 0.9227261,
//         size.height * 0.4899816,
//         size.width * 0.9223070,
//         size.height * 0.4856103);
//     path_0.cubicTo(
//         size.width * 0.9213327,
//         size.height * 0.4754890,
//         size.width * 0.9091176,
//         size.height * 0.4709191,
//         size.width * 0.9016452,
//         size.height * 0.4778842);
//     path_0.cubicTo(
//         size.width * 0.9006857,
//         size.height * 0.4787776,
//         size.width * 0.8864246,
//         size.height * 0.5028989,
//         size.width * 0.8699522,
//         size.height * 0.5314853);
//     path_0.cubicTo(
//         size.width * 0.8481324,
//         size.height * 0.5693548,
//         size.width * 0.8397408,
//         size.height * 0.5833842,
//         size.width * 0.8390331,
//         size.height * 0.5831765);
//     path_0.cubicTo(
//         size.width * 0.8385000,
//         size.height * 0.5830221,
//         size.width * 0.8338437,
//         size.height * 0.5810993,
//         size.width * 0.8286857,
//         size.height * 0.5789044);
//     path_0.cubicTo(
//         size.width * 0.7421985,
//         size.height * 0.5421066,
//         size.width * 0.6346857,
//         size.height * 0.5423768,
//         size.width * 0.5465276,
//         size.height * 0.5796121);
//     path_0.cubicTo(
//         size.width * 0.5415018,
//         size.height * 0.5817335,
//         size.width * 0.5371893,
//         size.height * 0.5832482,
//         size.width * 0.5369412,
//         size.height * 0.5829743);
//     path_0.cubicTo(
//         size.width * 0.5366949,
//         size.height * 0.5827022,
//         size.width * 0.5233254,
//         size.height * 0.5596342,
//         size.width * 0.5072316,
//         size.height * 0.5317151);
//     path_0.cubicTo(
//         size.width * 0.4911379,
//         size.height * 0.5037941,
//         size.width * 0.4772923,
//         size.height * 0.4800441,
//         size.width * 0.4764651,
//         size.height * 0.4789393);
//     path_0.cubicTo(
//         size.width * 0.4743474,
//         size.height * 0.4761066,
//         size.width * 0.4680460,
//         size.height * 0.4735294,
//         size.width * 0.4655110,
//         size.height * 0.4744577);
//     path_0.close();
//     path_0.moveTo(size.width * 0.5327537, size.height * 0.7144228);
//     path_0.cubicTo(
//         size.width * 0.5550000,
//         size.height * 0.7202169,
//         size.width * 0.5624430,
//         size.height * 0.7478493,
//         size.width * 0.5459835,
//         size.height * 0.7635460);
//     path_0.cubicTo(
//         size.width * 0.5287426,
//         size.height * 0.7799871,
//         size.width * 0.5008732,
//         size.height * 0.7707261,
//         size.width * 0.4969099,
//         size.height * 0.7472390);
//     path_0.cubicTo(
//         size.width * 0.4935276,
//         size.height * 0.7271820,
//         size.width * 0.5130643,
//         size.height * 0.7092960,
//         size.width * 0.5327537,
//         size.height * 0.7144228);
//     path_0.close();
//     path_0.moveTo(size.width * 0.8579890, size.height * 0.7143971);
//     path_0.cubicTo(
//         size.width * 0.8780184,
//         size.height * 0.7196121,
//         size.width * 0.8867040,
//         size.height * 0.7420496,
//         size.width * 0.8753015,
//         size.height * 0.7591213);
//     path_0.cubicTo(
//         size.width * 0.8595221,
//         size.height * 0.7827482,
//         size.width * 0.8222169,
//         size.height * 0.7713107,
//         size.width * 0.8222169,
//         size.height * 0.7428456);
//     path_0.cubicTo(
//         size.width * 0.8222169,
//         size.height * 0.7238971,
//         size.width * 0.8400404,
//         size.height * 0.7097224,
//         size.width * 0.8579890,
//         size.height * 0.7143971);
//     path_0.close();
//
//     Paint paint2Fill = Paint()..style = PaintingStyle.fill;
//     paint2Fill.color = const Color(0xff30C584).withOpacity(1.0);
//     canvas.drawPath(path_0, paint2Fill);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// class IconPainter2 extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.scale(0.85, .94);
//
//     Path path_2 = Path();
//     path_2.moveTo(size.width * 0.8277518, size.height * 0.4201379);
//     path_2.cubicTo(
//         size.width * 0.8165000,
//         size.height * 0.4370147,
//         size.width * 0.7975607,
//         size.height * 0.4471507,
//         size.width * 0.7772776,
//         size.height * 0.4471507);
//     path_2.lineTo(size.width * 0.7116930, size.height * 0.4471507);
//     path_2.cubicTo(
//         size.width * 0.6914099,
//         size.height * 0.4471507,
//         size.width * 0.6724706,
//         size.height * 0.4370147,
//         size.width * 0.6612187,
//         size.height * 0.4201379);
//     path_2.lineTo(size.width * 0.6308971, size.height * 0.3746544);
//     path_2.cubicTo(
//         size.width * 0.6236581,
//         size.height * 0.3637445,
//         size.width * 0.6314063,
//         size.height * 0.3492647,
//         size.width * 0.6444577,
//         size.height * 0.3492647);
//     path_2.lineTo(size.width * 0.8445129, size.height * 0.3492647);
//     path_2.cubicTo(
//         size.width * 0.8575643,
//         size.height * 0.3492647,
//         size.width * 0.8653125,
//         size.height * 0.3637445,
//         size.width * 0.8580735,
//         size.height * 0.3746544);
//     path_2.lineTo(size.width * 0.8277518, size.height * 0.4201379);
//     path_2.close();
//     path_2.moveTo(size.width * 0.6659724, size.height * 0.4883437);
//     path_2.cubicTo(
//         size.width * 0.6746213,
//         size.height * 0.4827592,
//         size.width * 0.6847151,
//         size.height * 0.4797794,
//         size.width * 0.6950092,
//         size.height * 0.4797794);
//     path_2.lineTo(size.width * 0.7939614, size.height * 0.4797794);
//     path_2.cubicTo(
//         size.width * 0.8042555,
//         size.height * 0.4797794,
//         size.width * 0.8142978,
//         size.height * 0.4828401,
//         size.width * 0.8229982,
//         size.height * 0.4883437);
//     path_2.cubicTo(
//         size.width * 0.8808125,
//         size.height * 0.5253585,
//         size.width * 1.005515,
//         size.height * 0.6050937,
//         size.width * 1.005515,
//         size.height * 0.7734375);
//     path_2.cubicTo(
//         size.width * 1.005515,
//         size.height * 0.8274779,
//         size.width * 0.9616691,
//         size.height * 0.8713235,
//         size.width * 0.9076287,
//         size.height * 0.8713235);
//     path_2.lineTo(size.width * 0.5813419, size.height * 0.8713235);
//     path_2.cubicTo(
//         size.width * 0.5273015,
//         size.height * 0.8713235,
//         size.width * 0.4834559,
//         size.height * 0.8274779,
//         size.width * 0.4834559,
//         size.height * 0.7734375);
//     path_2.cubicTo(
//         size.width * 0.4834559,
//         size.height * 0.6050937,
//         size.width * 0.6081581,
//         size.height * 0.5253585,
//         size.width * 0.6659724,
//         size.height * 0.4883437);
//     path_2.close();
//     path_2.moveTo(size.width * 0.7650827, size.height * 0.5776654);
//     path_2.cubicTo(
//         size.width * 0.7650257,
//         size.height * 0.5776654,
//         size.width * 0.7649798,
//         size.height * 0.5776195,
//         size.width * 0.7649798,
//         size.height * 0.5775625);
//     path_2.cubicTo(
//         size.width * 0.7649246,
//         size.height * 0.5662923,
//         size.width * 0.7557684,
//         size.height * 0.5571710,
//         size.width * 0.7444853,
//         size.height * 0.5571710);
//     path_2.cubicTo(
//         size.width * 0.7331673,
//         size.height * 0.5571710,
//         size.width * 0.7239908,
//         size.height * 0.5663474,
//         size.width * 0.7239908,
//         size.height * 0.5776654);
//     path_2.cubicTo(
//         size.width * 0.7239908,
//         size.height * 0.5812335,
//         size.width * 0.7214853,
//         size.height * 0.5842812,
//         size.width * 0.7180570,
//         size.height * 0.5852702);
//     path_2.cubicTo(
//         size.width * 0.7145018,
//         size.height * 0.5862941,
//         size.width * 0.7110772,
//         size.height * 0.5875331,
//         size.width * 0.7077776,
//         size.height * 0.5889835);
//     path_2.cubicTo(
//         size.width * 0.6924835,
//         size.height * 0.5959173,
//         size.width * 0.6793290,
//         size.height * 0.6087647,
//         size.width * 0.6760662,
//         size.height * 0.6274246);
//     path_2.cubicTo(
//         size.width * 0.6742316,
//         size.height * 0.6378254,
//         size.width * 0.6752518,
//         size.height * 0.6478162,
//         size.width * 0.6795331,
//         size.height * 0.6569945);
//     path_2.cubicTo(
//         size.width * 0.6838162,
//         size.height * 0.6659669,
//         size.width * 0.6904449,
//         size.height * 0.6722886,
//         size.width * 0.6971746,
//         size.height * 0.6768768);
//     path_2.cubicTo(
//         size.width * 0.7090018,
//         size.height * 0.6849320,
//         size.width * 0.7246029,
//         size.height * 0.6896232,
//         size.width * 0.7365312,
//         size.height * 0.6931912);
//     path_2.lineTo(size.width * 0.7387757, size.height * 0.6939044);
//     path_2.cubicTo(
//         size.width * 0.7529485,
//         size.height * 0.6981875,
//         size.width * 0.7626342,
//         size.height * 0.7014504,
//         size.width * 0.7686507,
//         size.height * 0.7058346);
//     path_2.cubicTo(
//         size.width * 0.7712004,
//         size.height * 0.7076710,
//         size.width * 0.7721176,
//         size.height * 0.7090974,
//         size.width * 0.7725257,
//         size.height * 0.7100147);
//     path_2.cubicTo(
//         size.width * 0.7728309,
//         size.height * 0.7108309,
//         size.width * 0.7734430,
//         size.height * 0.7126673,
//         size.width * 0.7727298,
//         size.height * 0.7168474);
//     path_2.cubicTo(
//         size.width * 0.7721176,
//         size.height * 0.7204154,
//         size.width * 0.7701801,
//         size.height * 0.7233732,
//         size.width * 0.7645717,
//         size.height * 0.7258199);
//     path_2.cubicTo(
//         size.width * 0.7583529,
//         size.height * 0.7284706,
//         size.width * 0.7482574,
//         size.height * 0.7297960,
//         size.width * 0.7352059,
//         size.height * 0.7277574);
//     path_2.cubicTo(
//         size.width * 0.7290882,
//         size.height * 0.7267371,
//         size.width * 0.7181783,
//         size.height * 0.7230662,
//         size.width * 0.7084926,
//         size.height * 0.7197022);
//     path_2.cubicTo(
//         size.width * 0.7062482,
//         size.height * 0.7188860,
//         size.width * 0.7041066,
//         size.height * 0.7181728,
//         size.width * 0.7020680,
//         size.height * 0.7175607);
//     path_2.cubicTo(
//         size.width * 0.6913621,
//         size.height * 0.7139926,
//         size.width * 0.6798401,
//         size.height * 0.7198033,
//         size.width * 0.6762702,
//         size.height * 0.7305110);
//     path_2.cubicTo(
//         size.width * 0.6727022,
//         size.height * 0.7412169,
//         size.width * 0.6785147,
//         size.height * 0.7527390,
//         size.width * 0.6892206,
//         size.height * 0.7563070);
//     path_2.cubicTo(
//         size.width * 0.6904449,
//         size.height * 0.7567151,
//         size.width * 0.6919743,
//         size.height * 0.7572243,
//         size.width * 0.6937077,
//         size.height * 0.7578364);
//     path_2.cubicTo(
//         size.width * 0.7001471,
//         size.height * 0.7600386,
//         size.width * 0.7095202,
//         size.height * 0.7632169,
//         size.width * 0.7179687,
//         size.height * 0.7655496);
//     path_2.cubicTo(
//         size.width * 0.7215368,
//         size.height * 0.7665331,
//         size.width * 0.7240919,
//         size.height * 0.7697371,
//         size.width * 0.7240919,
//         size.height * 0.7734375);
//     path_2.cubicTo(
//         size.width * 0.7240919,
//         size.height * 0.7847555,
//         size.width * 0.7332684,
//         size.height * 0.7939320,
//         size.width * 0.7445864,
//         size.height * 0.7939320);
//     path_2.cubicTo(
//         size.width * 0.7559063,
//         size.height * 0.7939320,
//         size.width * 0.7650827,
//         size.height * 0.7847555,
//         size.width * 0.7650827,
//         size.height * 0.7734375);
//     path_2.cubicTo(
//         size.width * 0.7650827,
//         size.height * 0.7701875,
//         size.width * 0.7674099,
//         size.height * 0.7674338,
//         size.width * 0.7705570,
//         size.height * 0.7666195);
//     path_2.cubicTo(
//         size.width * 0.7740754,
//         size.height * 0.7657077,
//         size.width * 0.7774743,
//         size.height * 0.7645570,
//         size.width * 0.7807849,
//         size.height * 0.7631397);
//     path_2.cubicTo(
//         size.width * 0.7967923,
//         size.height * 0.7563070,
//         size.width * 0.8097426,
//         size.height * 0.7430515,
//         size.width * 0.8130055,
//         size.height * 0.7236783);
//     path_2.cubicTo(
//         size.width * 0.8148401,
//         size.height * 0.7130754,
//         size.width * 0.8140257,
//         size.height * 0.7029798,
//         size.width * 0.8099467,
//         size.height * 0.6937004);
//     path_2.cubicTo(
//         size.width * 0.8059706,
//         size.height * 0.6845239,
//         size.width * 0.7995460,
//         size.height * 0.6777941,
//         size.width * 0.7927151,
//         size.height * 0.6727978);
//     path_2.cubicTo(
//         size.width * 0.7802757,
//         size.height * 0.6638254,
//         size.width * 0.7638585,
//         size.height * 0.6588290,
//         size.width * 0.7515202,
//         size.height * 0.6550570);
//     path_2.lineTo(size.width * 0.7507059, size.height * 0.6548529);
//     path_2.cubicTo(
//         size.width * 0.7362261,
//         size.height * 0.6504688,
//         size.width * 0.7264375,
//         size.height * 0.6474099,
//         size.width * 0.7202169,
//         size.height * 0.6432279);
//     path_2.cubicTo(
//         size.width * 0.7173915,
//         size.height * 0.6412721,
//         size.width * 0.7158474,
//         size.height * 0.6379467,
//         size.width * 0.7164449,
//         size.height * 0.6345625);
//     path_2.cubicTo(
//         size.width * 0.7167500,
//         size.height * 0.6326250,
//         size.width * 0.7183824,
//         size.height * 0.6292592,
//         size.width * 0.7248070,
//         size.height * 0.6263033);
//     path_2.cubicTo(
//         size.width * 0.7313327,
//         size.height * 0.6233456,
//         size.width * 0.7415276,
//         size.height * 0.6217151,
//         size.width * 0.7539687,
//         size.height * 0.6236507);
//     path_2.cubicTo(
//         size.width * 0.7583529,
//         size.height * 0.6243658,
//         size.width * 0.7722187,
//         size.height * 0.6270165,
//         size.width * 0.7760938,
//         size.height * 0.6280368);
//     path_2.cubicTo(
//         size.width * 0.7870037,
//         size.height * 0.6308915,
//         size.width * 0.7981195,
//         size.height * 0.6244669,
//         size.width * 0.8010754,
//         size.height * 0.6135570);
//     path_2.cubicTo(
//         size.width * 0.8040331,
//         size.height * 0.6026471,
//         size.width * 0.7975074,
//         size.height * 0.5915331,
//         size.width * 0.7865974,
//         size.height * 0.5885754);
//     path_2.cubicTo(
//         size.width * 0.7827114,
//         size.height * 0.5875165,
//         size.width * 0.7745460,
//         size.height * 0.5858456,
//         size.width * 0.7680570,
//         size.height * 0.5846213);
//     path_2.cubicTo(
//         size.width * 0.7663934,
//         size.height * 0.5843088,
//         size.width * 0.7651838,
//         size.height * 0.5828585,
//         size.width * 0.7651838,
//         size.height * 0.5811673);
//     path_2.lineTo(size.width * 0.7651838, size.height * 0.5777665);
//     path_2.cubicTo(
//         size.width * 0.7651838,
//         size.height * 0.5777114,
//         size.width * 0.7651379,
//         size.height * 0.5776654,
//         size.width * 0.7650827,
//         size.height * 0.5776654);
//     path_2.close();
//     Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
//     paint_2_fill.color = Color(0xff30C584).withOpacity(1.0);
//     canvas.drawPath(path_2, paint_2_fill);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
