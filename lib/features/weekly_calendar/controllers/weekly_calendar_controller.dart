import 'dart:math';
import 'package:al_maafer/features/weekly_calendar/controllers/Icon_selector.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_add_update.dart';
import 'package:al_maafer/time_planer/src/time_planner_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:al_maafer/time_planer/time_planner.dart';

class TimePlannerTaskModel {
  final Color color;
  final TimePlannerDateTime dateTime;
  final int minutesDuration;
  final int daysDuration;
  final double widthTask;
  final Widget child;

  TimePlannerTaskModel({
    required this.color,
    required this.dateTime,
    required this.minutesDuration,
    required this.daysDuration,
    required this.widthTask,
    required this.child,
  });
}
//--------------------------------

class WeeklyCalendarController extends GetxController {
  final IconController colorController = Get.put(IconController());
  final formKey = GlobalKey<FormState>();
  var selectedTime = TimeOfDay.now().obs;
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
    }
  }
RxBool showAddTask = false.obs;
  //-----------------------------

  var selectedDays = List<bool>.filled(7, false).obs;

  List<Map<String, dynamic>> monthlySessions = [];
  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
    update();
  }

  //-----------------------------

  final isLoading = false.obs;
  List<Color?> colors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.lime[600]
  ];

  var tasks = <TimePlannerTask>[].obs;
  var cellWidth = 0.obs;

  final List<IconData> taskIcons = [
    Icons.alarm,
    Icons.book,
    Icons.code,
    Icons.lunch_dining,
    Icons.computer,
    Icons.star,
    Icons.sports_gymnastics,
    Icons.dinner_dining,
    Icons.lightbulb,
    Icons.movie,
    Icons.nightlife,
  ];
  final daysOfWeek = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];
  RxString selectedDay = 'السبت'.obs;
  final daysOfWeekStare = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  RxString currentDay = ''.obs;

  void getCurrentDay() {
    final now = DateTime.now();
    final currentDayIndex = (now.weekday + 1) % 7;
    currentDay.value = daysOfWeek[currentDayIndex];
    daysOfWeekStare[currentDayIndex] = '*';
  }

  @override
  void onInit() {
    getCurrentDay();
    // generateRandomTasks();

    // generateDayRoutineTasks(1);
    // generateDayRoutineTasks(2);
    generateDayRoutineTasks(3);
    // generateDayRoutineTasks(4);
    // generateDayRoutineTasks(5);
    super.onInit();
  }

  void generateDayRoutineTasks(int specificDayIndex) {
    final dateFormat = DateFormat('hh:mm a');

    // Define your daily routine with hour, minute, task description, and day duration in Arabic
    final dailyRoutine = [
      {
        'hour': 6,
        'minute': 0,
        'period': 'AM',
        'description': 'الاستيقاظ والروتين الصباحي',
        'duration': 60,
        'daysDuration': 7,
        'icon': taskIcons[0]
      },
      {
        'hour': 7,
        'minute': 0,
        'period': 'AM',
        'description': 'وقت المذاكرة المركزة',
        'duration': 120,
        'daysDuration': 1,
        'icon': taskIcons[1]
      },
      {
        'hour': 9,
        'minute': 0,
        'period': 'AM',
        'description': 'العمل البرمجي المنتج',
        'duration': 180,
        'daysDuration': 1,
        'icon': taskIcons[2]
      },
      {
        'hour': 12,
        'minute': 0,
        'period': 'PM',
        'description': 'استراحة الغداء والاسترخاء',
        'duration': 60,
        'daysDuration': 1,
        'icon': taskIcons[3]
      },
      {
        'hour': 1,
        'minute': 0,
        'period': 'PM',
        'description': 'متابعة العمل البرمجي',
        'duration': 120,
        'daysDuration': 1,
        'icon': taskIcons[4]
      },
      {
        'hour': 3,
        'minute': 0,
        'period': 'PM',
        'description': 'استراحة قصيرة ومذاكرة خفيفة',
        'duration': 60,
        'daysDuration': 1,
        'icon': taskIcons[5]
      },
      {
        'hour': 4,
        'minute': 0,
        'period': 'PM',
        'description': 'البرمجة وحل المشكلات',
        'duration': 120,
        'daysDuration': 1,
        'icon': taskIcons[6]
      },
      {
        'hour': 6,
        'minute': 0,
        'period': 'PM',
        'description': 'ممارسة الرياضة أو النشاط البدني',
        'duration': 60,
        'daysDuration': 1,
        'icon': taskIcons[7]
      },
      {
        'hour': 7,
        'minute': 0,
        'period': 'PM',
        'description': 'العشاء والاسترخاء',
        'duration': 60,
        'daysDuration': 1,
        'icon': taskIcons[8]
      },
      {
        'hour': 8,
        'minute': 0,
        'period': 'PM',
        'description': 'البرمجة الخفيفة أو المذاكرة',
        'duration': 120,
        'daysDuration': 1,
        'icon': taskIcons[9]
      },
      {
        'hour': 10,
        'minute': 0,
        'period': 'PM',
        'description': 'الترفيه والاسترخاء',
        'duration': 60,
        'daysDuration': 1,
        'icon': taskIcons[10]
      },
      {
        'hour': 11,
        'minute': 0,
        'period': 'PM',
        'description': 'النوم',
        'duration': 420,
        'daysDuration': 7, // 7 hours sleep lasting the entire night
        'icon': taskIcons[0]
      },
    ];

    // final widthTask = ((KHelperFunctions.screenWidth() / 7).toInt()) - 1.0; // Calculate width of task

    for (var routine in dailyRoutine) {
      // Format the session time
      final sessionTime =
          '${routine['hour']}:${routine['minute'].toString().padLeft(2, '0')} ${routine['period']}';

      // Parse session time
      final time = dateFormat.parse(sessionTime);
      final parsedHour = time.hour;
      final parsedMinutes = time.minute;

      // Add task for the specific day only
      tasks.add(
        TimePlannerTask(
          color: colors[specificDayIndex %
              colors.length], // Assign a color based on day index
          dateTime: TimePlannerDateTime(
              day: specificDayIndex, hour: parsedHour, minutes: 2),
          minutesDuration: (routine['duration'] as int) - 2,
          daysDuration: routine['daysDuration'] as int,

          // widthTask: widthTask,
          child: InkWell(
            onTap: () {
              Get.defaultDialog(
                title: 'تفاصيل المهمة',
                content: Text(
                  '${routine['description']} في $sessionTime لمدة ${routine['duration']} دقيقة',
                  style: Theme.of(Get.context!).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                confirm: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('إغلاق'),
                ),
              );
            },
            child: Container(
              // color: Colors.red,
              height: double.infinity,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        routine['icon'] as IconData,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        routine['description'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleSmall!
                            .copyWith(),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // FittedBox(
                    //   fit: BoxFit.scaleDown,
                    //   child: Text(
                    //     routine['description'] as String,
                    //     maxLines: 3,
                    //     style: Theme.of(Get.context!)
                    //         .textTheme
                    //         .titleSmall!
                    //         .copyWith(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void generateRandomTasks() {
    final random = Random();
    final dateFormat = DateFormat('hh:mm a');

    for (int i = 0; i < 5; i++) {
      // Generate random session time
      final hour = random.nextInt(12) + 1; // 1 to 12
      final minute = random.nextInt(60); // 0 to 59
      final period = random.nextBool() ? 'AM' : 'PM';
      final sessionTime = '$hour:${minute.toString().padLeft(2, '0')} $period';

      // Parse session time
      final time = dateFormat.parse(sessionTime);
      final parsedHour = time.hour;
      final parsedMinutes = time.minute;

      // Generate random day of the week
      final dayIndex = random.nextInt(7); // 0 to 6

      // Create and add task
      tasks.add(
        TimePlannerTask(
          color: colors[random.nextInt(colors.length)],
          dateTime:
              TimePlannerDateTime(day: dayIndex, hour: parsedHour, minutes: 0),
          minutesDuration: 60,
          daysDuration: 1,
          // widthTask: cellWidth.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Task ${i + 1}',
                maxLines: 3,
                style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(),
              ),
            ),
          ),
        ),
      );
    }
  }

  void updateCellWidth(double newWidth) {
    cellWidth.value = newWidth.toInt();
  }

  final TaskNameController = TextEditingController().obs;
  void showAddAndRemoveBottomSheet(
      {required TimePlannerTaskModel? group, required bool isEdit}) {
    if (false) {
      // groupNameController.value.text = group!.name;
      // groupMonthlyPriceController.value.text = group.monthlyFee;
      // colorController.selectedColor.value = group.color;
      // selectedTime.value = TimeOfDay.fromDateTime(
      //     DateFormat('hh:mm a').parse(group.sessionTime));
      // for (int i = 0; i < daysOfWeek.length; i++) {
      //   selectedDays[i] = group.sessionDays.contains(daysOfWeek[i]);
      // }
      // selectedYear.value = int.parse(group.year);
      // refreshMonthsSessions();
    } else {
      TaskNameController .value.text = '';
      // groupMonthlyPriceController.value.text = '';
      selectedTime.value = TimeOfDay.now();
      for (int i = 0; i < daysOfWeek.length; i++) {
        selectedDays[i] = false;
      }

    }
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return AddGroupForm(
          isEdit: isEdit,
          groupId: isEdit == true ? 'asd' : null,
        );
      },
    );
  }
}
