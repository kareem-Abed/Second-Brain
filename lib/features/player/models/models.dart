import 'package:flutter/foundation.dart';

enum Difficulty { easy, medium, hard }
enum TaskStatus { pending, completed }

@immutable
class PlayerStats {
  final int level;
  final double xp;
  final double xpToNext;
  final double gold;
  final String? firstTaskBonusDate; // yyyy-MM-dd

  const PlayerStats({
    this.level = 1,
    this.xp = 0,
    this.xpToNext = 100,
    this.gold = 0,
    this.firstTaskBonusDate,
  });

  PlayerStats copyWith({
    int? level,
    double? xp,
    double? xpToNext,
    double? gold,
    String? firstTaskBonusDate,
  }) {
    return PlayerStats(
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNext: xpToNext ?? this.xpToNext,
      gold: gold ?? this.gold,
      firstTaskBonusDate: firstTaskBonusDate ?? this.firstTaskBonusDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'level': level,
    'xp': xp,
    'xpToNext': xpToNext,
    'gold': gold,
    'firstTaskBonusDate': firstTaskBonusDate,
  };

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      level: json['level'] ?? 1,
      xp: (json['xp'] ?? 0).toDouble(),
      xpToNext: (json['xpToNext'] ?? 100).toDouble(),
      gold: (json['gold'] ?? 0).toDouble(),
      firstTaskBonusDate: json['firstTaskBonusDate'],
    );
  }
}

@immutable
class Task {
  final String id;
  final String title;
  final Difficulty difficulty;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    this.difficulty = Difficulty.easy,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.completedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    Difficulty? difficulty,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'difficulty': difficulty.name,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      difficulty: Difficulty.values
          .firstWhere((e) => e.name == (json['difficulty'] ?? 'easy')),
      status: TaskStatus.values
          .firstWhere((e) => e.name == (json['status'] ?? 'pending')),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
