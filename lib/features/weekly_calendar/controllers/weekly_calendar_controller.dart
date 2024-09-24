import 'dart:async';
import 'dart:io';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:second_brain/common/widgets/loaders/loaders.dart';
import 'package:second_brain/features/weekly_calendar/controllers/Icon_selector.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:second_brain/time_planer/time_planner.dart';
import 'package:path_provider/path_provider.dart';

import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

class WeeklyCalendarController extends GetxController {
  //--------> Timer Variables <--------\\

  /// Timer to update the time every minute
  Timer? timer;
  var currentHour = DateTime.now().hour.obs;
  var currentMinute = DateTime.now().minute.obs;

  //--------> Controller Variables <--------\\
  final IconController colorController = Get.put(IconController());
  final box = GetStorage();

  //--------> Form Variables <--------\\
  final formKey = GlobalKey<FormState>();
  final TaskNameController = TextEditingController().obs;
  final TaskDescriptionController = TextEditingController().obs;
  //--------> Task Variables <--------\\
  var selectedStartTime = TimeOfDay.now().obs;
  // var selectedEndTime = TimeOfDay(
  //   hour: (TimeOfDay.now().hour + 1) % 24,
  //   minute: TimeOfDay.now().minute,
  // ).obs;
  RxDouble duration = 15.0.obs;
  RxInt daysDuration = 0.obs;
  RxInt iconIndex = 0.obs;
  // RxDouble currentSliderValue = .0.obs;
  var tasks = <TimePlannerTask>[].obs;
  RxInt taskUpdateIndex = 0.obs;
  List<Map<String, dynamic>> monthlySessions = [];
  //--------> UI Variables <--------\\
  RxBool showAddTask = false.obs;
  RxBool showFullWidthTask = false.obs;
  RxBool showUpdateTask = false.obs;
  var cellWidth = 0.obs;
  final daysOfWeek = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
  ];
  RxInt currentDay = 0.obs;
  var selectedDays = List<bool>.filled(7, true).obs;

  //-----------------------------> Initialization Functions <-----------------------------------\\
  @override
  void onInit() {
    // clearAllTasks();
    getCurrentDay();
    loadTasksFromStorage();
    updateTime();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkAndUpdateTime();
    });

    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<String> getLocalImagePath(String assetPath) async {
    final supportDir = await getApplicationSupportDirectory();
    final byteData = await rootBundle.load(assetPath);
    final file = File('${supportDir.path}/moon.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }


  void scheduleNotification({
    required String title,
    required String body,
  }) async
  {
    final _winNotifyPlugin = WindowsNotification(
      applicationId: "Second Brain",
    );
    const String url = "assets/images/second_brain.png";

    final imageDir = await getLocalImagePath(url);

    NotificationMessage message = NotificationMessage.fromPluginTemplate(
      body,
      title,
      body,
      image: imageDir,
    );
    _winNotifyPlugin.showNotificationPluginTemplate(message);
  }

  void checkAndUpdateTime() {
    var now = DateTime.now();
    if (now.minute != currentMinute.value) {
      updateTime();
    }
  }

  void updateTime() {
    var now = DateTime.now();
    // print('Updating time${now.minute}');
    currentHour.value = now.hour;
    currentMinute.value = now.minute;

    if (currentHour.value == 0 && currentMinute.value == 1) {
      getCurrentDay();
    }

    int day = 6 - currentDay.value;

    // Iterate over all tasks
    for (var task in tasks) {
      if (task.dateTime.day <= day &&
          (task.dateTime.day + (task.daysDuration ?? 1)) > day) {
        // If the task starts now
        if (task.dateTime.hour == currentHour.value &&
            task.dateTime.minutes == currentMinute.value) {
          // Send notification for task start
          scheduleNotification(
            title: "تذكير بالمهمة",
            body: "حان وقت ${task.title}، ومدته ${task.minutesDuration} دقائق",
          );
        }

        // Calculate task end time
        // DateTime taskEndTime = task.dateTime.add(Duration(minutes: task.minutesDuration));

        DateTime taskEndTime = DateTime(now.year, now.month, now.day,
            task.dateTime.hour, task.dateTime.minutes + task.minutesDuration);

        // If the task is ending now
        if (taskEndTime.hour == currentHour.value &&
            taskEndTime.minute == currentMinute.value) {
          // Send notification for task end
          scheduleNotification(
            title: "انتهاء المهمة",
            body: "لقد انتهت المهمة ${task.title}",
          );

          // Find the next task
          // var nextTask = findNextTask(task);
          // if (nextTask != null) {
          //   DateTime nextTaskTime = DateTime(
          //       now.year, now.month, now.day, nextTask.dateTime.hour, nextTask.dateTime.minutes
          //   );
          //   int nextTaskInMinutes = nextTaskTime.difference(now).inMinutes;
          //   scheduleNotification(
          //     title: "المهمة التالية",
          //     body: "المهمة التالية ${nextTask.title} تبدأ بعد ${nextTaskInMinutes} دقائق",
          //   );
          // }
        }
      }
    }
  }

// // Helper function to compare two TimePlannerDateTime objects
//   int compareTimePlannerDateTime(TimePlannerDateTime a, TimePlannerDateTime b) {
//     if (a.day != b.day) {
//       return a.day.compareTo(b.day);
//     } else if (a.hour != b.hour) {
//       return a.hour.compareTo(b.hour);
//     } else {
//       return a.minutes.compareTo(b.minutes);
//     }
//   }
//
// // Helper function to find the next task
//   TimePlannerTask? findNextTask(TimePlannerTask currentTask) {
//     var nextTasks = tasks.where((task) {
//       // Manually compare the TimePlannerDateTime fields
//       if (task.dateTime.day > currentTask.dateTime.day) {
//         return true;
//       } else if (task.dateTime.day == currentTask.dateTime.day) {
//         if (task.dateTime.hour > currentTask.dateTime.hour) {
//           return true;
//         } else if (task.dateTime.hour == currentTask.dateTime.hour) {
//           return task.dateTime.minutes > currentTask.dateTime.minutes;
//         }
//       }
//       return false;
//     }).toList();
//
//     // Sort tasks based on day, hour, and minute
//     nextTasks.sort((a, b) => compareTimePlannerDateTime(a.dateTime, b.dateTime));
//
//     return nextTasks.isNotEmpty ? nextTasks.first : null;
//   }

  void getCurrentDay() {
    final now = DateTime.now();
    currentDay.value = (now.weekday + 1) % 7;
  }

  void loadTasksFromStorage() {
    final storedTasks = box.read<List>('tasks') ?? [];

    tasks.value = storedTasks.map((task) {
      return TimePlannerTask(
        color: Color(task['color']),
        icon: colorController
            .iconChoices[colorController.iconChoices
                .indexWhere((iconModel) => iconModel.color == task['color'])]
            .icon,
        // icon: colorController.iconChoices[task['iconIndex'] ?? 0].icon,
        title: task['title'],
        dateTime: TimePlannerDateTime(
          day: task['dateTime']['day'],
          hour: task['dateTime']['hour'],
          minutes: task['dateTime']['minutes'],
        ),
        minutesDuration: task['minutesDuration'],
        daysDuration: task['daysDuration'],
        onTap: () {
          showTaskDetailsDialog(
            title: task['title'],
            dayIndex: task['dateTime']['day'],
            hour: task['dateTime']['hour'],
            minutes: task['dateTime']['minutes'],
            duration: task['minutesDuration'],
            daysDuration: task['daysDuration'],
            icon: colorController.iconChoices[task['iconIndex'] ?? 0].icon,
            color: task['color'],
            iconIndex: task['iconIndex'] ?? 0,
          );
        },
      );
    }).toList();
  }

  void resetFormFields() {
    TaskNameController.value.text = '';
    TaskDescriptionController.value.text = '';
    selectedStartTime.value = TimeOfDay.now();

    duration.value = 15;
    colorController.selectedColor.value = colorController.iconChoices[0].color;
    colorController.selectedIcon.value = colorController.iconChoices[0].icon;
  }
  //-----------------------------> Task Management Functions <-----------------------------------\\
  void addAllTasks() {
    // قائمة المهام
    final tasksList = [
      {
        'title': 'استيقاظ، فطور، تمرين خفيف',
        'hour': 6,
        'minutes': 0,
        'duration': 60, // 1 ساعة
        'icon': FontAwesomeIcons.solidBell,
        'color': 0xFFFF6347, // Amber
      },
      {
        'title': 'دراسة مركزة',
        'hour': 7,
        'minutes': 0,
        'duration': 120, // 2 ساعة
        'icon': FontAwesomeIcons.book,
        'color': 0xFF4CAF50, // Light Green
      },
      {
        'title': 'استراحة قصيرة',
        'hour': 9,
        'minutes': 0,
        'duration': 30, // 30 دقيقة
        'icon': FontAwesomeIcons.gamepad,
        'color': 0xFF673AB7, // Deep Purple
      },
      {
        'title': 'عمل على المشروع',
        'hour': 9,
        'minutes': 30,
        'duration': 150, // 2.5 ساعة
        'icon': FontAwesomeIcons.laptopCode,
        'color': 0xFF4CAF50, // Green
      },
      {
        'title': 'غداء واستراحة',
        'hour': 12,
        'minutes': 0,
        'duration': 60, // 1 ساعة
        'icon': FontAwesomeIcons.utensils,
        'color': 0xFFFF9800, // Orange
      },
      {
        'title': 'دراسة',
        'hour': 13,
        'minutes': 0,
        'duration': 90, // 1.5 ساعة
        'icon': FontAwesomeIcons.book,
        'color': 0xFF4CAF50, // Light Green
      },
      {
        'title': 'استراحة',
        'hour': 14,
        'minutes': 30,
        'duration': 30, // 30 دقيقة
        'icon': FontAwesomeIcons.gamepad,
        'color': 0xFF673AB7, // Deep Purple
      },
      {
        'title': 'عمل على المشروع',
        'hour': 15,
        'minutes': 0,
        'duration': 120, // 2 ساعة
        'icon': FontAwesomeIcons.laptopCode,
        'color': 0xFF4CAF50, // Green
      },
      {
        'title': 'تمرين، وقت حر',
        'hour': 17,
        'minutes': 0,
        'duration': 60, // 1 ساعة
        'icon': FontAwesomeIcons.dumbbell,
        'color': 0xFFE91E63, // Pink
      },
      {
        'title': 'عشاء واستراحة',
        'hour': 18,
        'minutes': 0,
        'duration': 60, // 1 ساعة
        'icon': FontAwesomeIcons.utensils,
        'color': 0xFFFF9800, // Orange
      },
      {
        'title': 'دراسة أو عمل جانبي',
        'hour': 19,
        'minutes': 0,
        'duration': 120, // 2 ساعة
        'icon': FontAwesomeIcons.book,
        'color': 0xFF4CAF50, // Light Green
      },
      {
        'title': 'وقت حر',
        'hour': 21,
        'minutes': 0,
        'duration': 60, // 1 ساعة
        'icon': FontAwesomeIcons.gamepad,
        'color': 0xFF673AB7, // Deep Purple
      },


    ];



    // الحصول على الأيام المتصلة
    final connectedDays = findConnectedDays();

    for (var task in tasksList) {
      addTask(
        title: task['title'] as String, // تحويل إلى String
        hour: task['hour'] as int, // تحويل إلى int
        minutes: task['minutes'] as int, // تحويل إلى int
        duration: task['duration'] as int, // تحويل إلى int
        icon: task['icon'] as IconData,
        color: task['color'] as int,
      );
    }

    // إعلام المستخدم بنجاح العملية
    TLoaders.successSnackBar(
        message: 'تمت إضافة المهام بنجاح', title: 'تمت العملية');
  }

  void addTask({
    required String title,
    required int hour,
    required int minutes,
    required int duration,
    required IconData icon,
    required int color,
  }) {
    final connectedDays = findConnectedDays();
    if (title.isEmpty) {
      TLoaders.errorSnackBar(
          message: 'العنوان لا يمكن أن يكون فارغًا', title: 'خطأ');
      return;
    }

    if (!selectedDays.contains(true)) {
      TLoaders.errorSnackBar(
          message: 'يجب اختيار يوم واحد على الأقل', title: 'خطأ');
      return;
    }

    for (var group in connectedDays) {
      final dayIndex = group.first;
      final daysDuration = group.length;
      int iconIndex = colorController.iconChoices.indexWhere((iconModel) => iconModel.icon == icon);
      final task = TimePlannerTask(
        color: Color(color),
        icon: icon,
        iconIndex: iconIndex,
        title: title,
        dateTime: TimePlannerDateTime(
          day: dayIndex,
          hour: hour,
          minutes: minutes,
        ),
        minutesDuration: duration,
        daysDuration: daysDuration,
        onTap: () {
          showTaskDetailsDialog(
            title: title,
            dayIndex: dayIndex,
            hour: hour,
            minutes: minutes,
            duration: duration,
            daysDuration: daysDuration,
            icon: icon,
            color: color,
            iconIndex: iconIndex,
          );
        },
      );
      tasks.add(task);
    }

    TaskNameController.value.clear();
    saveTasksToStorage();

    TLoaders.successSnackBar(
        message: 'تمت إضافة المهمة بنجاح', title: 'تمت العملية');
  }

  void UpdateTask({
    required int? index,
    required String title,
    required int hour,
    required int minutes,
    required int duration,
    required IconData icon,
    required int color,
  }) {
    if (index != null) {
      // Remove the old version of the task
      tasks.removeAt(index);

      // Find connected days based on the toggled days
      final connectedDays = findConnectedDays();
      if (title.isEmpty) {
        TLoaders.errorSnackBar(
            message: 'العنوان لا يمكن أن يكون فارغًا', title: 'خطأ');
        return;
      }

      if (!selectedDays.contains(true)) {
        TLoaders.errorSnackBar(
            message: 'يجب اختيار يوم واحد على الأقل', title: 'خطأ');
        return;
      }

      // Add the tasks in the list at the correct position using insert
      for (var group in connectedDays) {
        final dayIndex = group.first;
        final daysDuration = group.length;
        int iconIndex = colorController.iconChoices
            .indexWhere((iconModel) => iconModel.color == color);
        final task = TimePlannerTask(
          color: Color(color),
          icon: icon,
          iconIndex: iconIndex,
          title: title,
          dateTime: TimePlannerDateTime(
            day: dayIndex,
            hour: hour,
            minutes: minutes,
          ),
          minutesDuration: duration,
          daysDuration: daysDuration,
          onTap: () {
            showTaskDetailsDialog(
              title: title,
              dayIndex: dayIndex,
              hour: hour,
              minutes: minutes,
              duration: duration,
              daysDuration: daysDuration,
              icon: icon,
              color: color,
              iconIndex: iconIndex,
            );
          },
        );

        // Insert the task at the correct position
        tasks.insert(index!, task);
        index++;
      }

      saveTasksToStorage();

      TaskNameController.value.clear();
      showUpdateTask.value = false;
      colorController.selectedIcon.value = Icons.work;
      colorController.selectedName.value = "عمل";
      colorController.selectedColor.value = 0xFF2196F3;

      TLoaders.successSnackBar(
          message: 'تم تحديث المهمة بنجاح', title: 'تمت العملية');
    }
  }

  void removeTask({
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

  void updateTaskDetails(Map<String, dynamic> task) {
    final index = findTaskIndex(
      title: task['title'],
      dayIndex: task['dateTime']['day'],
      hour: task['dateTime']['hour'],
      minutes: task['dateTime']['minutes'],
      duration: task['minutesDuration'],
      daysDuration: task['daysDuration'],
      icon: colorController.iconChoices[task['iconIndex'] ?? 0].icon,
      color: task['color'],
    );

    if (index != null) {
      TaskNameController.value.text = task['title'];
      selectedStartTime.value = TimeOfDay(
          hour: task['dateTime']['hour'], minute: task['dateTime']['minutes']);

      // Calculate end time based on start time and duration

      this.duration.value = task['minutesDuration'].toDouble();
      // final startMinutes =
      // task['dateTime']['hour'] * 60 + task['dateTime']['minutes'];
      // final endMinutes = startMinutes + task['minutesDuration'];
      // selectedEndTime.value = TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60);
      // this.dayIndex.value = task['dateTime']['day'];

      colorController.selectedColor.value = task['color'];
      colorController.selectedIcon.value =
          colorController.iconChoices[task['iconIndex'] ?? 0].icon;

      // Update selectedDays based on daysDuration and dayIndex
      for (int i = 0; i < daysOfWeek.length; i++) {
        if ((6 - i) >= task['dateTime']['day'] &&
            (6 - i) < task['dateTime']['day'] + task['daysDuration'])
          selectedDays[i] = true;
        else
          selectedDays[i] = false;
      }

      taskUpdateIndex.value = index;
      showUpdateTask.value = true;
      showAddTask.value = true;
      Get.back();
    } else {
      TLoaders.warningSnackBar(
          title: 'خطأ', message: 'لم يتم العثور على المهمة');
    }
  }

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
          // task.icon == icon &&
          task.color!.value == color;
      if (matches) {
        return i;
      }
    }
    return null;
  }

  void saveTasksToStorage() {
    final taskList = tasks.map((task) => task.toJson()).toList();
    box.write('tasks', taskList);
  }

  void clearAllTasks() {
    tasks.clear();
    box.write('tasks', []);
  }

  //-----------------------------> UI Interaction Functions <-----------------------------------\\

  void showTaskDetailsDialog({
    required String title,
    required int dayIndex,
    required int hour,
    required int minutes,
    required int duration,
    required int daysDuration,
    required IconData icon,
    required int color,
    required int iconIndex,
  }) {
    Get.defaultDialog(
      title: 'تفاصيل المهمة',
      content: Text(
        ' الاسم : ${title}\n  لمدة : ${(duration ~/ 60).toString().padLeft(2, '0')}h ${(duration % 60 ~/ 1).toString().padLeft(2, '0')}m',
        style: Theme.of(Get.context!).textTheme.bodyMedium,
        textAlign: TextAlign.right,
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text('إغلاق'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          removeTask(
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
            updateTaskDetails({
              'title': title,
              'dateTime': {
                'day': dayIndex,
                'hour': hour,
                'minutes': minutes,
              },
              'minutesDuration': duration,
              'daysDuration': daysDuration,
              'color': color,
              'iconIndex': iconIndex,
            });
          },
          child: Text('تحديث'),
        ),
      ],
    );
  }

  // Future<void> selectTime(BuildContext context, bool isStartTime) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime:
  //         isStartTime ? selectedStartTime.value : selectedEndTime.value,
  //     builder: (BuildContext context, Widget? child) {
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (picked != null) {
  //     if (isStartTime) {
  //       if (picked.hour < selectedEndTime.value.hour ||
  //           (picked.hour == selectedEndTime.value.hour &&
  //               picked.minute < selectedEndTime.value.minute)) {
  //         selectedStartTime.value = picked;
  //       } else {
  //         // Show error or adjust the time
  //         selectedStartTime.value = picked;
  //         selectedEndTime.value = TimeOfDay(
  //           hour: (picked.hour + 1) % 24,
  //           minute: picked.minute,
  //         );
  //       }
  //     } else {
  //       if (picked.hour > selectedStartTime.value.hour ||
  //           (picked.hour == selectedStartTime.value.hour &&
  //               picked.minute > selectedStartTime.value.minute)) {
  //         selectedEndTime.value = picked;
  //       } else {
  //         // Show error or adjust the time
  //         selectedEndTime.value = TimeOfDay(
  //           hour: (selectedStartTime.value.hour + 1) % 24,
  //           minute: selectedStartTime.value.minute,
  //         );
  //       }
  //     }
  //
  //     final startMinutes =
  //         selectedStartTime.value.hour * 60 + selectedStartTime.value.minute;
  //     final endMinutes =
  //         selectedEndTime.value.hour * 60 + selectedEndTime.value.minute;
  //     duration.value = endMinutes - startMinutes;
  //   }
  // }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime.value,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    // selectedEndTime.value = picked!;
    // if (picked != null) {
    //   // if (isStartTime) {
    selectedStartTime.value = picked!;
    //   //   final startMinutes = picked.hour * 60 + picked.minute;
    //   //   final endMinutes = startMinutes + currentSliderValue.value.toInt();
    //   //   selectedEndTime.value = TimeOfDay(
    //   //     hour: endMinutes ~/ 60,
    //   //     minute: endMinutes % 60,
    //   //   );
    //   // } else {

    //   // }
    //   // final startMinutes =
    //       selectedStartTime.value.hour * 60 + selectedStartTime.value.minute;
    //   // final endMinutes =
    //       // selectedEndTime.value.hour * 60 + selectedEndTime.value.minute;
    //   // duration.value = endMinutes - startMinutes;
    // }
  }

  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
  }

  void updateCellWidth(double newWidth) {
    cellWidth.value = newWidth.toInt();
  }

//-----------------------------> Utility Functions <-----------------------------------\\

  List<List<int>> findConnectedDays() {
    List<List<int>> connectedDays = [];
    List<int> currentGroup = [];

    // Convert selectedDays from right-to-left to left-to-right
    List<bool> convertedSelectedDays = List.from(selectedDays.reversed);

    for (int i = 0; i < convertedSelectedDays.length; i++) {
      if (convertedSelectedDays[i]) {
        currentGroup.add(i);
      } else if (currentGroup.isNotEmpty) {
        connectedDays.add(List.from(currentGroup));
        currentGroup.clear();
      }
    }
    if (currentGroup.isNotEmpty) {
      connectedDays.add(currentGroup);
    }

    return connectedDays;
  }
}
