import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:second_brain/utils/constants/colors.dart';

import '../../controllers/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: HeatMap(
          startDate: createDateTimeObject(startDate),
          endDate: DateTime.now().add(const Duration(days: 0)),
          datasets: datasets,
          colorMode: ColorMode.color,
          defaultColor: KColors.darkModeSubCard,
          textColor: Colors.white,
          showColorTip: false,
          colorTipCount: 10,
          showText: true,
          scrollable: true,
          size: 42,
          // colorsets: const {
          //   1: Color.fromARGB(20, 2, 179, 8),
          //   2: Color.fromARGB(40, 2, 179, 8),
          //   3: Color.fromARGB(60, 2, 179, 8),
          //   4: Color.fromARGB(80, 2, 179, 8),
          //   5: Color.fromARGB(100, 2, 179, 8),
          //   6: Color.fromARGB(120, 2, 179, 8),
          //   7: Color.fromARGB(150, 2, 179, 8),
          //   8: Color.fromARGB(180, 2, 179, 8),
          //   9: Color.fromARGB(220, 2, 179, 8),
          //   10: Color.fromARGB(255, 2, 179, 8),
          // },
          colorsets: const {
            1: Color.fromARGB(20, 3, 169, 244),
            2: Color.fromARGB(40, 3, 169, 244),
            3: Color.fromARGB(60, 3, 169, 244),
            4: Color.fromARGB(80, 3, 169, 244),
            5: Color.fromARGB(100, 3, 169, 244),
            6: Color.fromARGB(120, 3, 169, 244),
            7: Color.fromARGB(150, 3, 169, 244),
            8: Color.fromARGB(180, 3, 169, 244),
            9: Color.fromARGB(220, 3, 169, 244),
            10: Color.fromARGB(255, 3, 169, 244),
          },
          // onClick: (value) {
          //   ScaffoldMessenger.of(context)
          //       .showSnackBar(SnackBar(content: Text(value.toString())));
          // },
        ),
      ),
    );
  }
}
