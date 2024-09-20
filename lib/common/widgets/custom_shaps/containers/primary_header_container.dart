import 'package:flutter/material.dart';
import 'package:second_brain/common/widgets/custom_shaps/containers/circular_container.dart';
import 'package:second_brain/common/widgets/custom_shaps/curved_edges/curved_edges_widget.dart';
import 'package:second_brain/utils/constants/colors.dart';

class TPrimaryHeaderContainer2 extends StatelessWidget {
  TPrimaryHeaderContainer2({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              color: KColors.primary, borderRadius: BorderRadius.circular(16)),
        ),

        Positioned(
            top: -250,
            right: -200,
            child: TCircularContainer(
              backgroundColor: KColors.white.withOpacity(0.15),
            )),
        Positioned(
            top: 100,
            right: 50,
            child: TCircularContainer(
              width: 320,
              height: 320,
              backgroundColor: KColors.white.withOpacity(0.25),
            )),
        Positioned(
          top: 60,
          left: 70,
          child: TCircularContainer(
            width: 120,
            height: 120,
            backgroundColor: KColors.white.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: 160,
          child: TCircularContainer(
            width: 100,
            height: 100,
            backgroundColor: KColors.white.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: 150,
          right: 30,
          child: TCircularContainer(
            width: 100,
            height: 100,
            backgroundColor: KColors.white.withOpacity(0.15),
          ),
        ),
        Positioned(
          bottom: 80,
          left: 50,
          child: TCircularContainer(
            width: 80,
            height: 80,
            backgroundColor: KColors.white.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 150,
          right: 100,
          child: TCircularContainer(
            width: 150,
            height: 150,
            backgroundColor: KColors.white.withOpacity(0.1),
          ),
        ),
        Positioned(
          top: 300,
          left: 200,
          child: TCircularContainer(
            width: 140,
            height: 140,
            backgroundColor: KColors.white.withOpacity(0.3),
          ),
        ),

        Positioned(
          bottom: 200,
          right: 200,
          child: TCircularContainer(
            width: 90,
            height: 90,
            backgroundColor: KColors.white.withOpacity(0.3),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 300,
          child: TCircularContainer(
            width: 110,
            height: 110,
            backgroundColor: KColors.white.withOpacity(0.25),
          ),
        ),
        Positioned(
          top: 400,
          right: 20,
          child: TCircularContainer(
            width: 130,
            height: 130,
            backgroundColor: KColors.white.withOpacity(0.2),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 50,
          child: TCircularContainer(
            width: 70,
            height: 70,
            backgroundColor: KColors.white.withOpacity(0.2),
          ),
        ),
        Positioned(
          top: -25,
          left: 10,
          child: TCircularContainer(
            width: 100,
            height: 100,
            backgroundColor: KColors.white.withOpacity(0.1),
          ),
        ),
        Positioned(
          bottom: -150,
          right: -100,
          child: TCircularContainer(
            width: 250,
            height: 250,
            backgroundColor: KColors.white.withOpacity(0.15),
          ),
        ),
        // Positioned(
        //   top: 500,
        //   left: 100,
        //   child: TCircularContainer(
        //     width: 180,
        //     height: 180,
        //     backgroundColor: KColors.white.withOpacity(0.2),
        //   ),
        // ),
        // Positioned(
        //   top: -200,
        //   right: -150,
        //   child: TCircularContainer(
        //     width: 220,
        //     height: 220,
        //     backgroundColor: KColors.white.withOpacity(0.3),
        //   ),
        // ),
        // Positioned(
        //   bottom: 300,
        //   left: -100,
        //   child: TCircularContainer(
        //     width: 210,
        //     height: 210,
        //     backgroundColor: KColors.white.withOpacity(0.25),
        //   ),
        // ),
        child,
      ],
    );
  }
}

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
    required this.useCurvedEdges,
  });
  final Widget child;
  final bool useCurvedEdges;
  @override
  Widget build(BuildContext context) {
    return useCurvedEdges
        ? TCurvedEdgWidget(
            child: Container(
                color: KColors.primary,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  // height: 400,
                  child: Stack(
                    children: [
                      Positioned(
                          top: -250,
                          right: -200,
                          child: TCircularContainer(
                            backgroundColor: KColors.white.withOpacity(0.1),
                          )),
                      Positioned(
                          top: 100,
                          right: 200,
                          child: TCircularContainer(
                            backgroundColor: KColors.white.withOpacity(0.2),
                          )),
                      Positioned(
                          bottom: 100,
                          left: 5,
                          child: TCircularContainer(
                            width: 150,
                            height: 150,
                            backgroundColor: KColors.white.withOpacity(0.2),
                          )),
                      Positioned(
                          bottom: -150,
                          left: -250,
                          child: TCircularContainer(
                            backgroundColor: KColors.white.withOpacity(0.2),
                          )),
                      Positioned(
                          bottom: 100,
                          left: -300,
                          child: TCircularContainer(
                            backgroundColor: KColors.white.withOpacity(0.3),
                          )),
                      child,
                    ],
                  ),
                )),
          )
        : Container(
            color: KColors.primary,
            padding: const EdgeInsets.all(0),
            child: SizedBox(
              // height: 400,
              child: Stack(
                children: [
                  Positioned(
                      top: -250,
                      right: -200,
                      child: TCircularContainer(
                        backgroundColor: KColors.white.withOpacity(0.1),
                      )),
                  Positioned(
                      top: 100,
                      right: 200,
                      child: TCircularContainer(
                        backgroundColor: KColors.white.withOpacity(0.2),
                      )),
                  Positioned(
                      bottom: 100,
                      left: 5,
                      child: TCircularContainer(
                        width: 150,
                        height: 150,
                        backgroundColor: KColors.white.withOpacity(0.2),
                      )),
                  Positioned(
                      bottom: -150,
                      left: -250,
                      child: TCircularContainer(
                        backgroundColor: KColors.white.withOpacity(0.2),
                      )),
                  Positioned(
                      bottom: 100,
                      left: -300,
                      child: TCircularContainer(
                        backgroundColor: KColors.white.withOpacity(0.3),
                      )),
                  child,
                ],
              ),
            ));
  }
}
