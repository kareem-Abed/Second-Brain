import 'package:uuid/uuid.dart';

import '../models/models.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class BalanceConfig {
  static const baseXp = {
    Difficulty.easy: 10.0,
    Difficulty.medium: 20.0,
    Difficulty.hard: 35.0,
  };
  static const baseGold = {
    Difficulty.easy: 5.0,
    Difficulty.medium: 10.0,
    Difficulty.hard: 18.0,
  };
}

class RewardEngine {
  static ({double xp, double gold}) rewardFor(Difficulty diff,
      {bool firstTaskOfDay = false}) {
    final multiplier = firstTaskOfDay ? 2.0 : 1.0;
    final xp = (BalanceConfig.baseXp[diff] ?? 10.0) * multiplier;
    final gold = (BalanceConfig.baseGold[diff] ?? 5.0) * multiplier;
    return (xp: xp, gold: gold);
  }
}

class StorageService {
  static const _boxName = 'habit_like_box';
  static const _tasksKey = 'tasks';
  static const _playerKey = 'player';

  final GetStorage _box = GetStorage(_boxName);

  static Future<void> init() async {
    await GetStorage.init(_boxName);
  }

  List<Task> loadTasks() {
    final list = _box.read<List>(_tasksKey) ?? [];
    return list
        .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  void saveTasks(List<Task> tasks) {
    _box.write(_tasksKey, tasks.map((e) => e.toJson()).toList());
  }

  PlayerStats loadPlayer() {
    final data = _box.read<Map>(_playerKey);
    if (data != null) {
      return PlayerStats.fromJson(Map<String, dynamic>.from(data));
    }
    return const PlayerStats();
  }

  void savePlayer(PlayerStats player) {
    _box.write(_playerKey, player.toJson());
  }
}

class PlayerController extends GetxController {
  final StorageService storage;
  PlayerController(this.storage);

  final player = const PlayerStats().obs;

  @override
  void onInit() {
    player.value = storage.loadPlayer();
    super.onInit();
  }

  void reward(Difficulty diff) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final firstTaskToday = player.value.firstTaskBonusDate != today;
    final reward = RewardEngine.rewardFor(diff, firstTaskOfDay: firstTaskToday);

    var newXp = player.value.xp + reward.xp;
    var newGold = player.value.gold + reward.gold;
    var newLevel = player.value.level;
    var xpToNext = player.value.xpToNext;

    if (newXp >= xpToNext) {
      newXp -= xpToNext;
      newLevel++;
      xpToNext *= 1.2;
    }

    player.value = player.value.copyWith(
      xp: newXp,
      gold: newGold,
      level: newLevel,
      xpToNext: xpToNext,
      firstTaskBonusDate: today,
    );
    storage.savePlayer(player.value);
  }
}

class TaskController extends GetxController {
  final StorageService storage;
  final PlayerController playerController;
  TaskController(this.storage, this.playerController);

  final tasks = <Task>[].obs;

  @override
  void onInit() {
    tasks.assignAll(storage.loadTasks());
    super.onInit();
  }

  void addTask(String title, Difficulty diff) {
    final task = Task(
      id: const Uuid().v4(),
      title: title,
      difficulty: diff,
      createdAt: DateTime.now(),
    );
    tasks.add(task);
    storage.saveTasks(tasks);
  }

  void completeTask(Task task) {
    final updated = task.copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
    tasks[tasks.indexWhere((t) => t.id == task.id)] = updated;
    storage.saveTasks(tasks);
    playerController.reward(task.difficulty);
  }
}

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  Difficulty selectedDiff = Difficulty.easy;

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),
            const SizedBox(height: 20),
            DropdownButton<Difficulty>(
              value: selectedDiff,
              items: Difficulty.values
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text(d.name.toUpperCase()),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedDiff = val!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  taskController.addTask(titleController.text, selectedDiff);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            )
          ],
        ),
      ),
    );
  }
}

class Tasks extends StatelessWidget {
  const Tasks({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();

    final playerControllerr = PlayerController(storage);

    final taskController = Get.put(TaskController(storage, playerControllerr));
    final playerController = Get.put(playerControllerr);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Habit MVP"),
      ),
      body: Column(
        children: [
          Obx(() {
            final p = playerController.player.value;
            return ListTile(
              title: Text("Level ${p.level}"),
              subtitle: Text("XP: ${p.xp}/${p.xpToNext} | Gold: ${p.gold}"),
            );
          }),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: taskController.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.difficulty.name.toUpperCase()),
                      trailing: task.status == TaskStatus.pending
                          ? IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () =>
                                  taskController.completeTask(task),
                            )
                          : const Icon(Icons.check, color: Colors.green),
                    );
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddTaskPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
