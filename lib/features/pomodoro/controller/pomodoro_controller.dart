import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:media_kit/media_kit.dart';

class PomodoroController extends GetxController {
  // Timer state
  RxBool isActive = false.obs;
  RxBool isWorkSession = true.obs;
  RxBool isBreak = false.obs;
  RxBool isPaused = false.obs;
  RxDouble progress = 1.0.obs;
  RxString timerString = "25:00".obs;

  // Session tracking
  RxInt sessionRounds = 0.obs;
  RxInt completedSessions = 0.obs;

  // Settings
  RxInt focusDuration = 25.obs;
  RxInt breakDuration = 5.obs;
  RxInt longBreakDuration = 15.obs;
  RxString sessionName = 'Work'.obs;
  RxInt numberOfSessionRounds = 4.obs;

  Timer? _timer;
  Duration _remainingDuration = const Duration(minutes: 25);
  final box = GetStorage();
  final _windowsAudioPlayer = Player();

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
    sessionName.value = box.read('sessionName') ?? 'Work';
    numberOfSessionRounds.value = box.read('numberOfSessionRounds') ?? 4;
    sessionRounds.value = box.read('sessionCount') ?? 0;
    completedSessions.value = box.read('completedSessions') ?? 0;
  }

  void saveValues() {
    box.write('focusDuration', focusDuration.value);
    box.write('breakDuration', breakDuration.value);
    box.write('longBreakDuration', longBreakDuration.value);
    box.write('sessionName', sessionName.value);
    box.write('sessionCount', sessionRounds.value);
    box.write('completedSessions', completedSessions.value);
    box.write('numberOfSessionRounds', numberOfSessionRounds.value);
  }

  void startFocusSession() {
    isBreak.value = false;
    isWorkSession.value = true;
    isActive.value = true;
    _startTimer(Duration(minutes: focusDuration.value));
  }

  void startBreakSession() {
    isBreak.value = true;
    isWorkSession.value = false;
    isActive.value = true;
    _startTimer(Duration(
        minutes: sessionRounds.value % 4 == 0
            ? longBreakDuration.value
            : breakDuration.value));
  }

  Future<void> playAudio(String path) async {
    try {
      _windowsAudioPlayer.open(Media("asset:///$path"));
    } catch (e) {
      _windowsAudioPlayer.open(Media("asset:///$path"));
    }
  }

  Future<void> _startTimer(Duration duration) async {
    await playAudio("assets/sounds/timesup.mp3");
    _remainingDuration = duration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingDuration.inSeconds > 0) {
        _remainingDuration -= const Duration(seconds: 1);
        progress.value = _remainingDuration.inSeconds / duration.inSeconds;
        timerString.value = _formatDuration(_remainingDuration);
      } else {
        timer.cancel();
        isActive.value = false;
        await playAudio("assets/sounds/clock-alarm.mp3");

        if (isBreak.value) {
          // Break finished, start work session
          isBreak.value = false;
          isWorkSession.value = true;
          progress.value = 1.0;
          timerString.value =
              _formatDuration(Duration(minutes: focusDuration.value));
        } else {
          // Work session finished, start break
          isBreak.value = true;
          isWorkSession.value = false;
          sessionRounds.value += 1;
          completedSessions.value += 1;
          progress.value = 1.0;
          timerString.value =
              _formatDuration(Duration(minutes: breakDuration.value));
        }
        saveValues();
      }
    });
    isPaused.value = false;
  }

  void pauseTimer() {
    _timer?.cancel();
    isPaused.value = true;
    isActive.value = false;
  }

  void resumeTimer() {
    isActive.value = true;
    _startTimer(_remainingDuration);
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
    isActive.value = false;
    isPaused.value = false;
    progress.value = 1.0;
    timerString.value = isBreak.value
        ? _formatDuration(Duration(minutes: breakDuration.value))
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
    isActive.value = false;
    super.onClose();
  }
}
