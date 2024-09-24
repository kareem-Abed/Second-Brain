import 'package:flutter/material.dart';
import 'package:second_brain/features/habit/screens/widgets/habit_tile.dart';
import 'package:second_brain/features/habit/screens/widgets/month_summary.dart';
import 'package:second_brain/features/habit/screens/widgets/my_alert_box.dart';
import 'package:second_brain/features/habit/screens/widgets/my_fab.dart';
import 'package:get_storage/get_storage.dart';
import '../data/habit_database.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  HabitDatabase db = HabitDatabase();
  final _myBox = GetStorage();

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

      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          // monthly summary heat map
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.read("START_DATE"),
          ),

          // list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
          )
        ],
      ),
    );
  }
}
