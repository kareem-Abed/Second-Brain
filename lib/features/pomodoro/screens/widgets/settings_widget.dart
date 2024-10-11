import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_brain/features/pomodoro/controller/pomodoro_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
    required this.controller,
  });

  final PomodoroController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.showSettings.value
          ? Expanded(
              flex: 1,
              child: Container(
                height: 640,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(
                  top: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  color: KColors.darkModeCard,
                  border:
                      Border.all(color: KColors.darkModeCardBorder, width: 1),
                  borderRadius: BorderRadius.circular(KSizes.borderRadius),
                ),
                child: TimeandRoundWidget(controller: controller),
              ),
            )
          : SizedBox();
    });
  }
}

class TimeandRoundWidget extends StatelessWidget {
  const TimeandRoundWidget({
    super.key,
    required this.controller,
  });

  final PomodoroController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('settings', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        Spacer(),
        Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Session',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              value: controller.sessionName.value,
              items: <String>[
                'Project',
                'Work',
                'Study',
                'Exercise',
                'Break'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.sessionName.value = newValue;
                  controller.saveValues();
                  controller.resetTimer();
                  controller.isBreak.value = false;
                }
              },
              style: Theme.of(context).textTheme.bodyLarge,
              dropdownColor: KColors.darkModeSubCard,
            ),
          );
        }),
        Spacer(),
        Obx(() {
          return DurationWidget(
            title: 'Study Duration',
            sliderValue: controller.focusDuration.value,
            max: 60,
            min: 5,
            updateValue: (newValue) {
              controller.focusDuration.value = newValue;
              controller.resetTimer();
              controller.saveValues();
            },
            minText: 'min',
          );
        }),
        Spacer(),
        Obx(() {
          return DurationWidget(
            title: 'Short break duration',
            sliderValue: controller.breakDuration.value,
            max: 30,
            min: 1,
            updateValue: (newValue) {
              controller.breakDuration.value = newValue;
              controller.resetTimer();
              controller.saveValues();
            },
            minText: 'min',
          );
        }),
        Spacer(),
        Obx(() {
          return DurationWidget(
            title: 'Long break duration',
            sliderValue: controller.longBreakDuration.value,
            max: 45,
            min: 1,
            updateValue: (newValue) {
              controller.longBreakDuration.value = newValue;
              controller.resetTimer();
              controller.saveValues();
            },
            minText: 'min',
          );
        }),
        Spacer(),
        Obx(() {
          return DurationWidget(
            title: 'Rounds',
            sliderValue: controller.numberOfSessionRounds.value,
            max: 15,
            min: 2,
            updateValue: (newValue) {
              controller.numberOfSessionRounds.value = newValue;
              controller.sessionRounds.value = 0;
              controller.resetTimer();
              controller.saveValues();
            },
            minText: '',
          );
        }),
        Spacer(),
      ],
    );
  }
}

// ignore: must_be_immutable
class DurationWidget extends StatelessWidget {
  DurationWidget({
    super.key,
    required this.title,
    required this.sliderValue,
    required this.max,
    required this.min,
    required this.updateValue,
    required this.minText,
  });
  final String title;
  final double max;
  final double min;
  int sliderValue;
  String minText;
  void Function(int newValue) updateValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(title + ": $sliderValue",
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          Slider(
            label: "$sliderValue ",
            max: max,
            min: min,
            value: sliderValue.toDouble(),
            activeColor: KColors.primary,
            inactiveColor: KColors.white,
            onChanged: (value) {
              sliderValue = value.toInt();
              updateValue(sliderValue);
            },
          ),
          Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text('${min.toInt()} $minText')),
          Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Text('${max.toInt()} $minText')),
        ],
      ),
    );
  }
}
