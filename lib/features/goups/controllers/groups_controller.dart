// import 'dart:async';
//
// import 'package:al_maafer/common/widgets/color_celector/Color_selector.dart';
// import 'package:al_maafer/common/widgets/loaders/loaders.dart';
// import 'package:al_maafer/data/repositories/groups/groups_repository.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:al_maafer/features/goups/models/group_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/get_rx.dart';
// import 'package:intl/intl.dart';
//
// import '../screens/groups/widgets/weekly_calendar_add_update.dart';
//
// class GroupsController extends GetxController {
//   final isLoading = false.obs;
//   final isDeleting = false.obs;
//   final groupNameController = TextEditingController().obs;
//   final groupMonthlyPriceController = TextEditingController().obs;
//   final RxList<GroupModel> groupsList = <GroupModel>[].obs;
//
//   RxInt selectedYear = DateTime.now().year.obs;
//   DateTime selectedYearDateTime = DateTime.now();
//   final formKey = GlobalKey<FormState>();
//   RxString month8Count = '0'.obs;
//   RxList<String> month8 = <String>[].obs;
//   List<String> arabicDays = [];
//   final daysOfWeek = [
//     'السبت',
//     'الأحد',
//     'الاثنين',
//     'الثلاثاء',
//     'الأربعاء',
//     'الخميس',
//     'الجمعة'
//   ];
//   var selectedDays = List<bool>.filled(7, false).obs;
//
//   List<Map<String, dynamic>> monthlySessions = [];
//   void toggleDay(int index) {
//     selectedDays[index] = !selectedDays[index];
//     update();
//     refreshMonthsSessions();
//   }
//
//   void refreshMonthsSessions() {
//     arabicDays.clear();
//     for (int i = 0; i < selectedDays.length; i++) {
//       if (selectedDays[i] == true) {
//         arabicDays.add(daysOfWeek[i]);
//       }
//     }
//
//     collectMonthsSessions(arabicDays);
//   }
//   var selectedTime = TimeOfDay.now().obs;
//   Future<void> selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime.value,
//       builder: (BuildContext context, Widget? child) {
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != selectedTime.value) {
//       selectedTime.value = picked;
//     }
//   }
//
//   @override
//   void onInit() {
//     fetchGroups();
//     super.onInit();
//   }
//
//   void reorderData(int oldindex, int newindex) async {
// // Check if newindex is greater than oldindex and adjust it
//     if (newindex > oldindex) {
//       newindex -= 1;
//     }
//
//     // Create a new list from the stream data
//     List<GroupModel> newList = List.from(groupsList);
//     for (int i = 0; i < newList.length; i++) {
//       if (i == oldindex) {
//         newList[i] = newList[i].copyWith(order: newindex);
//       } else if (i >= newindex && i < oldindex) {
//         newList[i] = newList[i].copyWith(order: i + 1);
//       } else if (i <= newindex && i > oldindex) {
//         newList[i] = newList[i].copyWith(order: i - 1);
//       }
//     }
//
//     final batch = FirebaseFirestore.instance.batch();
//     for (final group in newList) {
//       final docRef =
//           FirebaseFirestore.instance.collection('Groups').doc(group.id);
//       batch.update(docRef, {'order': group.order});
//     }
//
//     await batch.commit();
//   }
//
//   void deleteGroup(String groupId) async {
//     showModalBottomSheet(
//       context: Get.context!,
//       isScrollControlled: true,
//       builder: (context) {
//         return DeleteGroupForm(
//           groupId: groupId,
//         );
//       },
//     );
//   }
//
//   Future<void> deleteStudents(String studentCode) async {
//     // Fetch the student document to get the notebooks assigned to the student
//     DocumentSnapshot studentDoc = await FirebaseFirestore.instance
//         .collection('Students')
//         .doc(studentCode)
//         .get();
//
//     if (studentDoc.exists) {
//       Map<String, dynamic> studentData =
//           studentDoc.data() as Map<String, dynamic>;
//       var notebooksMap =
//           studentData['notebooks'] as Map<String, dynamic>? ?? {};
//       List<dynamic> notebooks = notebooksMap.keys.toList();
//
//       // Iterate through the notebooks and update the studentCount for each
//       for (var notebookId in notebooks) {
//         DocumentReference notebookRef = FirebaseFirestore.instance
//             .collection('Notebooks')
//             .doc(notebookId.toString());
//         FirebaseFirestore.instance.runTransaction((transaction) async {
//           DocumentSnapshot notebookSnapshot =
//               await transaction.get(notebookRef);
//           if (notebookSnapshot.exists) {
//             int currentStudentCount = notebookSnapshot['studentCount'] ?? 0;
//             int updatedStudentCount =
//                 currentStudentCount > 0 ? currentStudentCount - 1 : 0;
//             transaction
//                 .update(notebookRef, {'studentCount': updatedStudentCount});
//           }
//         });
//       }
//
//       await FirebaseFirestore.instance
//           .collection('Students')
//           .doc(studentCode)
//           .delete();
//     }
//   }
//
//   Future<void> deleteGroupAndStudents(String groupId) async {
//     isDeleting.value = true; // Start loading
//
//     // Fetch all students that belong to the group
//     QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
//         .collection('Students')
//         .where('groupID', isEqualTo: groupId)
//         .get();
//
//     // Delete each student document
//     for (var doc in studentSnapshot.docs) {
//       deleteStudents(doc.id);
//     }
//     await removeGroupIdFromNotebooks(groupId);
//     // await Future.delayed(const Duration(seconds: 1));
//     // Delete the group document
//     await FirebaseFirestore.instance.collection('Groups').doc(groupId).delete();
//
//     isDeleting.value = false; // End loading
//     await Future.delayed(const Duration(milliseconds: 500));
//     TLoaders.successSnackBar(
//         title: 'تم الحذف', message: 'تم حذف المجموعة بنجاح');
//     Get.back();
//   }
//
//   Future<void> removeGroupIdFromNotebooks(String groupId) async {
//     // Start by fetching all notebooks
//
//     QuerySnapshot notebookSnapshot = await FirebaseFirestore.instance
//         .collection('Notebooks')
//         .get();
//     // Iterate through each document in the collection
//     for (var doc in notebookSnapshot.docs) {
//       // Check if the 'group' field contains the groupId
//       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//       List<dynamic> groups = data['groups'] as List<dynamic>? ?? [];
//
//       if (groups.contains(groupId)) {
//         // If it contains, remove the groupId
//         await FirebaseFirestore.instance
//             .collection('Notebooks')
//             .doc(doc.id)
//             .update({
//           'groups': FieldValue.arrayRemove([groupId])
//         });
//       }
//
//     }
//   }
//   void addGroup(bool isEdit, String? groupId) async {
//     try {
//       if (formKey.currentState!.validate() && arabicDays.isNotEmpty) {
//         if (isEdit) {
//           await FirebaseFirestore.instance
//               .collection('Groups')
//               .doc(groupId)
//               .update({
//             'groupName': groupNameController.value.text,
//             'monthlyFee': groupMonthlyPriceController.value.text,
//             'sessionDays': arabicDays,
//             'sessionTime': selectedTime.value.format(Get.context!),
//             'monthlySessions': monthlySessions,
//             'year': selectedYear.value.toString(),
//             'color':
//                 '#${colorController.selectedColor.value.value.toRadixString(16).substring(2)}',
//           });
//         } else {
//           await FirebaseFirestore.instance.collection('Groups').add({
//             'groupName': groupNameController.value.text,
//             'monthlyFee': groupMonthlyPriceController.value.text,
//             'sessionDays': arabicDays,
//             'sessionTime': selectedTime.value.format(Get.context!),
//             'monthlySessions': monthlySessions,
//             'year': selectedYear.value.toString(),
//             'color':
//                 '#${colorController.selectedColor.value.value.toRadixString(16).substring(2)}',
//             'studentCount': 0,
//             'order': 100000,
//           });
//         }
//         Get.back();
//       } else {
//         TLoaders.errorSnackBar(
//             title: 'خطاء',
//             message:
//                 'برجاء ادخال البيانات بشكل صحيح و التاكد من اخيار ايام الحصص');
//       }
//     } catch (e) {
//       print('Failed to add group: $e');
//     }
//   }
//
//   void collectMonthsSessions(List<String> arabicDays) {
//     Map<String, String> arabicToEnglishDays = {
//       'الأحد': 'Sunday',
//       'الاثنين': 'Monday',
//       'الثلاثاء': 'Tuesday',
//       'الأربعاء': 'Wednesday',
//       'الخميس': 'Thursday',
//       'الجمعة': 'Friday',
//       'السبت': 'Saturday',
//     };
//
//     List<String> days = arabicDays.map((arabicDay) {
//       return arabicToEnglishDays[arabicDay]!;
//     }).toList();
//
//     List<Map<String, dynamic>> result = [];
//
//     // Generate dates for each month within the specified range and for each specified day
//     int year = selectedYear.value;
//     for (int month = 8; month != 7; month = month % 12 + 1) {
//       // If the month wraps around to 1, increment the year
//       if (month == 1) {
//         year++;
//       }
//
//       List<DateTime> dates = [];
//
//       for (int i = 1; i <= DateTime(year, month % 12 + 1, 0).day; i++) {
//         dates.add(DateTime(year, month, i));
//       }
//
//       List<DateTime> filteredDates = dates.where((date) {
//         return days.contains(DateFormat('EEEE', 'en_US').format(date));
//       }).toList();
//
//       // Format the dates in the desired format
//       List<String> sessions = filteredDates.map((date) {
//         return '${DateFormat('EEEE', 'en_US').format(date)} ${date.day}-$month-$year';
//       }).toList();
//
//       // Add the result to the list
//       result.add({
//         'month': '$month-$year',
//         'sessions': sessions,
//       });
//     }
//
//     // Map of English to Arabic day names
//     Map<String, String> englishToArabicDays = {
//       'Sunday': 'الأحد',
//       'Monday': 'الاثنين',
//       'Tuesday': 'الثلاثاء',
//       'Wednesday': 'الأربعاء',
//       'Thursday': 'الخميس',
//       'Friday': 'الجمعة',
//       'Saturday': 'السبت',
//     };
//
//     // Replace English day names with Arabic ones in the result
//     for (var monthData in result) {
//       for (var i = 0; i < monthData['sessions'].length; i++) {
//         String session = monthData['sessions'][i];
//         String dayName = session.split(' ')[0];
//         if (englishToArabicDays.containsKey(dayName)) {
//           monthData['sessions'][i] =
//               session.replaceFirst(dayName, englishToArabicDays[dayName]!);
//         }
//       }
//     }
//
//     // Return the result
//     //return result;
//     monthlySessions = result;
//
//     month8.assignAll(monthlySessions[0]['sessions']
//         .map<String>((e) => e as String)
//         .toList());
//
//     month8Count.value = '${monthlySessions[0]['sessions'].length} ';
//   }
//
//   void fetchGroups() {
//     isLoading.value = true;
//     GroupsRepository().getAllGroups().listen((group) async {
//       try {
//         groupsList.assignAll(group);
//       } catch (e) {
//         TLoaders.errorSnackBar(title: 'خطاء', message: e.toString());
//       } finally {
//         isLoading.value = false;
//       }
//     });
//   }
//
//   void showAddAndRemoveBottomSheet(
//       {required GroupModel? group, required bool isEdit}) {
//     if (isEdit) {
//       groupNameController.value.text = group!.name;
//       groupMonthlyPriceController.value.text = group.monthlyFee;
//       colorController.selectedColor.value = group.color;
//       selectedTime.value = TimeOfDay.fromDateTime(
//           DateFormat('hh:mm a').parse(group.sessionTime));
//       for (int i = 0; i < daysOfWeek.length; i++) {
//         selectedDays[i] = group.sessionDays.contains(daysOfWeek[i]);
//       }
//       selectedYear.value = int.parse(group.year);
//       refreshMonthsSessions();
//     } else {
//       groupNameController.value.text = '';
//       groupMonthlyPriceController.value.text = '';
//       selectedTime.value = TimeOfDay.now();
//       for (int i = 0; i < daysOfWeek.length; i++) {
//         selectedDays[i] = false;
//       }
//       refreshMonthsSessions();
//     }
//     showModalBottomSheet(
//       context: Get.context!,
//       isScrollControlled: true,
//       builder: (context) {
//         return AddGroupForm(
//           isEdit: isEdit,
//           groupId: isEdit == true ? group!.id : null,
//         );
//       },
//     );
//   }
// }
