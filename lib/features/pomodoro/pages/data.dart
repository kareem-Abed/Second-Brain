import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DataState();
  }
}

class _DataState extends State<Data> {
  final box = GetStorage();
  String _data = '';
  late Map<int, String> _sessions;
  List<String> _dates = [];
  List<String> _sesh = [];
  int _totalMin = 0;
  int _longestSesh = 0;
  int _seshNum = 0;
  double _avgSesh = 0;

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  Future<void> _resetTime() async {
    await box.write('time', '');
  }

  void _getPrefs() {
    setState(() {
      _data = box.read('time') ?? '';
      final split = _data.split('/');

      _sessions = {for (int i = 0; i < split.length; i++) i: split[i]};
      for (int i = 1; i < _sessions.length; i++) {
        _dates.add(_sessions[i]!.split(' ')[2]);
      }
      for (int i = 1; i < _sessions.length; i++) {
        _sesh.add(_sessions[i]!.split(' ')[1]);
        _totalMin += int.parse(_sessions[i]!.split(' ')[1]);
        _seshNum++;
        if (int.parse(_sessions[i]!.split(' ')[1]) > _longestSesh) {
          _longestSesh = int.parse(_sessions[i]!.split(' ')[1]);
        }
      }
      _avgSesh = _totalMin / _seshNum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.black,
        title: const Text.rich(
          TextSpan(
            text: 'Data',
            style: TextStyle(
              fontSize: 24,
              color: Colors.greenAccent,
              fontFamily: 'Arial',
            ),
          ),
        ),
      ),
      body: Container(
        width: 600,
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 0,
                ),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.black,
                    shadowColor: Colors.greenAccent,
                    elevation: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.access_time_filled_outlined,
                            color: Colors.greenAccent,
                            size: 50,
                          ),
                          Text(
                            _totalMin.toString(),
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                            ),
                          ),
                          Text(
                            'total minutes',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontFamily: 'Arial',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.black,
                    shadowColor: Colors.greenAccent,
                    elevation: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.greenAccent,
                            size: 50,
                          ),
                          Text(
                            _longestSesh.toString(),
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                            ),
                          ),
                          Text(
                            'longest session',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontFamily: 'Arial',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.black,
                    shadowColor: Colors.greenAccent,
                    elevation: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.greenAccent,
                            size: 50,
                          ),
                          Text(
                            _seshNum.toString(),
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                            ),
                          ),
                          Text(
                            'number of sessions',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontFamily: 'Arial',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.black,
                    shadowColor: Colors.greenAccent,
                    elevation: 15,
                    child: Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.bar_chart_rounded,
                            color: Colors.greenAccent,
                            size: 50,
                          ),
                          Text(
                            double.parse((_avgSesh).toStringAsFixed(2))
                                .toString(),
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Arial',
                            ),
                          ),
                          Text(
                            'avg session time',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 12,
                              fontFamily: 'Arial',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
