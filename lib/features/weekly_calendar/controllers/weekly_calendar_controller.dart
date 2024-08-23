import 'dart:math';
import 'package:al_maafer/common/widgets/loaders/loaders.dart';
import 'package:al_maafer/features/weekly_calendar/controllers/Icon_selector.dart';
import 'package:al_maafer/features/weekly_calendar/models/task_model.dart';
import 'package:al_maafer/features/weekly_calendar/screens/weekly_calendar/widgets/weekly_calendar_add_update.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:al_maafer/time_planer/time_planner.dart';

//--------------------------------

class WeeklyCalendarController extends GetxController {
  final IconController colorController = Get.put(IconController());
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();

  var selectedStartTime = TimeOfDay.now().obs;
  var selectedEndTime = TimeOfDay(
    hour: (TimeOfDay.now().hour + 1) % 24,
    minute: TimeOfDay.now().minute,
  ).obs;
  Future<void> selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isStartTime ? selectedStartTime.value : selectedEndTime.value,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isStartTime) {
        selectedStartTime.value = picked;
      } else {
        selectedEndTime.value = picked;
        // Calculate duration in minutes
        final startMinutes =
            selectedStartTime.value.hour * 60 + selectedStartTime.value.minute;
        final endMinutes =
            selectedEndTime.value.hour * 60 + selectedEndTime.value.minute;
        duration.value = endMinutes - startMinutes;
      }
    }
  }

  RxBool showAddTask = false.obs;
  RxBool showUpdateTask = false.obs;
  //-----------------------------
  var selectedDays = List<bool>.filled(7, false).obs;
  List<Map<String, dynamic>> monthlySessions = [];
  void toggleDay(int index) {
    for (int i = 0; i < selectedDays.length; i++) {
      selectedDays[i] = i == index;
    }
    dayIndex.value = (6 - index);
    daysDuration.value = 1;
  }
  //-----------------------------

  final TaskNameController = TextEditingController().obs;
  final TaskDescriptionController = TextEditingController().obs;
  final isLoading = false.obs;

  RxInt dayIndex = 0.obs;
  RxInt duration = 60.obs;
  RxInt daysDuration = 0.obs;
  var tasks = <TimePlannerTask>[].obs;
  var cellWidth = 0.obs;

  final daysOfWeek = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];

  RxInt currentDay = 0.obs;

  void getCurrentDay() {
    final now = DateTime.now();
    currentDay.value = (now.weekday + 1) % 7;
  }

  void loadTasksFromStorage() {
    final storedTasks = box.read<List>('tasks') ?? [];
    tasks.value = storedTasks.map((task) {
      return TimePlannerTask(
        color: Color(task['color']),
        icon: colorController.iconChoices[task['iconIndex'] ?? 0].icon,
        title: task['title'],
        dateTime: TimePlannerDateTime(
          day: task['dateTime']['day'],
          hour: task['dateTime']['hour'],
          minutes: task['dateTime']['minutes'],
        ),
        minutesDuration: task['minutesDuration'],
        daysDuration: task['daysDuration'],
        onTap: () {
          Get.defaultDialog(
            title: 'تفاصيل المهمة',
            content: Text(
              '${task['title']} في sessionTime لمدة ${task['minutesDuration']} دقيقة',
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
                  title: task['title'],
                  dayIndex: task['dateTime']['day'],
                  hour: task['dateTime']['hour'],
                  minutes: task['dateTime']['minutes'],
                  duration: task['minutesDuration'],
                  daysDuration: task['daysDuration'],
                  icon:
                      colorController.iconChoices[task['iconIndex'] ?? 0].icon,
                  color: task['color'],
                );
              },
              child: Text('حذف'),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  final index = findTaskIndex(
                    title: task['title'],
                    dayIndex: task['dateTime']['day'],
                    hour: task['dateTime']['hour'],
                    minutes: task['dateTime']['minutes'],
                    duration: task['minutesDuration'],
                    daysDuration: task['daysDuration'],
                    icon: colorController
                        .iconChoices[task['iconIndex'] ?? 0].icon,
                    color: task['color'],
                  );
                  //-----------------

                  taskUpdateIndex.value = index!;
                  showUpdateTask.value = true;
                  showAddTask.value = true;
                  TaskNameController.value.text = task['title'];
                  selectedStartTime.value = TimeOfDay(
                      hour: task['dateTime']['hour'],
                      minute: task['dateTime']['minutes']);
                  // Calculate end time based on start time and duration
                  final startMinutes = task['dateTime']['hour'] * 60 +
                      task['dateTime']['minutes'];
                  final endMinutes = startMinutes + duration;
                  selectedEndTime.value = TimeOfDay(
                      hour: endMinutes ~/ 60, minute: endMinutes % 60);

                  this.dayIndex.value = task['dateTime']['day'];
                  this.duration.value = task['minutesDuration'];
                  colorController.selectedColor.value = task['color'];
                  colorController.selectedIcon.value =
                      colorController.iconChoices[task['iconIndex'] ?? 0].icon;
                  print(task['dateTime']['day']);
                  for (int i = 0; i < daysOfWeek.length; i++) {
                    if ((6 - i) == task['dateTime']['day'])
                      selectedDays[i] = true;
                    else
                      selectedDays[i] = false;
                  }
                  //-----------------
                  Get.back();
                },
                child: Text('تحديث'),
              ),
            ],
          );
        },
      );
    }).toList();
  }

  void saveTasksToStorage() {
    final taskList = tasks.map((task) => task.toJson()).toList();
    box.write('tasks', taskList);
  }

  @override
  void onInit() {
    getCurrentDay();
    loadTasksFromStorage();
    // generateRandomTasks();
    // generateDayRoutineTasks(1);
    // generateDayRoutineTasks(2);
    // generateDayRoutineTasks(3);
    // generateDayRoutineTasks(4);
    // generateDayRoutineTasks(5);
    super.onInit();
  }

  // void generateDayRoutineTasks(int specificDayIndex) {
  //   final dateFormat = DateFormat('hh:mm a');
  //
  //   final dailyRoutine = [
  //     {
  //       'hour': 6,
  //       'minute': 0,
  //       'period': 'AM',
  //       'description': 'الاستيقاظ والروتين الصباحي',
  //       'duration': 60,
  //       'daysDuration': 7,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 7,
  //       'minute': 0,
  //       'period': 'AM',
  //       'description': 'وقت المذاكرة المركزة',
  //       'duration': 120,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 9,
  //       'minute': 0,
  //       'period': 'AM',
  //       'description': 'العمل البرمجي المنتج',
  //       'duration': 180,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 12,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'استراحة الغداء والاسترخاء',
  //       'duration': 60,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 1,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'متابعة العمل البرمجي',
  //       'duration': 120,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 3,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'استراحة قصيرة ومذاكرة خفيفة',
  //       'duration': 60,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 4,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'البرمجة وحل المشكلات',
  //       'duration': 120,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 6,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'ممارسة الرياضة أو النشاط البدني',
  //       'duration': 60,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 7,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'العشاء والاسترخاء',
  //       'duration': 60,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 8,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'البرمجة الخفيفة أو المذاكرة',
  //       'duration': 120,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 10,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'الترفيه والاسترخاء',
  //       'duration': 60,
  //       'daysDuration': 1,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //     {
  //       'hour': 11,
  //       'minute': 0,
  //       'period': 'PM',
  //       'description': 'النوم',
  //       'duration': 30,
  //       'daysDuration': 2,
  //       'icon': FontAwesomeIcons.briefcase
  //     },
  //   ];
  //
  //   for (var routine in dailyRoutine) {
  //     final sessionTime =
  //         '${routine['hour']}:${routine['minute'].toString().padLeft(2, '0')} ${routine['period']}';
  //
  //     final time = dateFormat.parse(sessionTime);
  //     final parsedHour = time.hour;
  //     final parsedMinutes = time.minute;
  //     // Add task for the specific day only
  //     addTask(
  //         title: routine['description'] as String,
  //         dayIndex: specificDayIndex,
  //         hour: parsedHour,
  //         minutes: parsedMinutes,
  //         duration: (routine['duration'] as int) - 2,
  //         daysDuration: routine['daysDuration'] as int,
  //         icon: routine['icon'] as IconData,
  //         color: Colors.blue.value);
  //   }
  // }

  int? findTaskIndex({
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
        return i;
      }
    }
    return null;
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
    final index = findTaskIndex(
      title: title,
      dayIndex: dayIndex,
      hour: hour,
      minutes: minutes,
      duration: duration,
      daysDuration: daysDuration,
      icon: icon,
      color: color,
    );
    if (index != null) {
      final task = tasks[index];
      print(
          'Removing task: ${task.color!.value} Title=${task.title}, Duration=${task.minutesDuration}, DateTime=${task.dateTime.day}-${task.dateTime.hour}:${task.dateTime.minutes}');
      print(
          'Removing task=> ${color}  Title=${title}, Duration=${duration}, DateTime=${dayIndex}-${hour}:${minutes}');
      tasks.removeAt(index);
      Get.back();
      saveTasksToStorage();

      TLoaders.successSnackBar(
          message: 'تمت إزالة المهمة بنجاح', title: 'تمت العملية');
    }
  }

  RxInt taskUpdateIndex = 0.obs;
  void UpdateTask({
    required int? index,
    required String title,
    required int dayIndex,
    required int hour,
    required int minutes,
    required int duration,
    required int daysDuration,
    required IconData icon,
    required int color,
  }) {
    if (index != null) {
      tasks[index] = TimePlannerTask(
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
              '${title} في sessionTime لمدة ${duration} دقيقة',
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
            actions: [
              ElevatedButton(
                onPressed: () {
                  final index = findTaskIndex(
                    title: title,
                    dayIndex: dayIndex,
                    hour: hour,
                    minutes: minutes,
                    duration: duration,
                    daysDuration: daysDuration,
                    icon: icon,
                    color: color,
                  );
                  //-----------------

                  taskUpdateIndex.value = index!;
                  showUpdateTask.value = true;
                  showAddTask.value = true;
                  TaskNameController.value.text = title;
                  selectedStartTime.value =
                      TimeOfDay(hour: hour, minute: minutes);
                  // Calculate end time based on start time and duration
                  final startMinutes = hour * 60 + minutes;
                  final endMinutes = startMinutes + duration;
                  selectedEndTime.value = TimeOfDay(
                      hour: endMinutes ~/ 60, minute: endMinutes % 60);

                  this.dayIndex.value = dayIndex;
                  this.duration.value = duration;
                  colorController.selectedColor.value = color;
                  colorController.selectedIcon.value = icon;

                  for (int i = 0; i < daysOfWeek.length; i++) {
                    if ((6 - i) == dayIndex)
                      selectedDays[i] = true;
                    else
                      selectedDays[i] = false;
                  }
                  //-----------------
                  Get.back();
                },
                child: Text('تحديث'),
              ),
            ],
          );
        },
      );
      saveTasksToStorage();

      TaskNameController.value.clear();
      showUpdateTask.value = false;
      colorController.selectedIcon.value = Icons.work;
      colorController.selectedName.value = "عمل";
      colorController.selectedColor.value = 0xFF2196F3;

      TLoaders.successSnackBar(
          message: 'تم تحديث المهمة بنجاح', title: 'تمت العملية');

      return;
    }
  }

  void addTask({
    required String title,
    required int dayIndex,
    required int hour,
    required int minutes,
    required int duration,
    required int daysDuration,
    required IconData icon,
    required int color,
  }) {
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
            '${title} في sessionTime لمدة ${duration} دقيقة',
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
          actions: [
            ElevatedButton(
              onPressed: () {
                final index = findTaskIndex(
                  title: title,
                  dayIndex: dayIndex,
                  hour: hour,
                  minutes: minutes,
                  duration: duration,
                  daysDuration: daysDuration,
                  icon: icon,
                  color: color,
                );
                //-----------------

                taskUpdateIndex.value = index!;
                showUpdateTask.value = true;
                showAddTask.value = true;
                TaskNameController.value.text = title;
                selectedStartTime.value =
                    TimeOfDay(hour: hour, minute: minutes);
                // Calculate end time based on start time and duration
                final startMinutes = hour * 60 + minutes;
                final endMinutes = startMinutes + duration;
                selectedEndTime.value =
                    TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60);

                this.dayIndex.value = dayIndex;
                this.duration.value = duration;
                this.daysDuration.value = daysDuration;

                colorController.selectedColor.value = color;
                colorController.selectedIcon.value = icon;

                for (int i = 0; i < daysOfWeek.length; i++) {
                  if ((6 - i) == dayIndex)
                    selectedDays[i] = true;
                  else
                    selectedDays[i] = false;
                }
                //-----------------
                Get.back();
              },
              child: Text('تحديث'),
            ),
          ],
        );
      },
    );
    tasks.add(task);
    TaskNameController.value.clear();
    saveTasksToStorage();

    TLoaders.successSnackBar(
        message: 'تمت إضافة المهمة بنجاح', title: 'تمت العملية');
  }

  void updateCellWidth(double newWidth) {
    cellWidth.value = newWidth.toInt();
  }
}
