import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:path/path.dart' as path;
import 'dart:io';

import 'package:simple_audio/simple_audio.dart';

class PomodoroController extends GetxController {
  //History variables
  RxInt totalMin = 0.obs;
  RxInt longestSesh = 0.obs;
  RxInt sessionNum = 0.obs;
  RxDouble avgSesh = 0.0.obs;
// -------------------------------

  RxDouble progress = 1.0.obs;
  RxBool showSettings = true.obs;
  RxBool isBreak = false.obs;
  RxBool isPaused = false.obs;
  RxString timerString = "25:00".obs;
  RxInt sessionCount = 0.obs;
  RxInt focusDuration = 25.obs;
  RxInt breakDuration = 5.obs;
  RxInt longBreakDuration = 15.obs;
  RxString sessionName = ''.obs;
  RxInt numberOfSubSessions = 4.obs;
  RxList<Map<String, dynamic>> sessionHistory = <Map<String, dynamic>>[].obs;

  Timer? _timer;
  Duration _remainingDuration = Duration(minutes: 25);

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadValues();
    timerString.value = _formatDuration(Duration(minutes: focusDuration.value));
  }

  void loadValues() {
    focusDuration.value = box.read('focusDuration') ?? 25;
    breakDuration.value = box.read('breakDuration') ?? 5;
    longBreakDuration.value = box.read('longBreakDuration') ?? 15;
    sessionName.value = box.read('sessionName') ?? '';
    numberOfSubSessions.value = box.read('numberOfSubSessions') ?? 4;
    sessionCount.value = box.read('sessionCount') ?? 0;
    sessionHistory.value =
        box.read('sessionHistory')?.cast<Map<String, dynamic>>() ?? [];
    _getPrefs();
  }

  void _getPrefs() {
    totalMin.value = 0;
    longestSesh.value = 0;
    sessionNum.value = 0;
    avgSesh.value = 0.0;

    for (var session in sessionHistory) {
      int duration = session['totalDuration'];
      totalMin.value += duration;
      sessionNum.value++;
      if (duration > longestSesh.value) {
        longestSesh.value = duration;
      }
    }

    if (sessionNum.value > 0) {
      avgSesh.value = totalMin.value / sessionNum.value;
    }
  }

  void saveValues() {
    box.write('focusDuration', focusDuration.value);
    box.write('breakDuration', breakDuration.value);
    box.write('longBreakDuration', longBreakDuration.value);
    box.write('sessionName', sessionName.value);
    box.write('sessionCount', sessionCount.value);
    box.write('numberOfSubSessions', numberOfSubSessions.value);
    box.write('sessionHistory', sessionHistory.value);
    print(sessionHistory.value);
    _getPrefs();
  }

  void startFocusSession() {
    isBreak.value = false;
    _startTimer(Duration(minutes: focusDuration.value), sessionName.value);
  }

  void startBreakSession() {
    isBreak.value = true;
    _startTimer(
        Duration(
            minutes: sessionCount % 4 == 0
                ? longBreakDuration.value
                : breakDuration.value),
        sessionName.value);
  }

  Future<String> getFullFilePathWindows(String fileName) async {
    // Get the directory where the application is running
    final directory = Directory.current;

    // Combine directory path with the file name to get the full path
    final fullPath = path.join(directory.path, fileName);

    // Check if the file exists
    if (await File(fullPath).exists()) {
      return fullPath;
    } else {
      throw Exception('File not found');
    }
  }

  playAudio(String path) async {
    final SimpleAudio player = SimpleAudio(shouldNormalizeVolume: true);
    player.playbackState.listen((state) => print(state));
    player.progressState.listen((state) => print(state));

    player.open(path);
  }

  Future<void> _startTimer(Duration duration, String sessionName) async {
    await playAudio('assets/sounds/timesup.mp3');

    _remainingDuration = duration;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_remainingDuration.inSeconds > 0) {
        _remainingDuration -= Duration(seconds: 1);
        progress.value = _remainingDuration.inSeconds /
            Duration(
                    minutes: isBreak.value
                        ? (sessionCount % 4 == 0
                            ? longBreakDuration.value
                            : breakDuration.value)
                        : focusDuration.value)
                .inSeconds;
        timerString.value = _formatDuration(_remainingDuration);
      } else {
        timer.cancel();

        await playAudio('assets/sounds/clock-alarm.mp3');
        if (isBreak.value) {
          isBreak.value = false;
          progress.value = 1.0;
          timerString.value =
              _formatDuration(Duration(minutes: focusDuration.value));
        } else {
          isBreak.value = true;
          progress.value = 1.0;
          sessionCount.value += 1;

          timerString.value =
              _formatDuration(Duration(minutes: breakDuration.value));
          // Check if session already exists in history
          int existingSessionIndex = sessionHistory
              .indexWhere((session) => session['sessionName'] == sessionName);
          if (existingSessionIndex != -1) {
            // Update existing session
            sessionHistory[existingSessionIndex]['subSessions'] =
                sessionCount.value;
            sessionHistory[existingSessionIndex]['totalDuration'] +=
                duration.inMinutes;
          } else {
            // Add new session
            sessionHistory.add({
              "sessionName": sessionName,
              "subSessions": sessionCount.value,
              "totalDuration": duration.inMinutes
            });
          }
        }
        saveValues();
      }
    });
    isPaused.value = false;
  }

  void pauseTimer() {
    _timer?.cancel();
    isPaused.value = true;
  }

  void resumeTimer() {
    _startTimer(_remainingDuration,
        isBreak.value ? sessionName.value : sessionName.value);
  }

  void toggleTimer() {
    if (isPaused.value) {
      resumeTimer();
    } else {
      pauseTimer();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    progress.value = 1.0;
    timerString.value = isBreak.value
        ? _formatDuration(Duration(
            minutes: sessionCount % 4 == 0
                ? longBreakDuration.value
                : breakDuration.value))
        : _formatDuration(Duration(minutes: focusDuration.value));
    _remainingDuration = isBreak.value
        ? Duration(minutes: breakDuration.value)
        : Duration(minutes: focusDuration.value);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
