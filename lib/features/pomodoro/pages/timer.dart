import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';

class MyTimer extends StatefulWidget {
  final String breakTime;
  final String workTime;
  final String workSessions;

  const MyTimer({Key? key, required this.breakTime, required this.workTime, required this.workSessions}) : super(key: key);

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<MyTimer> {
  bool _isRunning = false;
  Duration _time = const Duration(minutes: 60);
  Duration _break = const Duration(minutes: 10);
  int _timeInt = 60;
  int _counter = 1;
  int _sessionCount = 4;
  int _timerCount = 0;
  int _currMax = 60;
  Timer? _timer;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    try {
      if (widget.breakTime == '0') {
        throw Exception('Break time cannot be 0');
      }
      _timeInt = int.parse(widget.workTime);
      _time = Duration(minutes: _timeInt);
      _break = Duration(minutes: int.parse(widget.breakTime));
      _sessionCount = int.parse(widget.workSessions);
      _currMax = _timeInt;
    } catch (e) {
      _timeInt = 60;
      _time = Duration(minutes: _timeInt);
      _break = const Duration(minutes: 10);
      _sessionCount = 4;
      Navigator.pop(context);
    }
    _getPrefs();
  }

  void _getPrefs() {
    setState(() {
      // Initialize any required data from GetStorage here if needed
    });
  }

  Future<void> _storeTime() async {
    String? curr = box.read('time');
    var now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    String formattedDate = "${date.day}-${date.month}-${date.year}";
    await box.write('time', '$curr / ${_sessionCount * _timeInt} $formattedDate');
  }

  Future<void> _resetTime() async {
    await box.write('time', '');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _time = _time - const Duration(seconds: 1);
        if (_time.inSeconds <= 0) {
          if (_timerCount % 2 == 1) {
            _time = Duration(minutes: _timeInt);
            _currMax = _timeInt;
            _timerCount++;
          } else {
            _time = _break;
            _currMax = _break.inMinutes;
            _counter++;
            _timerCount++;
          }
          if (_counter > _sessionCount) {
            FocusManager.instance.primaryFocus?.unfocus();
            _storeTime();
            Navigator.pop(context);
          }
          _stopTimer();
          _isRunning = false;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      if (_isRunning) {
        _stopTimer();
      }
      _time = const Duration(minutes: 60);
      if (_timerCount % 2 == 1) {
        _time = Duration(minutes: _break.inMinutes);
      } else {
        _time = Duration(minutes: _timeInt);
      }
      _isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = _time.inMinutes;
    final int seconds = _time.inSeconds % 60;
    String timerState = "Break";
    if (_timerCount % 2 == 0) {
      timerState = '$_counter / $_sessionCount';
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black,
        title: Text.rich(
          TextSpan(
            text: 'Session', // text for title
            style: TextStyle(
              fontSize: 24,
              color: Colors.greenAccent,
              fontFamily: 'Arial',
            ),
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20.0),
            icon: const Icon(Icons.restart_alt, color: Colors.greenAccent, size: 30),
            onPressed: () {
              setState(() {
                _resetTimer();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                    backgroundColor: Colors.black,
                    value: _time.inSeconds / (_currMax * 60), // calculates the progress as a value between 0 and 1
                    strokeWidth: 2,
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 70,
                  child: Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 60,
                      color: Colors.greenAccent,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: 130,
                  child: Text(
                    timerState,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.greenAccent,
                      fontFamily: 'Arial',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isRunning) {
              _stopTimer();
            } else {
              _startTimer();
            }
            _isRunning = !_isRunning;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        mini: false,
        child: _isRunning
            ? const Icon(Icons.pause, color: Colors.greenAccent)
            : const Icon(Icons.play_arrow, color: Colors.greenAccent),
      ),
    );
  }
}