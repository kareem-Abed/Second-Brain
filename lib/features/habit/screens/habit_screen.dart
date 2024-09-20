import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';


import 'package:second_brain/features/habit/screens/widgets/habit_tile.dart';
import 'package:second_brain/features/habit/screens/widgets/month_summary.dart';
import 'package:second_brain/features/habit/screens/widgets/my_alert_box.dart';
import 'package:second_brain/features/habit/screens/widgets/my_fab.dart';
import 'package:flutter/material.dart';


// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   HabitDatabase db = HabitDatabase();
//   final _myBox = Hive.box("Habit_Database");
//
//   @override
//   void initState() {
//     // if there is no current habit list, then it is the 1st time ever opening the app
//     // then create default data
//     if (_myBox.get("CURRENT_HABIT_LIST") == null) {
//       db.createDefaultData();
//     }
//
//     // there already exists data, this is not the first time
//     else {
//       db.loadData();
//     }
//
//     // update the database
//     db.updateDatabase();
//
//     super.initState();
//   }
//
//   // checkbox was tapped
//   void checkBoxTapped(bool? value, int index) {
//     setState(() {
//       db.todaysHabitList[index][1] = value;
//     });
//     db.updateDatabase();
//   }
//
//   // create a new habit
//   final _newHabitNameController = TextEditingController();
//   void createNewHabit() {
//     // show alert dialog for user to enter the new habit details
//     showDialog(
//       context: context,
//       builder: (context) {
//         return MyAlertBox(
//           controller: _newHabitNameController,
//           hintText: 'Enter habit name..',
//           onSave: saveNewHabit,
//           onCancel: cancelDialogBox,
//         );
//       },
//     );
//   }
//
//   // save new habit
//   void saveNewHabit() {
//     // add new habit to todays habit list
//     setState(() {
//       db.todaysHabitList.add([_newHabitNameController.text, false]);
//     });
//
//     // clear textfield
//     _newHabitNameController.clear();
//     // pop dialog box
//     Navigator.of(context).pop();
//     db.updateDatabase();
//   }
//
//   // cancel new habit
//   void cancelDialogBox() {
//     // clear textfield
//     _newHabitNameController.clear();
//
//     // pop dialog box
//     Navigator.of(context).pop();
//   }
//
//   // open habit settings to edit
//   void openHabitSettings(int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return MyAlertBox(
//           controller: _newHabitNameController,
//           hintText: db.todaysHabitList[index][0],
//           onSave: () => saveExistingHabit(index),
//           onCancel: cancelDialogBox,
//         );
//       },
//     );
//   }
//
//   // save existing habit with a new name
//   void saveExistingHabit(int index) {
//     setState(() {
//       db.todaysHabitList[index][0] = _newHabitNameController.text;
//     });
//     _newHabitNameController.clear();
//     Navigator.pop(context);
//     db.updateDatabase();
//   }
//
//   // delete habit
//   void deleteHabit(int index) {
//     setState(() {
//       db.todaysHabitList.removeAt(index);
//     });
//     db.updateDatabase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
//       body: ListView(
//         children: [
//           // monthly summary heat map
//           MonthlySummary(
//             datasets: db.heatMapDataSet,
//             startDate: _myBox.get("START_DATE"),
//           ),
//
//           // list of habits
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: db.todaysHabitList.length,
//             itemBuilder: (context, index) {
//               return HabitTile(
//                 habitName: db.todaysHabitList[index][0],
//                 habitCompleted: db.todaysHabitList[index][1],
//                 onChanged: (value) => checkBoxTapped(value, index),
//                 settingsTapped: (context) => openHabitSettings(index),
//                 deleteTapped: (context) => deleteHabit(index),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:second_brain/features/habit/screens/widgets/habit_tile.dart';
// import 'package:second_brain/features/habit/screens/widgets/month_summary.dart';
// import 'package:second_brain/features/habit/screens/widgets/my_alert_box.dart';
// import 'package:second_brain/features/habit/screens/widgets/my_fab.dart';
// import '../controllers/habit_controller.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:second_brain/features/habit/screens/widgets/habit_tile.dart';
// import 'package:second_brain/features/habit/screens/widgets/month_summary.dart';
// import 'package:second_brain/features/habit/screens/widgets/my_alert_box.dart';
// import 'package:second_brain/features/habit/screens/widgets/my_fab.dart';
// import '../controllers/habit_controller.dart';
// import '../datetime/date_time.dart';
//
// class HabitScreen extends StatelessWidget {
//   HabitScreen({super.key});
//
//   final HabitController controller = Get.put(HabitController());
//   final TextEditingController _newHabitNameController = TextEditingController();
//
//   void createNewHabit() {
//     showDialog(
//       context: Get.context!,
//       builder: (context) {
//         return MyAlertBox(
//           controller: _newHabitNameController,
//           hintText: 'Enter habit name..',
//           onSave: () {
//             controller.createNewHabit(_newHabitNameController.text);
//             _newHabitNameController.clear();
//             Navigator.of(context).pop();
//           },
//           onCancel: () {
//             _newHabitNameController.clear();
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }
//
//   void openHabitSettings(int index) {
//     showDialog(
//       context: Get.context!,
//       builder: (context) {
//         return MyAlertBox(
//           controller: _newHabitNameController,
//           hintText: controller.todaysHabitList[index][0],
//           onSave: () {
//             controller.saveExistingHabit(index, _newHabitNameController.text);
//             _newHabitNameController.clear();
//             Navigator.of(context).pop();
//           },
//           onCancel: () {
//             _newHabitNameController.clear();
//             Navigator.of(context).pop();
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
//       body: ListView(
//         children: [
//            // MonthlySummary(),
//           Container(
//             padding: const EdgeInsets.only(top: 25, bottom: 25),
//             child: Obx(() {
//               final startDate =
//               createDateTimeObject(controller.myBox.read("START_DATE"));
//               final heatMapDataSet = controller.heatMapDataSet;
//
//               return HeatMap(
//                 startDate: startDate,
//                 endDate: controller.now,
//                 datasets: heatMapDataSet,
//                 colorMode: ColorMode.color,
//                 defaultColor: Colors.grey[200],
//                 textColor: Colors.white,
//                 showColorTip: false,
//                 showText: true,
//                 scrollable: true,
//                 size: 30,
//                 colorsets: const {
//                   1: Color.fromARGB(20, 2, 179, 8),
//                   2: Color.fromARGB(40, 2, 179, 8),
//                   3: Color.fromARGB(60, 2, 179, 8),
//                   4: Color.fromARGB(80, 2, 179, 8),
//                   5: Color.fromARGB(100, 2, 179, 8),
//                   6: Color.fromARGB(120, 2, 179, 8),
//                   7: Color.fromARGB(150, 2, 179, 8),
//                   8: Color.fromARGB(180, 2, 179, 8),
//                   9: Color.fromARGB(220, 2, 179, 8),
//                   10: Color.fromARGB(255, 2, 179, 8),
//                 },
//                 onClick: (value) {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text(value.toString())));
//                 },
//               );
//             }),
//           ),
//           Obx(
//             () => ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: controller.todaysHabitList.length,
//               itemBuilder: (context, index) {
//                 return HabitTile(
//                   habitName: controller.todaysHabitList[index][0],
//                   habitCompleted: controller.todaysHabitList[index][1],
//                   onChanged: (value) => controller.checkBoxTapped(value, index),
//                   settingsTapped: (context) => openHabitSettings(index),
//                   deleteTapped: (context) => controller.deleteHabit(index),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }