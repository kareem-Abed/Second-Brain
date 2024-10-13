import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../datetime/date_time.dart';

class HabitController extends GetxController {
  final myBox = GetStorage();
  var todaysHabitList = <List<dynamic>>[].obs;
  var heatMapDataSet = <DateTime, int>{}.obs;
var now = DateTime.now().add(const Duration(days: 0));
String startDate ='';
  @override
  void onInit() {
    super.onInit();
    GetStorage.init();

    if (myBox.read("CURRENT_HABIT_LIST") == null) {
      createDefaultData();
    } else {
      loadData();
    }

    updateDatabase();
    startDate=myBox.read("START_DATE");
  }

  void createDefaultData() {
    todaysHabitList.value = [
      ["Run", false],
      ["Read", false],
    ];

    myBox.write("START_DATE", todaysDateFormatted());
  }

  void loadData() {
    if (myBox.read(todaysDateFormatted()) == null) {
      var currentHabitList = myBox.read("CURRENT_HABIT_LIST");
      if (currentHabitList != null && currentHabitList is List) {
        todaysHabitList.value = List<List<dynamic>>.from(currentHabitList);
        for (int i = 0; i < todaysHabitList.length; i++) {
          todaysHabitList[i][1] = false;
        }
      }
    } else {
      var todaysList = myBox.read(todaysDateFormatted());
      if (todaysList != null && todaysList is List) {
        todaysHabitList.value = List<List<dynamic>>.from(todaysList);
      }
    }
  }



  void updateDatabase() {
    myBox.write(todaysDateFormatted(), todaysHabitList);
    myBox.write("CURRENT_HABIT_LIST", todaysHabitList);
    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    myBox.write("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(myBox.read("START_DATE"));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        myBox.read("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }

  void checkBoxTapped(bool? value, int index) {
    todaysHabitList[index][1] = value;
    todaysHabitList.refresh(); // Ensure the list is updated
    updateDatabase();
  }

  void createNewHabit(String habitName) {
    todaysHabitList.add([habitName, false]);
    updateDatabase();
  }

  void saveExistingHabit(int index, String newName) {
    todaysHabitList[index][0] = newName;
    updateDatabase();
  }

  void deleteHabit(int index) {
    todaysHabitList.removeAt(index);
    updateDatabase();
  }
}