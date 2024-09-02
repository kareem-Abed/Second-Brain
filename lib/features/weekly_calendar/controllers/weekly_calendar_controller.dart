import 'package:al_maafer/common/widgets/loaders/loaders.dart';
import 'package:al_maafer/features/weekly_calendar/controllers/Icon_selector.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:al_maafer/time_planer/time_planner.dart';

class WeeklyCalendarController extends GetxController {
  //--------> Controller Variables <--------\\
  final IconController colorController = Get.put(IconController());
  final box = GetStorage();

  //--------> Form Variables <--------\\
  final formKey = GlobalKey<FormState>();
  final TaskNameController = TextEditingController().obs;
  final TaskDescriptionController = TextEditingController().obs;
  //--------> Task Variables <--------\\
  var selectedStartTime = TimeOfDay.now().obs;
  var selectedEndTime = TimeOfDay(
    hour: (TimeOfDay.now().hour + 1) % 24,
    minute: TimeOfDay.now().minute,
  ).obs;
  RxInt duration = 60.obs;
  RxInt daysDuration = 0.obs;
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
  var selectedDays = List<bool>.filled(7, false).obs;

  //-----------------------------> Initialization Functions <-----------------------------------\\
  @override
  void onInit() {
    getCurrentDay();
    loadTasksFromStorage();
    super.onInit();
  }

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
    selectedEndTime.value = TimeOfDay(
      hour: (TimeOfDay.now().hour + 1) % 24,
      minute: TimeOfDay.now().minute,
    );

    duration.value = 0; // Reset duration
    colorController.selectedColor.value = colorController.iconChoices[0].color;
    colorController.selectedIcon.value = colorController.iconChoices[0].icon;
  }
  //-----------------------------> Task Management Functions <-----------------------------------\\

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
      int iconIndex = colorController.iconChoices
          .indexWhere((iconModel) => iconModel.icon == icon);
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
            .indexWhere((iconModel) => iconModel.icon == icon);
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
      final startMinutes =
          task['dateTime']['hour'] * 60 + task['dateTime']['minutes'];
      this.duration.value = task['minutesDuration'];
      final endMinutes = startMinutes + task['minutesDuration'];
      selectedEndTime.value =
          TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60);
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
        if (picked.hour < selectedEndTime.value.hour ||
            (picked.hour == selectedEndTime.value.hour &&
                picked.minute < selectedEndTime.value.minute)) {
          selectedStartTime.value = picked;
        } else {
          // Show error or adjust the time
          selectedStartTime.value = picked;
          selectedEndTime.value = TimeOfDay(
            hour: (picked.hour + 1) % 24,
            minute: picked.minute,
          );
        }
      } else {
        if (picked.hour > selectedStartTime.value.hour ||
            (picked.hour == selectedStartTime.value.hour &&
                picked.minute > selectedStartTime.value.minute)) {
          selectedEndTime.value = picked;
        } else {
          // Show error or adjust the time
          selectedEndTime.value = TimeOfDay(
            hour: (selectedStartTime.value.hour + 1) % 24,
            minute: selectedStartTime.value.minute,
          );
        }
      }

      final startMinutes =
          selectedStartTime.value.hour * 60 + selectedStartTime.value.minute;
      final endMinutes =
          selectedEndTime.value.hour * 60 + selectedEndTime.value.minute;
      duration.value = endMinutes - startMinutes;
    }
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
