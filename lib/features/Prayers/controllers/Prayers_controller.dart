import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:second_brain/features/habit/controllers/date_time.dart';

class PrayersController extends GetxController {
  final myBox = GetStorage();
  var toDaysHabitList = <List<dynamic>>[].obs;
  var heatMapDataSet = <DateTime, int>{}.obs;
  var now = DateTime.now().add(const Duration(days: 0));
  String startDate = '';

  @override
  void onInit() {
    super.onInit();
    myBox.remove("Prayers_START_DATE");
    myBox.remove("Prayers_HABIT_LIST");
    myBox.write("Prayers_START_DATE", todaysDateFormatted());
    if (myBox.read("Prayers_HABIT_LIST") == null) {
      createDefaultData();
    } else {
      loadData();
    }
    updateDatabase();
    startDate = myBox.read("Prayers_START_DATE") ?? '';
  }

  void createDefaultData() {
    toDaysHabitList.value = [
      ["الفجر", false],
      ["أذكار الصباح", false],
      ["الظهر", false],
      ["العصر", false],
      ["أذكار المساء", false],
      ["المغرب", false],
      ["العشاء", false],
    ];

    myBox.write("Prayers_START_DATE", todaysDateFormatted());
  }

  void loadData() {
    if (myBox.read(todaysDateFormatted()) == null) {
      var currentHabitList = myBox.read("Prayers_HABIT_LIST");
      if (currentHabitList != null && currentHabitList is List) {
        toDaysHabitList.value = List<List<dynamic>>.from(currentHabitList);
        for (int i = 0; i < toDaysHabitList.length; i++) {
          toDaysHabitList[i][1] = false;
        }
      }
    } else {
      var todaysList = myBox.read(todaysDateFormatted());
      if (todaysList != null && todaysList is List) {
        toDaysHabitList.value = List<List<dynamic>>.from(todaysList);
      }
    }
  }

  void updateDatabase() {
    myBox.write(todaysDateFormatted(), toDaysHabitList);
    myBox.write("Prayers_HABIT_LIST", toDaysHabitList);
    calculateHabitPercentages();
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < toDaysHabitList.length; i++) {
      if (toDaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = toDaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / toDaysHabitList.length).toStringAsFixed(1);

    myBox.write("prayerPERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(myBox.read("Prayers_START_DATE"));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        myBox.read("prayerPERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
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
    toDaysHabitList[index][1] = value;
    toDaysHabitList.refresh(); // Ensure the list is updated
    updateDatabase();
  }

  void createNewHabit(String habitName) {
    toDaysHabitList.add([habitName, false]);
    updateDatabase();
  }

  void saveExistingHabit(int index, String newName) {
    toDaysHabitList[index][0] = newName;
    updateDatabase();
  }

  void deleteHabit(int index) {
    toDaysHabitList.removeAt(index);
    updateDatabase();
  }
}
