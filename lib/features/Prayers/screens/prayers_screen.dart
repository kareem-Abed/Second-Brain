import 'package:flutter/material.dart' as prayers_screen;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:second_brain/features/Prayers/controllers/Prayers_controller.dart';
import 'package:second_brain/features/Prayers/screens/widgets/habit_tile.dart';
import 'package:second_brain/features/Prayers/screens/widgets/month_summary.dart';
import 'package:second_brain/features/Prayers/screens/widgets/my_alert_box.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/constants/sizes.dart';

class PrayersScreen extends prayers_screen.StatefulWidget {
  const PrayersScreen({super.key});

  @override
  prayers_screen.State<PrayersScreen> createState() => _PrayersScreenState();
}

class _PrayersScreenState extends prayers_screen.State<PrayersScreen> {
  final _myBox = GetStorage();

  final controller = Get.put(PrayersController());

  @override
  void initState() {
    super.initState();

    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data
    if (_myBox.read("Prayers_HABIT_LIST") == null) {
      controller.createDefaultData();
    } else {
      controller.loadData();
    }

    // update the database
    controller.updateDatabase();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      controller.toDaysHabitList[index][1] = value;
    });
    controller.updateDatabase();
  }

  // create a new habit
  final _newHabitNameController = prayers_screen.TextEditingController();
  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    prayers_screen.showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter habit name..',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save new habit
  void saveNewHabit() {
    // add new habit to todays habit list
    setState(() {
      controller.toDaysHabitList.add([_newHabitNameController.text, false]);
    });

    // clear textfield
    _newHabitNameController.clear();
    // pop dialog box
    prayers_screen.Navigator.of(context).pop();
    controller.updateDatabase();
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    prayers_screen.Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    prayers_screen.Navigator.pop(context);
    prayers_screen.showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: controller.toDaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      controller.toDaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    prayers_screen.Navigator.pop(context);
    controller.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    prayers_screen.Navigator.pop(context);
    setState(() {
      controller.toDaysHabitList.removeAt(index);
    });
    controller.updateDatabase();
  }

  @override
  prayers_screen.Widget build(prayers_screen.BuildContext context) {
    return prayers_screen.Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: prayers_screen.ListView(
        children: [
          prayers_screen.Container(
            margin: const prayers_screen.EdgeInsets.only(
                top: 16, left: 16, right: 16),
            decoration: prayers_screen.BoxDecoration(
              color: KColors.darkModeCard,
              border: prayers_screen.Border.all(
                  color: KColors.darkModeCardBorder, width: 1),
              borderRadius:
                  prayers_screen.BorderRadius.circular(KSizes.borderRadius),
            ),
            child: prayers_screen.Column(
              children: [
                const prayers_screen.Padding(
                  padding: prayers_screen.EdgeInsets.only(
                      top: 16, left: 16, right: 16),
                  child: prayers_screen.Align(
                      alignment: prayers_screen.Alignment.centerLeft,
                      child: prayers_screen.Text('Habit Tracker',
                          style: prayers_screen.TextStyle(
                              color: prayers_screen.Colors.white,
                              fontSize: 24))),
                ),
                MonthlySummary(
                  datasets: controller.heatMapDataSet,
                  startDate: controller.startDate,
                ),
              ],
            ),
          ),
          prayers_screen.Container(
            margin: const prayers_screen.EdgeInsets.only(
                top: 16, left: 16, right: 16),
            padding: const prayers_screen.EdgeInsets.only(
                top: 16, left: 16, right: 16),
            decoration: prayers_screen.BoxDecoration(
              color: KColors.darkModeCard,
              border: prayers_screen.Border.all(
                color: KColors.darkModeCardBorder,
              ),
              borderRadius:
                  prayers_screen.BorderRadius.circular(KSizes.borderRadius),
            ),
            child: prayers_screen.Column(
              children: [
                const prayers_screen.Row(
                  mainAxisAlignment: prayers_screen.MainAxisAlignment.end,
                  children: [
                    prayers_screen.Text('Prayers',
                        style: prayers_screen.TextStyle(
                            color: prayers_screen.Colors.white, fontSize: 24)),
                  ],
                ),
                const prayers_screen.SizedBox(height: 16),
                AlignedGridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  itemCount: controller.toDaysHabitList.length,
                  itemBuilder: (context, index) {
                    return HabitTile(
                      habitName: controller.toDaysHabitList[index][0],
                      habitCompleted: controller.toDaysHabitList[index][1],
                      onChanged: (value) => checkBoxTapped(value, index),
                      settingsTapped: (context) => openHabitSettings(index),
                      deleteTapped: (context) => deleteHabit(index),
                    );
                  },
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                ),
                const prayers_screen.SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
