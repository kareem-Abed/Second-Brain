//
// import 'package:flutter/material.dart';
//
// class GroupModel {
//   final String id;
//   final String name;
//   final String monthlyFee;
//   final List<String> sessionDays;
//   final String sessionTime;
//   final List<Map<String, dynamic>> monthlySessions;
//   final int studentCount;
//   final String year;
//   final int order;
//   final Color color;
//   GroupModel({
//     required this.id,
//     required this.name,
//     required this.monthlyFee,
//     required this.sessionDays,
//     required this.sessionTime,
//     required this.monthlySessions,
//     required this.studentCount,
//     required this.year,
//     required this.order,
//     required this.color,
//   });
//
//   GroupModel copyWith({
//     String? id,
//     String? name,
//     String? monthlyFee,
//     List<String>? sessionDays,
//     String? sessionTime,
//     List<Map<String, dynamic>>? monthlySessions,
//     int? studentCount,
//     String? year,
//     int? order,
//     Color? color,
//   }) {
//     return GroupModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       monthlyFee: monthlyFee ?? this.monthlyFee,
//       sessionDays: sessionDays ?? this.sessionDays,
//       sessionTime: sessionTime ?? this.sessionTime,
//       monthlySessions: monthlySessions ?? this.monthlySessions,
//       studentCount: studentCount ?? this.studentCount,
//       year: year ?? this.year,
//       order: order ?? this.order,
//       color: color ?? this.color,
//     );
//   }
//
//   factory GroupModel.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     if (document.data() != null) {
//       final data = document.data() as Map<String, dynamic>;
//       final String colorString = data['color'];
//       final Color color =
//       Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
//       return GroupModel(
//         id: document.id,
//         name: data['groupName'],
//         monthlyFee: data['monthlyFee'],
//         sessionDays: List<String>.from(data['sessionDays']),
//         sessionTime: data['sessionTime'],
//         monthlySessions:
//             List<Map<String, dynamic>>.from(data['monthlySessions']),
//         studentCount: data['studentCount'],
//         year: data['year'],
//         order: data['order']??0,
//         color: color,
//       );
//     } else {
//       return GroupModel.empty();
//     }
//   }
//
//   static GroupModel empty() {
//     return GroupModel(
//       id: '',
//       name: '',
//       monthlyFee: '',
//       sessionDays: [],
//       sessionTime: '',
//       monthlySessions: [],
//       studentCount: 0,
//       year: '',
//       order: 0,
//       color: Colors.red,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'monthlyFee': monthlyFee,
//       'sessionDays': sessionDays,
//       'sessionTime': sessionTime,
//       'monthlySessions':monthlySessions,
//       'studentCount':studentCount,
//       'year': year,
//       'order': order,
//       'color': '#${color.value.toRadixString(16).substring(2)}',
//     };
//   }
// }