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

  final TaskNameController = TextEditingController().obs;
  final TaskDescriptionController = TextEditingController().obs;
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
  // RxString selectedDay = 'السبت'.obs;
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
        'duration': 30,
        'daysDuration': 2,
        'icon': taskIcons[0]
      },
    ];

    for (var routine in dailyRoutine) {
      final sessionTime =
          '${routine['hour']}:${routine['minute'].toString().padLeft(2, '0')} ${routine['period']}';

      final time = dateFormat.parse(sessionTime);
      final parsedHour = time.hour;
      final parsedMinutes = time.minute;
      // Add task for the specific day only
      tasks.add(
        TimePlannerTask(
          color: colors[specificDayIndex % colors.length],
          icon: routine['icon'] as IconData,
          title: routine['description'] as String,
          dateTime: TimePlannerDateTime(
              day: specificDayIndex, hour: parsedHour, minutes: parsedMinutes),
          minutesDuration: (routine['duration'] as int) - 2,
          daysDuration: routine['daysDuration'] as int,
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
              cancel: ElevatedButton(
                onPressed: () {
                  removeTaskByTitleAndDuration(
                    title: routine['description'] as String,
                    dayIndex: specificDayIndex,
                    hour: parsedHour,
                    minutes: parsedMinutes,
                    duration: (routine['duration'] as int) - 2,
                    daysDuration: routine['daysDuration'] as int,
                    icon: routine['icon'] as IconData,
                    color: colors[specificDayIndex % colors.length]!.value,
                  );
                  // Get.back();
                },
                child: Text('حذف'),
              ),
            );
          },
        ),
      );
    }
  }

  void removeTaskByTitleAndDuration({
    required String title,
    required int dayIndex,
    required int hour,
    required int minutes,
    required int duration,
    required int daysDuration,
    required IconData icon,
    required int color,
  }) {
    for (int i = tasks.length - 1; i >= 0; i--) {
      final task = tasks[i];

      final matches = task.title == title &&
          task.dateTime.day == dayIndex &&
          task.dateTime.hour == hour &&
          task.dateTime.minutes == minutes &&
          task.minutesDuration == duration &&
          task.daysDuration == daysDuration &&
          task.icon == icon &&
          task.color!.value == color;

      if (matches) {
        print(
            'Removing task: ${task.color!.value} Title=${task.title}, Duration=${task.minutesDuration}, DateTime=${task.dateTime.day}-${task.dateTime.hour}:${task.dateTime.minutes}');
        print(
            'Removing task=> ${color}  Title=${title}, Duration=${duration}, DateTime=${dayIndex}-${hour}:${minutes}');
        tasks.removeAt(i);
        Get.back();
        // Show GetX bottom loader
        Get.snackbar(
          "تمت إزالة المهمة",
          "تمت إزالة المهمة $title بنجاح.",
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
        break;
      }
    }
  }

  void updateCellWidth(double newWidth) {
    cellWidth.value = newWidth.toInt();
  }

  void addTask(
      {required String title,
      required int dayIndex,
      required int hour,
      required int minutes,
      required int duration,
      required int daysDuration,
      required IconData icon,
      required int color}) {
    final task = TimePlannerTask(
      color: Color(color),
      icon: icon,
      title: title,
      dateTime: TimePlannerDateTime(
        day: dayIndex,
        hour: hour,
        minutes: minutes,
      ),
      minutesDuration: duration,
      daysDuration: daysDuration,
      onTap: () {
        Get.defaultDialog(
          title: 'تفاصيل المهمة',
          content: Text(
            '${title} في sessionTime لمدة ${60} دقيقة',
            style: Theme.of(Get.context!).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          confirm: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text('إغلاق'),
          ),
          cancel: ElevatedButton(
            onPressed: () {
              removeTaskByTitleAndDuration(
                title: title,
                dayIndex: dayIndex,
                hour: hour,
                minutes: minutes,
                duration: duration,
                daysDuration: daysDuration,
                icon: icon,
                color: color,
              );
            },
            child: Text('حذف'),
          ),
        );
      },
    );
    tasks.add(task);
  }

  void showAddAndRemoveBottomSheet(
      {required TimePlannerTaskModel? group, required bool isEdit}) {
    if (false) {
      // groupNameController.value.text = group!.name;
      // groupMonthlyPriceController.value.text = group.monthlyFee;
      // colorController.selectedColor.value = group.color;
      // selectedTime.value = TimeOfDay.fromDateTime(
      //     DateFormat('hh:mm a').parse(group.sessionTime));

      // selectedYear.value = int.parse(group.year);
      // refreshMonthsSessions();
    } else {
      TaskNameController.value.text = '';
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
