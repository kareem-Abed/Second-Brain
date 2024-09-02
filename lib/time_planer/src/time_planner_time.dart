import 'package:flutter/material.dart';
import 'package:al_maafer/time_planer/src/config/global_config.dart' as config;

/// Show the hour for each row of time planner
class TimePlannerTime extends StatelessWidget {
  /// Text it will be show as hour
  final String? time;
  final String? textStar;
  final bool? setTimeOnAxis;
  final Color? textColor;

  /// Show the hour for each row of time planner
  const TimePlannerTime({
    Key? key,
    this.time,
    this.setTimeOnAxis,
    this.textColor,
    this.textStar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          // padding: EdgeInsets.symmetric(
          //   horizontal: !config.use24HourFormat ? 2 : 0,
          // ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade800,
              width: 1.2,
            ),
          ),
        ),
        height: config.cellHeight!.toDouble() ,
        width: 64,
        child: !setTimeOnAxis!
            ? Text(
                time! + '\n' + textStar!,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              )
            : Center(
                child: Text(
                  time! + '\n' + textStar!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
              ),
      ),
    );
  }
}
