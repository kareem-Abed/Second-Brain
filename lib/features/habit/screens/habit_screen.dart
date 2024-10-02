import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:second_brain/features/habit/screens/widgets/habit_tile.dart';
import 'package:second_brain/features/habit/screens/widgets/month_summary.dart';
import 'package:second_brain/features/habit/screens/widgets/my_alert_box.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/utils/constants/colors.dart';
import 'package:second_brain/utils/constants/sizes.dart';
import '../controllers/Habit_controller.dart';
import '../data/habit_database.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  HabitDatabase db = HabitDatabase();
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
      db.createDefaultData();
    } else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
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
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });

    // clear textfield
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();
    db.updateDatabase();
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
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.darkModeBackground,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => createNewHabit(),
          child: Icon(FontAwesomeIcons.plus),
        ),
      ]),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 32, left: 32, right: 32),
            decoration: BoxDecoration(
              color: KColors.darkModeCard,
              border: Border.all(color: KColors.darkModeCardBorder, width: 1),
              borderRadius: BorderRadius.circular(KSizes.borderRadius),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Habit Tracker',
                          style: TextStyle(color: Colors.white, fontSize: 24))),
                ),
                MonthlySummary(
                  datasets: db.heatMapDataSet,
                  startDate: controller.START_DATE,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, left: 30, right: 30),
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Habits',
                        style: TextStyle(color: Colors.white, fontSize: 24))),
                SizedBox(height: 16),
                AlignedGridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  itemCount: db.todaysHabitList.length,
                  itemBuilder: (context, index) {
                    return HabitTile(
                      habitName: db.todaysHabitList[index][0],
                      habitCompleted: db.todaysHabitList[index][1],
                      onChanged: (value) => checkBoxTapped(value, index),
                      settingsTapped: (context) => openHabitSettings(index),
                      deleteTapped: (context) => deleteHabit(index),
                    );
                  },
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
