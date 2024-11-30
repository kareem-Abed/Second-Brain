import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:second_brain/features/habit/screens/widgets/habit_tile.dart';
import 'package:second_brain/features/habit/screens/widgets/month_summary.dart';
import 'package:second_brain/features/habit/screens/widgets/my_alert_box.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import '../controllers/habit_controller.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final _myBox = GetStorage();

  final controller = Get.put(HabitController());

  @override
  void initState() {
    super.initState();
    // Initialize GetStorage
    GetStorage.init();

    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data
    if (_myBox.read("CURRENT_HABIT_LIST") == null) {
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
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    showDialog(
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
    Navigator.of(context).pop();
    controller.updateDatabase();
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    Navigator.pop(context);
    showDialog(
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
    Navigator.pop(context);
    controller.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    Navigator.pop(context);
    setState(() {
      controller.toDaysHabitList.removeAt(index);
    });
    controller.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            decoration: BoxDecoration(
              color: KColors.darkModeCard,
              border: Border.all(color: KColors.darkModeCardBorder, width: 1),
              borderRadius: BorderRadius.circular(KSizes.borderRadius),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Habit Tracker',
                          style: TextStyle(color: Colors.white, fontSize: 24))),
                ),
                MonthlySummary(
                  datasets: controller.heatMapDataSet,
                  startDate: controller.startDate,
                ),
              ],
            ),
          ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      backgroundColor: KColors.darkModeSubCard,
                      onPressed: () => createNewHabit(),
                      child: const Icon(
                        IconsaxPlusBroken.add,
                        size: 30,
                      ),
                    ),
                    // const SizedBox(width: 16),
                    const Text('Habits',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
